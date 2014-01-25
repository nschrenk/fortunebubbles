package;

import Bubble;
import GameController;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.media.Sound;
import flash.text.TextField;
import flash.text.TextFormat;
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
        Red => new ColorBubbleData ("bubblered.png", "bubble_popped.png",
                                    {r: 255, g: 0, b: 0}),
        Orange => new ColorBubbleData ("bubbleorange.png", "bubble_popped.png",
                                       {r: 255, g: 165, b: 0}),
        Yellow => new ColorBubbleData ("bubbleyellow.png", "bubble_popped.png",
                                       {r: 245, g: 245, b: 0}),
        Green => new ColorBubbleData ("bubble.png", "bubble_popped.png",
                                       {r: 0, g: 230, b: 0}),
        Blue => new ColorBubbleData ("bubbleblue.png", "bubble_popped.png",
                                       {r: 0, g: 0, b: 240}),
        Purple => new ColorBubbleData ("bubble.png", "bubble_popped.png",
                                       {r: 220, g: 0, b: 220}),
        Black => new ColorBubbleData ("bubble.png", "bubble_popped.png",
                                       {r: 10, g: 10, b: 10}),
        White => new ColorBubbleData ("bubble.png", "bubble_popped.png",
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


class Panel extends Sprite {
    private var textField_ : TextField;

    public function new () {
        super ();

        var font = Assets.getFont ("assets/Palo_Alto_Regular.ttf");
        var format = new TextFormat ("arial.ttf", 30, 0x7A0026);
        textField_ = new TextField ();
        textField_.defaultTextFormat = format;
        textField_.embedFonts = true;
        textField_.selectable = false;

        addChild (this.textField_);
	    this.addEventListener (Event.RENDER, this.onRender);        
    }

    public function setText (text : String) {
        this.textField_.text = text;
    }

    public function onRender (event : Event) {
        // neko.Lib.print ("Panel.onRender\n");
        if (this.textField_.width != this.width) {
            this.textField_.width = this.width;
        }
    }

}


class BubbleBoard extends Sprite {
    private var minRows_ : Int;
    private var minCols_ : Int;
    private var rows_ : Int;
    private var columns_ : Int;
    private var bubbleArr_ : Array<Array<Bubble>>;
    private var scaling_ : Float;
    private var panelRect_ : Rectangle;
    private var panel_ : Panel;
    private var controller_ : GameController;

    private function calculateScaling (bubbleWidth:Float,
                                       bubbleHeight:Float) : Void
    {
        // Based on the stage dimensions, board size, and bubble graphic dimensions
        // determines how to scale the bubbles and how many actual rows and columns
        // to use.
        var panelHeight : Int = 50;
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
        this.panelRect_ = new Rectangle (0, sh - panelHeight, sw, panelHeight);
        // neko.Lib.print ("rows = " + rows_ + " cols = " + columns_ + "\n");
    }

    public function new (minRows:Int, minCols:Int) {
        super ();

        this.minRows_ = minRows;
        this.minCols_ = minCols;
    }

 
    public function initialize () {
        // This is hacky: git a bitmap for an arbitrary color to see
        // how large the graphics are and then use that size for scaling.
        // Hopefully all the bubble images are the same size!
        var d = ColorBubbleData.forColor (Red);
        var bubbleBmData = Assets.getBitmapData ("assets/" + d.bitmapAsset);
        this.calculateScaling (bubbleBmData.width, bubbleBmData.height); 
        this.controller_ = new GameController (this.rows_, this.columns_);
        this.scaleX = this.scaling_;
        this.scaleY = this.scaling_;


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
                row.push(bubble);
                addChild(bubble);
            }
        } 

    }

    public function controller () : GameController {
        return this.controller_;
    }

}


class Main extends Sprite {
   
    private var board_ : BubbleBoard;
    private var panel_ : Panel;
    private var cacheX : Float;
    private var cacheY : Float;
 
    public function new () {
        super ();

        var minRows = 9;
        var minCols = 7;
        this.board_ = new BubbleBoard (minRows, minCols);

        var panelHeight = 50;
        this.board_.x = 0;
        this.board_.y = 0;
        this.board_.width = stage.stageWidth;
        this.board_.height = panelHeight;

        addChild (this.board_); 
        this.board_.initialize ();

        panel_ = new Panel ();
        panel_.x = 0;
        panel_.y = stage.stageHeight - panelHeight;
        panel_.width = stage.stageWidth;
        panel_.height = panelHeight;
        panel_.setText ("Fortune Bubble!");
        addChild (panel_);
        // neko.Lib.print ("panel rect = " + panel_.x + ", " + panel_.y + ", " + panel_.width + ", " + panel_.height + "\n");

        // neko.Lib.print ("stage width =" + stage.stageWidth + " height = " + stage.stageHeight + "\n");

        // stage.addEventListener (MouseEvent.MOUSE_DOWN, stage_onMouseDown);
    }
    
    private function stage_onMouseDown (event:MouseEvent):Void {
        cacheX = event.stageX;
        cacheY = event.stageY;

        stage.addEventListener (MouseEvent.MOUSE_MOVE, stage_onMouseMove);
        stage.addEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
    }


    private function stage_onMouseMove (event:MouseEvent):Void {
        // xxx
    }


    private function stage_onMouseUp (event:MouseEvent):Void {
        // if (Destination.hitTestPoint (event.stageX, event.stageY)) {
        //    Actuate.tween (Logo, 1, { x: Destination.x + 5, y: Destination.y + 5 } );
        // }

        stage.removeEventListener (MouseEvent.MOUSE_MOVE, stage_onMouseMove);
        stage.removeEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
    } 

}
