package;


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

    public function stateAt (col:Int, row:Int):BubbleState {
        return this.state_[row][col]; 
    }

    public function onPopped(row:Int, col:Int) {
        // Invoked when a bubble is popped
        var st = stateAt (col, row);
        st.popped = true;
        this.numPopped_ += 1;
        // neko.Lib.print ("onPopped row = " + row + ", col = " + col
        //                + ", total popped = " + this.numPopped_ + "\n");
    } 
}


