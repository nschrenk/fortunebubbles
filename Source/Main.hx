package;

import Bubble;
import Data;
import GameController;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.media.Sound;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.utils.Timer;
import openfl.Assets;
import Std;

class ColorBubbleData {
    public var bitmapAsset : String;
    public var bitmapPoppedAsset : String;
    public var rgb : Rgb;

    public function new (bitmap:String, bitmapPopped:String, rgb : Rgb ) {
        this.bitmapAsset = bitmap;
        this.bitmapPoppedAsset = bitmapPopped;
        this.rgb = rgb;
    } 

    public static var data:Map<Color, ColorBubbleData> = [
        Red => new ColorBubbleData ("redbubble.png", "redafterpop.png",
                                    {r: 255, g: 0, b: 0}),
        Orange => new ColorBubbleData ("orangebubble.png", "orangeafterpop.png",
                                       {r: 255, g: 165, b: 0}),
        Yellow => new ColorBubbleData ("yellowbubble.png", "yellowafterpop.png",
                                       {r: 245, g: 245, b: 0}),
        Green => new ColorBubbleData ("greenbubble.png", "greenafterpop2.png",
                                       {r: 0, g: 230, b: 0}),
        Blue => new ColorBubbleData ("bluebubble.png", "blueafterpop.png",
                                       {r: 0, g: 0, b: 240}),
        Purple => new ColorBubbleData ("purplebubble.png", "purpleafterpop.png",
                                       {r: 220, g: 0, b: 220}),
        Black => new ColorBubbleData ("blackbubble.png", "blackafterpop.png",
                                       {r: 10, g: 10, b: 10}),
        White => new ColorBubbleData ("whitebubble.png", "whiteafterpop.png",
                                       {r: 255, g: 255, b: 255}),
    ];

    public static function forColor (color : Color) : ColorBubbleData {
        return ColorBubbleData.data[color];
    }

    public static function createBubble(color : Color, row : Int, col : Int,
                                        controller : GameController) : Bubble {
        var d = forColor (color);
        var bubbleBmData = Assets.getBitmapData ("assets/" + d.bitmapAsset);
        var poppedBmData = Assets.getBitmapData ("assets/" + d.bitmapPoppedAsset); 
        var bubble = new Bubble(bubbleBmData, poppedBmData, row, col);

        var popSound = Assets.getSound ("assets/pop_sound.wav");
        bubble.setPopSound (popSound);
        bubble.setController (controller);
        return bubble;
    }

}


class BubbleBoard extends Sprite {
    private var minRows_ : Int;
    private var minCols_ : Int;
    private var rows_ : Int;
    private var columns_ : Int;
    private var bubbleArr_ : Array<Array<Bubble>>;
    private var scaling_ : Float;
    private var controller_ : GameController;
    private var timer_ : Timer;

    private function calculateScaling (bubbleWidth:Float,
                                       bubbleHeight:Float) : Void
    {
        // Based on the stage dimensions, board size, and bubble graphic dimensions
        // determines how to scale the bubbles and how many actual rows and columns
        // to use.
        var panelHeight : Int = 80;
        var sw:Float = stage.stageWidth;
        var sh:Float = stage.stageHeight - panelHeight;
        var bw:Float = sw / this.minCols_;
        var bh:Float = sh / this.minRows_;
        var wRatio:Float = bw / bubbleWidth;
        var hRatio:Float = bh / bubbleHeight;
        var scaleFactor = Math.min(wRatio, hRatio);
        this.scaling_ = scaleFactor;
        this.columns_ = Math.floor (sw / (bubbleWidth * scaleFactor));
        this.rows_ = Math.floor (sh / (bubbleHeight * scaleFactor));
        // neko.Lib.print ("rows = " + rows_ + " cols = " + columns_ + "\n");
    }

    public function new (minRows:Int, minCols:Int) {
        super ();

        this.minRows_ = minRows;
        this.minCols_ = minCols;
        this.blendMode = BlendMode.LAYER;
    }

 
    public function initialize () {
        // This is hacky: get a bitmap for an arbitrary color to see
        // how large the graphics are and then use that size for scaling.
        // Hopefully all the bubble images are the same size!
        var d = ColorBubbleData.forColor (Red);
        var bubbleBmData = Assets.getBitmapData ("assets/" + d.bitmapAsset);
        this.calculateScaling (bubbleBmData.width, bubbleBmData.height); 
        this.controller_ = new GameController (this.rows_, this.columns_);
        this.scaleX = this.scaling_;
        this.scaleY = this.scaling_;
        this.reset(true);
    }

