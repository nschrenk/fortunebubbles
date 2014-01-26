package;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
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
        var format = new TextFormat ("arial.ttf", 20, 0x7A0026);
        textField_ = new TextField ();
        textField_.defaultTextFormat = format;
        textField_.embedFonts = true;
        textField_.selectable = false;

        score_ = new TextField ();
        score_.defaultTextFormat = format;
        score_.embedFonts = true;
        score_.selectable = false;

        this.opaqueBackground = 0x000000;
        addChild (textField_);
        addChild (score_);
    }

    private function adjustSize () {
        textField_.x = 5;
        textField_.y = 5;
        // textField_.width = this.width - scoreWidth_;
        // textField_.height = this.height;
        score_.x = textField_.width - scoreWidth_;
        score_.y = 5;
        // score_.width = scoreWidth_;
        // score_.height = this.height;
    }

    public function setText (text : String) {
        this.textField_.text = text;
        this.adjustSize();
    }

    public function updateScore(text : String) {
        this.score_.text = text;
        this.adjustSize();
        neko.Lib.print ("updateScore => " + text + "\n");
        neko.Lib.print ("\n");

    }

}
