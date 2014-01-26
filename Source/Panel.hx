package;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import openfl.Assets;

class Panel extends Sprite {
    private var textField_ : TextField;
    private var score_: TextField;
    private var scoreWidth_ : Float;

    public function new () {
        super ();
    }

    public function initialize () {
        scoreWidth_ = 40;
        var font = Assets.getFont ("assets/Palo_Alto_Regular.ttf");
        var format = new TextFormat (font.fontName, 25, 0x5070DD);
        // var format = new TextFormat (null, 30, 0x5070DD);
        textField_ = new TextField ();
        textField_.defaultTextFormat = format;
        textField_.embedFonts = true;
        textField_.selectable = false;
        // textField_.background = true;
        // textField_.backgroundColor = 0xaaaaaa;
        // textField_.border = true;
        textField_.autoSize = TextFieldAutoSize.LEFT;
        textField_.type = TextFieldType.DYNAMIC;
        textField_.text = "";
        textField_.wordWrap = true;
        textField_.multiline = true;

        score_ = new TextField ();
        score_.defaultTextFormat = format;
        score_.embedFonts = true;
        score_.selectable = false;
        score_.background = true;
        score_.backgroundColor = 0xcccccc;
        score_.border = true;
        score_.autoSize = TextFieldAutoSize.CENTER;
        score_.type = TextFieldType.DYNAMIC;
        score_.text = "0";
        // score_.x = 400;

        addChild (textField_);
        // addChild (score_);
    }

    private function adjustSize () {
        // this.width = stage.stageWidth;
        textField_.x = 25;
        textField_.y = 10;
        textField_.width = 550;

        score_.x = 400;
        score_.y = 0;
    }

    public function setText (text : String) {
        this.textField_.text = text;
        this.adjustSize();
    }

    public function updateScore(text : String) {
        this.score_.text = text;
        this.adjustSize();
    }

}
