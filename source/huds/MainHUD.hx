package huds;
import flixel.group.FlxGroup;
import objects.HealthIcon;

@:access(states.PlayState)

class MainHUD extends FlxGroup
{
	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	public var isBotplay:Bool;
	public var botplayText:String = 'BotPlay Enabled';
	public var scoreText:FlxText;

    public function beatHit() {}
	public function updateScore(miss:Bool = false, ?score:Int, ?misses:Int, ?ratingName:String, ?percent:Float){} 

	public function botplayStuff(){} 

	public function reloadHealthBarColors() {}

	public function doScoreBop():Void{}

	//public function healthStuff(value:Float){}
	
}