package;

import Bubble;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.media.Sound;
import openfl.Assets;


class BubbleBoard extends Sprite {
    private var rows_:Int;
    private var columns_:Int;
    private var bubbleArr_:Array<Array<Bubble>>;
    private var scaling_:Float;

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
    }

    public function initialize () {
        var bubbleBmData = Assets.getBitmapData ("assets/bubble.png");
        var poppedBmData = Assets.getBitmapData ("assets/bubble_popped.png");
        var popSound = Assets.getSound ("assets/pop_sound.wav");
        this.scaling_ = calculateScaling(this.rows_, this.columns_,
                                         bubbleBmData.width,
                                         bubbleBmData.height);
        this.scaleX = this.scaling_;
        this.scaleY = this.scaling_;

        bubbleArr_ = new Array<Array<Bubble>>();
 
        for (h in 0...rows_) {
            var row = new Array<Bubble>();
            bubbleArr_.push(row);

            for (w in 0...columns_) {
                var bubble = new Bubble(bubbleBmData, poppedBmData);
                bubble.setPopSound(popSound);
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
