package backend;

import backend.ClientPrefs;

class Rating
{
	public var name:String = '';
	public var image:String = '';
	public var hitWindow:Null<Int> = 0; //ms
	public var ratingMod:Float = 1;
	public var noteSplash:Bool = true;
	public var hits:Int = 0;

	public function new(name:String)
	{
		this.name = name;
		this.image = name;
		this.hitWindow = 0;

		var window:String = name + 'Window';
		try
		{
			this.hitWindow = Reflect.field(ClientPrefs.data, window);
		}
		catch(e) FlxG.log.error(e);
	}

	public static function loadDefault():Array<Rating>
	{
		var ratingsData:Array<Rating> = [new Rating('sick')]; //highest rating goes first

		var rating:Rating = new Rating('good');
		rating.ratingMod = 0.67;
		rating.noteSplash = false;
		ratingsData.push(rating);

		var rating:Rating = new Rating('bad');
		rating.ratingMod = 0.34;
		rating.noteSplash = false;
		ratingsData.push(rating);

		var rating:Rating = new Rating('shit');
		rating.ratingMod = 0;
		rating.noteSplash = false;
		ratingsData.push(rating);
		return ratingsData;
	}

	//This uses the PBOT1 scoring system added in FNF 0.3.0 
	//used fps plus as a base for this
	public function scoreNote(msTiming:Float):Int
	{
		var absTiming:Float = Math.abs(msTiming);
		var slope = 0.080;
		var offset = 54.99;

		if(absTiming < 5.0){
			return 500;//500 is the most score you can attain. 
		}
	  
		var factor:Float = 1.0 - (1.0 / (1.0 + Math.exp(-slope * (absTiming - offset))));
		var score:Int = Std.int(500 * factor + 10);
		return score;

	}
}
