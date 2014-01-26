package;

import Std;

import Panel;


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


typedef Rgb = {
    r : Int,
    g : Int,
    b : Int
};


typedef BubbleState = {
    color : Color,
    popped : Bool
}

 
class GameController {
    var rows_ : Int;
    var cols_ : Int;
    var state_ : Array<Array<BubbleState>>;
    var numPopped_ : Int;
    var panel_ : Panel;

    public function new (rows : Int, cols : Int) {
        this.rows_ = rows;
        this.cols_ = cols;
        this.state_ = new Array<Array<BubbleState>> ();
        this.numPopped_ = 0; 

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

    public function setPanel (panel : Panel) {
        panel_ = panel;
    }

    public function onPopped (row:Int, col:Int) {
        // Invoked when a bubble is popped
        var st = stateAt (col, row);
        st.popped = true;
        this.numPopped_ += 1;
        if (panel_ != null) {
            panel_.updateScore (Std.string (this.numPopped_));
            var msg = "Popped " + textForColor(st.color) + " bubble";
            panel_.setText(msg);
        }
        // neko.Lib.print ("onPopped row = " + row + ", col = " + col
        //                + ", total popped = " + this.numPopped_ + "\n");
    } 
}


