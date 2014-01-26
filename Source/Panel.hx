package;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
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
        var format = new TextFormat (null, 30, 0x7A0026);
        textField_ = new TextField ();
        textField_.defaultTextFormat = format;
        textField_.embedFonts = true;
        textField_.selectable = false;
        textField_.background = true;
        textField_.backgroundColor = 0xcccccc;
        textField_.border = true;
        textField_.autoSize = TextFieldAutoSize.LEFT;
        textField_.type = TextFieldType.DYNAMIC;
        textField_.text = "HELP!";

        score_ = new TextField ();
        score_.defaultTextFormat = format;
        score_.embedFonts = true;
        score_.selectable = false;
        score_.background = true;
        textField_.backgroundColor = 0xcccccc;
        score_.border = true;
        textField_.autoSize = TextFieldAutoSize.LEFT;
        textField_.type = TextFieldType.DYNAMIC;
        score_.text = "0";

        addChild (textField_);
        addChild (score_);
    }

    private function adjustSize () {
        textField_.x = 5;
        textField_.y = 5;
        // textField_.width = 100;

        score_.x = 400;
        score_.y = 5;
    }

    public function setText (text : String) {
        this.textField_.text = "\n" + text;
        this.adjustSize();
    }

    public function updateScore(text : String) {
        this.score_.text = text;
        this.adjustSize();
    }

}