    public function reset (first_time : Bool) {
        if (!first_time) {
            controller_.reset ();
        } 

        var nc = this.numChildren;
        for (i in 0...nc) {
            removeChildAt(0);
        }

        bubbleArr_ = new Array<Array<Bubble>>();

        for (h in 0...rows_) {
            var row = new Array<Bubble>();
            bubbleArr_.push(row);

            for (w in 0...columns_) {
                var st = controller_.stateAt(w, h); 
                var bubble = ColorBubbleData.createBubble (st.color, h, w,
                                                           controller_);
                bubble.x = w * bubble.width;
                bubble.y = h * bubble.height;
                // bubble.blendMode = BlendMode.ALPHA;

                row.push(bubble);
                addChild(bubble);
            }
        } 
        
        timer_ = new Timer (200);
        timer_.addEventListener (TimerEvent.TIMER, this.animate);

    }

    private function animate (event : TimerEvent) {
        // xxx
        trace ("animate");
    }

    public function controller () : GameController {
        return this.controller_;
    }
}

class Instructions extends Sprite {

    public function new () {
        super ();
    }

    public function initialize() {
        var bg = new Sprite ();
        // bg.opaqueBackground = 0x333333;
        // bg.alpha = 0.5;
        bg.width = this.width;
        bg.height = this.height;
        addChild (bg);

        var bmData = Assets.getBitmapData("assets/instructionpage.jpg");
        var bm = new Bitmap(bmData);
        var x = 0;
        var y = 0;
        var wRatio:Float = (stage.stageWidth / bmData.width);
        var hRatio:Float = (stage.stageHeight / bmData.height);
        var scaleFactor = Math.min(wRatio, hRatio);
        if (wRatio < hRatio) {
            // there will be empty vertical space
            y = Math.floor((stage.stageHeight - (scaleFactor * bmData.height)) / 2);
        } else {
           // there will be empty horizontal space
            x = Math.floor((stage.stageWidth - (scaleFactor * bmData.width)) / 2);
        }
        bm.x = x;
        bm.y = y; 
        bm.scaleX = scaleFactor;
        bm.scaleY = scaleFactor;

        addChild(bm);
    }

}

class FortuneDialog extends Sprite {
    static var width_ = 400;
    static var height_ = 600;
    var words_ : Array<String>;
    var title_ : String;
    var fortune_ : String;
    var quitFunc_ : FortuneDialog -> Void;

    public function new (words : Array<String>, title : String,
                         fortune : String, quitFunc : FortuneDialog -> Void) {
        super ();

        words_ = words;
        title_ = title;
        fortune_ = fortune;
        quitFunc_ = quitFunc;
        width = width_;
        height = height_;
        this.buttonMode = true;
    }

    public function centerIt (widget : DisplayObject) {
        widget.x = (width_ - widget.width) / 2;
        // widget.y = (height - widget.height) / 2;
    }

    public function initialize () {
        var font = Assets.getFont ("assets/Palo_Alto_Regular.ttf");
        var titleFormat = new TextFormat (font.fontName, 35, 0x2B3252);
        var tt = new TextField ();
        tt.defaultTextFormat = titleFormat;
        tt.embedFonts = true;
        tt.selectable = false;
        tt.background = false;
        tt.autoSize = TextFieldAutoSize.LEFT;
        tt.type = TextFieldType.DYNAMIC;
        tt.text = title_;
        tt.x = 30;
        tt.y = 20;
        tt.width = width_ - 40;
        addChild (tt);
        centerIt (tt);

        var fortuneFormat = new TextFormat (font.fontName, 25, 0x2B2D52);
        var ft = new TextField ();
        ft.defaultTextFormat = fortuneFormat;
        ft.embedFonts = true;
        ft.selectable = false;
        ft.background = false;
        ft.autoSize = TextFieldAutoSize.LEFT;
        ft.type = TextFieldType.DYNAMIC;
        ft.wordWrap = true;
        ft.multiline = true;
        ft.text = fortune_;
        ft.x = 30;
        ft.y = 200;
        ft.width = width_ - 40;
        ft.height = height_ - 120;
        addChild (ft);
        centerIt (ft);

	    this.graphics.beginFill (0xDDDDFF);
        this.graphics.drawRoundRect (0, 0, width_, height_, 8);
	    this.graphics.beginFill (0xAACCEE);
        this.graphics.drawRoundRect (10, 10, width_ - 20, height_ - 20, 7);

        addEventListener (MouseEvent.CLICK,
                          this.onInstructionsClicked);
	    addEventListener (TouchEvent.TOUCH_TAP,
                          this.onInstructionsTapped);
    }

