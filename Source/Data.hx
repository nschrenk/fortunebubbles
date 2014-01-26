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


// colors	points	fortunes								titles		drop words			

typedef Fortune = {
    title : String,
    fortune : String
}

class Data {
    static public var color_points : Map<Color, Int> = [
        Red => 1,
        Orange => 2,
        Yellow => 3,
        Green => 4,
        Blue => 5,
        Purple => 6,
        Black => 7,
        White => 8
        ];

    static public var drop_words : Map<Color, Array<String>> = [
        Red => ["powerful", "captivating", "passionate",
                "heated", "rage", "loved", "fiery", "impulsive"],
        Orange => ["fun", "vibrant", "warmth", "compassion", "creative",
                   "adventurous", "determination"],
		Yellow => ["honored", "happieness", "cheerful", "enegetic",
				 "enlightened", "nervous", "cautious", "fearful"],
		Green => ["greedy", "vitality", "renewal", "rebirth",
				 "envious", "nurturing", "dominate", "jealousy"],
		Blue => ["dramatic", "open", "calm", "depressed",
				"righteousness", "frigid", "trusted", "confident"],
		Purple => ["mysterious", "devoted", "noble", "regal",
				"wise", "rare", "magical", "idealistic"],
		Black => ["gloomy", "serious", "sexy", "emo",
				"empty", "prestigious", "evil", "overwhelming"],
		White => ["clean", "illuminated", "innocent", "inspirational",
				"pure", "delicate", "perfect", "virtuous"],
        ];

    static public var fortunes : Map<Int, Fortune> = [
        7 => { title : "pinky promise",
               fortune: "you have unusual equipment for success, use it properly" },
		8 => { title : "pinky promise",
			   fortune: "love is free, lust will cost you everything you have" },
		9 => { title : "pinky promise",
			   fortune: "it is better to be the hammer than the nail" },
		10 => { title : "red hot lover",
			   fortune: "an angry man open his mouth and shuts his eyes" },
		11 => { title : "red hot lover",
			   fortune: "nothing in the world is accomplished without passion" },
		12 => { title : "angry old man",
			   fortune: "love thy neighbor, just don’t get caught" },
		13 => { title : "angry old man",
			   fortune: "back away from people who are impulsive" },
		14 => { title : "happy sunrise",
			   fortune: "be direct, usually one can accomplish more that way" },
		15 => { title : "happy sunrise",
			   fortune: "you create your own stage … the audience is waiting" },
		16 => { title : "careful adventurer",
			   fortune: "if you want the rainbow, you have to tolerate the rain" },
		17 => { title : "careful adventurer",
			   fortune: "never regret anything that made you smile" },
		18 => { title : "crafty thief",
			   fortune: "we can not changed the direction of the wind, but we can adjust our sails" },
		19 => { title : "crafty thief",
			   fortune: "an understanding heart warms all that are graced with its presense" },
		20 => { title : "determined flame",
			   fortune: "you will soon be honored by someone you respect" },
		21 => { title : "determined flame",
			   fortune: "your smile brings happiness to everyone you meet" },
		22 => { title : "cowardly lion",
			   fortune: "conquer your fears or they will conquer you" },
		23 => { title : "cowardly lion",
			   fortune: "don’t wait for your ship to come in, swim out to it" },
		24 => { title : "wise dragon",
			   fortune: "fear is just excitement in need of an attitude adjustment" },
		25 => { title : "wise dragon",
			   fortune: "happieness isnt something you remember, its something you experience" },
		26 => { title : "sickly hobbit",
			   fortune: "a big fortune will descend upon you this year" },
		27 => { title : "sickly hobbit",
			   fortune: "some men dream of fortunes, others dream of cookies" },
		28 => { title : "mr. greed",
			   fortune: "jealousy is a useless emotion" },
		29 => { title : "mr. greed",
			   fortune: "the problem with resisting temptation is that it may never come again" },
		30 => { title : "dead presidents",
			   fortune: "when you get something for nothing, you just havent been billed for it" },
		31 => { title : "dead presidents",
			   fortune: "money can buy happiness" },
		32 => { title : "trusted banker",
			   fortune: "if you feel you are right, stand firmly by your convictions" },
		33 => { title : "trusted banker",
			   fortune: "when you look down, all you see is dirt, so keep looking up" },
		34 => { title : "frosty princess",
			   fortune: "it is best to act with confidence, no matter how little right you have to it" },
		35 => { title : "frosty princess",
			   fortune: "stop procrastinating - starting tomorrow" },
		36 => { title : "calm knight",
			   fortune: "action speaks nothing without the motive" },
		37 => { title : "calm knight",
			   fortune: "depression is a cry for help" },
		38 => { title : "sad plum",
			   fortune: "a single conversation with a wise man is better than ten years of study" },
		39 => { title : "sad plum",
			   fortune: "our preception and attitude toward any situation will determine the outcome" },
		40 => { title : "royal pimp",
			   fortune: "beauty is simple beauty, originality is magical" },
		41 => { title : "royal pimp",
			   fortune: "benefit by doing things that others give up on" },
		42 => { title : "dark king",
			   fortune: "a mystery always draws in the fool hardy" },
		43 => { title : "dark king",
			   fortune: "without royalty there would be no one to rule us" },
		44 => { title : "black cat",
			   fortune: "the cure for grief is motion" },
		45 => { title : "black cat",
			   fortune: "before you can be reborn you must die" },
		46 => { title : "grim reaper",
			   fortune: "bad luck and misfortune will infest you soul for all time" },
		47 => { title : "grim reaper",
			   fortune: "before the beginning of great brilliance, there must be chaos" },
		48 => { title : "kid emo",
			   fortune: "enthusiastic leadership gets you a promotion when you least expect it" },
		49 => { title : "kid emo",
			   fortune: "death is always the end of a journey" },
		50 => { title : "purely nun",
			   fortune: "virtuous find joy while wrong doers find greif in their actions" },
		51 => { title : "purely nun",
			   fortune: "vision is the art of seeing what is invisible to others" },
		52 => { title : "the virgin",
			   fortune: "darkness is only successful when there is no light" },
		53 => { title : "the virgin",
			   fortune: "what breaks in a moment takes years to mend" },
		54 => { title : "fresh candle",
			   fortune: "failure is not defeat until you stop trying" },
		55 => { title : "fresh candle",
			   fortune: "reading is to the mind what exercise is to the body" },
		56 => { title : "fresh candle",
			   fortune: "light chases away the dark, but too much light makes it impossible to see" },
        ];
}

