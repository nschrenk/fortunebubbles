package;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.media.Sound;


class Bubble extends Sprite {
    private var popped_:Bool;
    private var bitmap_:Bitmap;
    private var bubbleData_:BitmapData;
    private var poppedData_:BitmapData;
    private var popSound_:Sound;
 
    public function new (bubbleData, poppedData) {

        super ();

        this.bubbleData_ = bubbleData;
        this.poppedData_ = poppedData;
        this.popped_ = false;
        this.popSound_ = null;

        bitmap_ = new Bitmap (bubbleData);
        addChild (bitmap_);

	    this.addEventListener (MouseEvent.CLICK, this.onMouseClick);        
    }
    public function setPopSound (popSound) {
        this.popSound_ = popSound;
    }

	public function onMouseClick (clickEvent:MouseEvent):Void {
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
    }
}