    public function onInstructionsClicked (event : MouseEvent) {
        quitFunc_ (this);
    }

    public function onInstructionsTapped (event : TouchEvent) {
        quitFunc_ (this);
    }
}

class Main extends Sprite implements GameListener {
   
    private var board_ : BubbleBoard;
    private var panel_ : Panel;
    private var background_ : Bitmap;
    private var instructions_ : Instructions;
    private var drop_words_ : Array<String>;
 
    public function new () {
        super ();

        displaySplash();
    }

    public function displaySplash() {
        var splashData = Assets.getBitmapData("assets/splashscreen.jpg");
        var splash = new Bitmap(splashData);
        splash.scaleX = (stage.stageWidth / splashData.width);
        splash.scaleY = (stage.stageHeight / splashData.height);
        addChild(splash);
        
        var timer = new Timer (5000, 1);
        timer.addEventListener (TimerEvent.TIMER, this.afterSplash);
        timer.start ();
    }

    public function afterSplash(event : TimerEvent) {
        removeChildAt (0); // splash screen bitmap

        var panelHeight = 80;
        var minRows = 9;
        var minCols = 7;

        var bgData = Assets.getBitmapData("assets/background1.jpg");
        background_ = new Bitmap(bgData);
        background_.scaleX = (stage.stageWidth / bgData.width);
        background_.scaleY = ((stage.stageHeight - panelHeight) / bgData.height);
        addChild(background_);

        board_ = new BubbleBoard (minRows, minCols);
        board_.x = 0;
        board_.y = 0;
        board_.width = stage.stageWidth;
        board_.height = panelHeight;

        panel_ = new Panel ();
        panel_.x = 0;
        panel_.y = stage.stageHeight - panelHeight;
        panel_.width = stage.stageWidth;
        panel_.height = panelHeight;
        addChild (panel_);
        panel_.initialize();
        panel_.setText ("Pop 7 Bubbles To Reveal Your Fortune");


        instructions_ = new Instructions ();
	    instructions_.addEventListener (MouseEvent.CLICK,
                                        this.onInstructionsClicked);
	    instructions_.addEventListener (TouchEvent.TOUCH_TAP,
                                        this.onInstructionsTapped);
        addChild(instructions_);
        instructions_.initialize();

    }

    public function reset () {
        drop_words_ = new Array<String> ();
        if (board_.parent == null) {
            addChild (board_);
            board_.initialize ();
            board_.controller().setListener (this);
        } else {
            board_.reset (false);
            panel_.setText ("Pop 7 Bubbles To Reveal Your Fortune");
        }
    }

    public function onInstructionsClicked (event : MouseEvent) {
        instructions_.removeEventListener (MouseEvent.CLICK,
                                           this.onInstructionsClicked); 
	    instructions_.removeEventListener (TouchEvent.TOUCH_TAP,
                                           this.onInstructionsTapped);
        removeChild(instructions_);
        reset();
    }

    public function onInstructionsTapped (event : TouchEvent) {
        instructions_.removeEventListener (MouseEvent.CLICK,
                                           this.onInstructionsClicked); 
	    instructions_.removeEventListener (TouchEvent.TOUCH_TAP,
                                           this.onInstructionsTapped);
        removeChild(instructions_);
        reset();
    }

    public function onPop (drop_word : String) {
        drop_words_.push (drop_word);
        var text = "";
        for (w in drop_words_) {
            if (text != "") {
                text += ", ";
            }
            text += w;
        }
        panel_.setText (text);
    }

    public function onGameEnd (title : String, fortune : String) {
        var chime = Assets.getSound ("assets/magic-chime-01.wav");
        chime.play ();
        // xxx delay this with a timer + callback or something?
        var dialog = new FortuneDialog (drop_words_, title, fortune,
                                    this.onFortuneDialogComplete);
        addChild (dialog);
        dialog.initialize();
        dialog.x = (width - dialog.width) / 2;
        dialog.y = (height - dialog.height) / 2;
        // panel_.setText ("Behold Your Fortune!");
    }

    public function onFortuneDialogComplete (dialog : FortuneDialog) : Void {
        removeChild (dialog);
        reset ();
    }


}
