package;

import Std;

import Data;
import Panel;


typedef Rgb = {
    r : Int,
    g : Int,
    b : Int
};


typedef BubbleState = {
    color : Color,
    popped : Bool,
    drop_word : String
}


interface GameListener {
    function onPop (drop_word : String) : Void;
    function onGameEnd (title : String, fortune : String) : Void;
}

 
class GameController {
    var rows_ : Int;
    var cols_ : Int;
    var listener_ : GameListener;
    var state_ : Array<Array<BubbleState>>;
    var numPopped_ : Int;
    var score_ : Int;

    public function new (rows : Int, cols : Int) {
        this.rows_ = rows;
        this.cols_ = cols;
        reset ();
    }

    public function reset () {
        this.state_ = new Array<Array<BubbleState>> ();
        this.numPopped_ = 0; 
        this.score_ = 0;

        var board = GameController.generateBoard (rows_ * cols_);
        for (i in 0...rows_) {
           var row = new Array<BubbleState> ();
           this.state_.push (row);
           for (j in 0...cols_) {
                row.push (board.pop ());
           }
        }
    }

    public static function generateBoard (size : Int) : Array<BubbleState> {
        var board = new Array<BubbleState> ();
        var colors = new Array<Color> ();
        var drop_word_pos = new Map<Color, Int> ();
        var num_each = Math.floor (size / 8) + 1;
        for (c in Type.allEnums(Color)) {
            for (i in 0...num_each) {
                colors.push(c);
            }
            drop_word_pos[c] = 0;
        }

        for (i in 0...size) {
            var idx = Std.random (colors.length);
            var c = colors[idx];
            var drop_word_idx = drop_word_pos[c];
            if (drop_word_idx >= Data.drop_words[c].length) {
                drop_word_idx = 0;
            }
            var drop_word = Data.drop_words[c][drop_word_idx];
            drop_word_pos[c] = drop_word_idx + 1;
            
            var st : BubbleState = { color : c, popped : false,
                                     drop_word : drop_word };
            board.push(st);
        }

        return board;
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

    public static function textForColor (c : Color) {
        var txt : String;
        switch (c) {
            case Red:       txt = "red";
            case Orange:    txt = "orange";
            case Yellow:    txt = "yellow";
            case Green:     txt = "green";
            case Blue:      txt = "blue";
            case Purple:    txt = "purple";
            case Black:     txt = "black";
            case White:     txt = "white";
        }
        return txt;
    }

    public function stateAt (col:Int, row:Int):BubbleState {
        return this.state_[row][col]; 
    }

    public function setListener (listener : GameListener) {
        listener_ = listener;
    }

    public function gameEnd () {
        trace ("gameEnd");
        var title = "mysterious stranger";
        var fortune = "your fortune is murky";
        var f = Data.fortunes.get (score_);
        if (f != null) {
            title = f.title;
            fortune = f.fortune;
        }
        listener_.onGameEnd (title, fortune);
    }

    public function playing () {
        return this.numPopped_ < 7;
    }

    public function onPopped (row:Int, col:Int) : Bool {
        // Invoked when a bubble is popped
        if (!playing()) {
            return false;
        }
        var st = stateAt (col, row);
        st.popped = true;
        this.numPopped_ += 1;
        this.score_ += Data.color_points[st.color];

        trace ("onPopped row = " + row + ", col = " + col
               + ", total popped = " + numPopped_
               + ", score " + score_);

        listener_.onPop (st.drop_word);

        if (this.numPopped_ == 7) {
            gameEnd ();
        }
        return true;
    } 
}


