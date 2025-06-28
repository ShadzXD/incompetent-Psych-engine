package huds;
import flixel.group.FlxGroup;
import objects.HealthIcon;

@:access(states.PlayState)

class MainHUD extends FlxGroup
{
	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;

    public function beatHit() {}
	public dynamic function updateScore(miss:Bool = false, ?score:Int, ?misses:Int, ?ratingName:String, ?percent:Float){} 

	public function reloadHealthBarColors() {}

	public function doScoreBop():Void{}

	public function healthStuff(value:Float){}
	
}