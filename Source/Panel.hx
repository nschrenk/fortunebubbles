package;

import flash.events.Event;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;

class Panel extends Sprite {
    private var textField_ : TextField;
    private var score_: TextField;
    private var scoreWidth_ : Float;

    public function new () {
        super ();

        scoreWidth_ = 40;
        // var font = Assets.getFont ("assets/Palo_Alto_Regular.ttf");
        // var format = new TextFormat (font.fontName, 30, 0x7A0026);
        var format = new TextFormat ("arial.ttf", 30, 0x7A0026);
        textField_ = new TextField ();
        textField_.defaultTextFormat = format;
        textField_.embedFonts = true;
        textField_.selectable = false;

        score_ = new TextField ();
        score_.defaultTextFormat = format;
        score_.embedFonts = true;
        score_.selectable = false;

        addChild (this.textField_);
	    this.addEventListener (Event.RENDER, this.onRender);        
    }

    private function adjustSize () {

    }

    public function setText (text : String) {
        this.textField_.text = text;
        this.textField_.width = this.width = this.scoreWidth_;

    }

    public function updateScore(text : String) {
        this.score_.text = text;
    }

    public function onRender (event : Event) {
        // neko.Lib.print ("Panel.onRender\n");
        if (this.textField_.width != this.width) {
            this.textField_.width = this.width;
        }
    }

}
