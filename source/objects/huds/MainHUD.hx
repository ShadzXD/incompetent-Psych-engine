package objects.huds;
import flixel.group.FlxGroup;
import objects.HealthIcon;
import objects.Bar;

@:access(states.PlayState)
/**
 * Main class used for general functions.
 * Also used for retrieving PlayState Variables.
 */
class MainHUD extends FlxGroup
{
	//Things you can edit by overriding in the subclass.
	public var hudFont:String = 'vcr.ttf'; //font used in HUD
	public var botplayText:String = 'BotPlay Enabled'; //text that displays whenever botplay is enabled.
    public var healthBar:Bar;

	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	public var scoreText:FlxText;
	public var songSeconds:Float;
	public var songLength:Float;
	public var timeTxt:FlxText;
	public var healthValue:Float = 1;

	//disables health, if not needed
	public var useHealth:Bool = true;

	public var ratingStuff:Array<Dynamic> = [
		['You Suck!', 0.2], //From 0% to 19%
		['Shit', 0.4], //From 20% to 39%
		['Bad', 0.5], //From 40% to 49%
		['Bruh', 0.6], //From 50% to 59%
		['Meh', 0.69], //From 60% to 68%
		['Nice', 0.7], //69%
		['Good', 0.8], //From 70% to 79%
		['Great', 0.9], //From 80% to 89%
		['Sick!', 1], //From 90% to 99%
		['Perfect!!', 1] //The value on this one isn't used actually, since Perfect is always "1"
	];
	public function new()
	{
		super();
	}

    public function beatHit(){}

	public function updateScore(miss:Bool = false, ?score:Int, ?misses:Int, ?percent:Float){} 

	public function botplayStuff(){} 

	public function reloadHealthBarColors(){}

	public function doScoreBop():Void{}

	public function healthStuff(h:Float){
		healthValue = h;
	}
	public function startSong():Void{}

 	public function updateTime(t:Float){
		songSeconds = t;
	}

	public function recalculateRating(p:Float){}
}