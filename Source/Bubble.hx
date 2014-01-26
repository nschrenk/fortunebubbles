package;


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.media.Sound;

import GameController;


class Bubble extends Sprite {
    private var popped_ : Bool;
    private var bitmap_ : Bitmap;
    private var bubbleData_ : BitmapData;
    private var poppedData_ : BitmapData;
    private var popSound_ : Sound;
    private var row_ : Int;
    private var col_ : Int;
    private var controller_ : GameController;
 
    public function new (bubbleData, poppedData, row, col) {

        super ();

        this.bubbleData_ = bubbleData;
        this.poppedData_ = poppedData;
        this.popped_ = false;
        this.popSound_ = null;
        this.row_ = row;
        this.col_ = col;

        bitmap_ = new Bitmap (bubbleData);
        addChild (bitmap_);

	    this.addEventListener (MouseEvent.CLICK, this.onMouseClick);
	    this.addEventListener (TouchEvent.TOUCH_TAP, this.onTap);
    }

    public function setPopSound (popSound : Sound) {
        this.popSound_ = popSound;
    }

    public function setController(controller : GameController) {
        this.controller_ = controller;
    }

	public function onMouseClick (clickEvent:MouseEvent):Void {
        this.pop ();
	}

	public function onTap (tapEvent:TouchEvent):Void {
        this.pop ();
	}

    private function pop() {
        if (this.popped_) {
           return;
        }
        this.popped_ = true;

        var popped = new Bitmap (this.poppedData_);
        removeChild (bitmap_);
        bitmap_ = popped;
        addChild (bitmap_);
        if (this.popSound_ != null) {
            this.popSound_.play ();
        }
        if (this.controller_ != null) {
            this.controller_.onPopped (this.row_, this.col_);
        }
    }
}

