package huds;
import flixel.group.FlxGroup;
import objects.HealthIcon;

@:access(states.PlayState)
/*
* Main class used for general functions.
* Also used for retrieving PlayState Variables.
*/
class MainHUD extends FlxGroup
{
	//Things you can edit by overriding in the subclass.
	public var hudFont:String = 'vcr.ttf'; //font used in HUD
	public var botplayText:String = 'BotPlay Enabled'; //text that displays whenever botplay is enabled.

	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	public var isBotplay:Bool;
	public var scoreText:FlxText;
	public var songSeconds:Float;
	public var songLength:Float;

    public function beatHit(){}

	public function updateScore(miss:Bool = false, ?score:Int, ?misses:Int, ?ratingName:String, ?percent:Float){} 

	public function botplayStuff(){} 

	public function reloadHealthBarColors(){}

	public function doScoreBop():Void{}

	public function healthStuff():Float{
		return PlayState.instance.get_health();
	}
	public function startSong():Void{}

 	public function updateTime(t:Float){
		songSeconds = t;
	}
}