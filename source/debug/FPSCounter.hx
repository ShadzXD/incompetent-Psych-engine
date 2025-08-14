package debug;

import flixel.FlxG;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;
import openfl.events.Event;

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
/*
	FIXED UP CLASS WRITTEN BY Itz-miles!
	*/
class FPSCounter extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;
	
	@:noCompletion private var times:Array<Float>;

	public static var updateInterval:Int = 250; // keep this high

	public function new(x:Float = 10, y:Float = 10)
	{
		super();

		this.x = x;
		this.y = y;

		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("VCR OSD Mono", 17, 0xFFFFFF);
		autoSize = LEFT;
		multiline = true;
		backgroundColor = 0xFF000000;

		text = "FPS: ";
		cacheAsBitmap = false;

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
		text = 'FPS: $currentFPS / ' + ClientPrefs.data.framerate
	 + '\nRAM: ${flixel.util.FlxStringUtil.formatBytes(System.totalMemory)}';
		// The frametime is currently a lie. Using deltaTime causes the TextField to regen more frequently, which is hideously memory intensive.

	}

}
