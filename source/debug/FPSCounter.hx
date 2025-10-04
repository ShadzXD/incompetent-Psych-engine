package debug;
#if FPS_ALLOWED
import flixel.FlxG;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;
import openfl.events.Event;
import openfl.display.Sprite;
import openfl.display.Shape;

/**
 * The FPS class provides an easy-to-use monitor to display
 * 	the current frame rate of an OpenFL project
 * FIXED UP CLASS WRITTEN BY Itz-miles!
 * */
class FPSCounter extends Sprite
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;
	
	@:noCompletion private var times:Array<Float>;

	public static var updateInterval:Int = 250; // keep this high
  	var infoDisplay:TextField;
	var background:Shape;
	public function new(x:Float = 10, y:Float = 10)
	{
		super();

		this.x = x;
		this.y = y;

    	background = new Shape();
    	background.graphics.beginFill(0x3d3f41, 1);
		background.graphics.drawRect(0, 0, 135, 53);
   		background.graphics.endFill();
    	background.alpha = 0.4;
    	addChild(background);

		infoDisplay = new TextField();
    	infoDisplay.x = x;

    	infoDisplay.width = 500;
   		infoDisplay.selectable = false;
    	infoDisplay.mouseEnabled = false;
    	infoDisplay.defaultTextFormat = new TextFormat('Monsterrat', 15, 0xFFFFFF);
    	infoDisplay.antiAliasType = NORMAL;
    	infoDisplay.sharpness = 100;
		infoDisplay.autoSize = LEFT;
		infoDisplay.multiline = true;
		infoDisplay.backgroundColor = 0xFF000000;
    	infoDisplay.multiline = true;
    	addChild(infoDisplay);


		infoDisplay.text = "FPS: ";
		infoDisplay.cacheAsBitmap = false;

		addEventListener(Event.DEACTIVATE, _ -> focus = false);
		addEventListener(Event.ACTIVATE, _ -> focus = true);
		times = [];
	}

	private static var then:Int = 0;
	private static var now:Int = 0;
	private static var focus:Bool = true;
	private override function __enterFrame(deltaTime:Float):Void
	{
		if (!focus || !visible)
			return;

		now = lime.system.System.getTimer();
		times.push(now);
		while (times[0] < now - 1000)
			times.shift();

		if (now - then < updateInterval)
			return;

		then = now;
		currentFPS = times.length < FlxG.updateFramerate ? times.length : FlxG.updateFramerate;
		infoDisplay.text = 'FPS: $currentFPS / ' + ClientPrefs.data.framerate
	 + '\nRAM: ${flixel.util.FlxStringUtil.formatBytes(System.totalMemory)}';

	}

}
#end