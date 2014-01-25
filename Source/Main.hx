package;

import Bubble;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.media.Sound;
import openfl.Assets;
import Std;

enum Color {
    Red;
    Orange;
    Yellow;
    Green;
    Blue;
    Purple;
    Black;
    White;
}


class ColorBubbleData {
    public var bitmapAsset:String;
    public var bitmapPoppedAsset:String;

    public function new (bitmap:String, bitmapPopped:String) {
        this.bitmapAsset = bitmap;
        this.bitmapPoppedAsset = bitmapPopped;
    } 

    public static var data:Map<Color, ColorBubbleData> = [
        Red => new ColorBubbleData ("bubblered.png", "bubble_popped.png"),
        Orange => new ColorBubbleData ("bubbleorange.png", "bubble_popped.png"),
        Yellow => new ColorBubbleData ("bubbleyellow.png", "bubble_popped.png"),
        Green => new ColorBubbleData ("bubble.png", "bubble_popped.png"),
        Blue => new ColorBubbleData ("bubbleblue.png", "bubble_popped.png"),
        Purple => new ColorBubbleData ("bubble.png", "bubble_popped.png"),
        Black => new ColorBubbleData ("bubble.png", "bubble_popped.png"),
        White => new ColorBubbleData ("bubble.png", "bubble_popped.png"),
    ];

    public static function forColor (color : Color) : ColorBubbleData {
        return ColorBubbleData.data[color];
    }

    public static function createBubble(color : Color) : Bubble {
        var d = forColor (color);
        var bubbleBmData = Assets.getBitmapData ("assets/" + d.bitmapAsset);
        var poppedBmData = Assets.getBitmapData ("assets/" + d.bitmapPoppedAsset); 
        var bubble = new Bubble(bubbleBmData, poppedBmData);

        var popSound = Assets.getSound ("assets/pop_sound.wav");
        bubble.setPopSound(popSound);
        return bubble;
    }

}

typedef BubbleState = {
    color : Color,
    popped : Bool
}
 
class GameController {
    var rows_ : Int;
    var cols_ : Int;
  
   
    var state_ : Array<Array<BubbleState>>;


    public function new (rows : Int, cols : Int) {
        this.rows_ = rows;
        this.cols_ = cols;

        this.state_ = new Array<Array<BubbleState>> ();

        for (i in 0...rows) {
           var row = new Array<BubbleState> ();
           this.state_.push (row);
           for (j in 0...cols) {
                var st : BubbleState = { color : randomColor(), popped : false };
                row.push (st);
           }
        }
    }

    public static function randomColor ():Color {
        var i : Int = Std.random (8);
        var c : Color;
        switch (i) {
            case 0: c = Red;
            case 1: c = Orange;
            case 2: c = Yellow;
            case 3: c = Green;
            case 4: c = Blue;
            case 5: c = Purple;
            case 6: c = Black;
            case 7: c = White;
            default: c = Red;
        }
        return c;
    }

    public function stateAt (col:Int, row:Int):BubbleState {
        return this.state_[row][col]; 
    }

    public function onPopped(row:Int, col:Int) {
        // Invoked when a bubble is popped
    } 
}


class BubbleBoard extends Sprite {
    private var rows_ : Int;
    private var columns_ : Int;
    private var bubbleArr_ : Array<Array<Bubble>>;
    private var scaling_ : Float;
    private var controller_ : GameController;

    private function calculateScaling (rows:Int, columns:Int, bubbleWidth:Float, bubbleHeight:Float):Float {
        // Based on the stage dimensions, board size, and bubble graphic dimensions
        // determines how to scale the bubbles.
        var sw:Float = stage.stageWidth;
        var sh:Float = stage.stageHeight;
        var bw:Float = sw / columns;
        var bh:Float = sh / rows;
        var wRatio:Float = bw / bubbleWidth;
        var hRatio:Float = bh / bubbleHeight;
        return Math.min(wRatio, hRatio);
    }

    public function new (rows:Int, columns:Int) {
        super ();

        this.rows_ = rows;
        this.columns_ = columns;
        this.controller_ = new GameController (rows, columns);
    }

 
    public function initialize () {
        // This is hacky: git a bitmap for an arbitrary color to see
        // how large the graphics are and then use that size for scaling.
        // Hopefully all the bubble images are the same size!
        var d = ColorBubbleData.forColor (Red);
        var bubbleBmData = Assets.getBitmapData ("assets/" + d.bitmapAsset);
        this.scaling_ = calculateScaling (this.rows_, this.columns_,
                                          bubbleBmData.width,
                                          bubbleBmData.height);
        this.scaleX = this.scaling_;
        this.scaleY = this.scaling_;


        bubbleArr_ = new Array<Array<Bubble>>();
 
        for (h in 0...rows_) {
            var row = new Array<Bubble>();
            bubbleArr_.push(row);

            for (w in 0...columns_) {
                var st = controller_.stateAt(w, h); 
                var bubble = ColorBubbleData.createBubble (st.color);
                bubble.x = w * bubble.width;
                bubble.y = h * bubble.height;
                row.push(bubble);
                addChild(bubble);
            }
        } 
    }

}


class Main extends Sprite {
   
    private var board_:BubbleBoard;
    private var cacheX:Float;
    private var cacheY:Float;
 
    public function new () {
        super ();

        var rows = 9;
        var columns = 7;
        this.board_ = new BubbleBoard (rows, columns);
        addChild (this.board_); 
        this.board_.initialize();

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
