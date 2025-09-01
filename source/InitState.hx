package;
import backend.Highscore;
import flixel.input.keyboard.FlxKey;
import states.StoryMenuState;
import backend.ClientPrefs;
class InitState
{
    public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

    /*
    *  A class which allows for loading save data.
    * This is done, since base psych engine loads save stuff in TitleState! 
    */

    public static function loadSaveShit()
    {
		Mods.loadTopMod();

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];


		FlxG.save.bind('funkin', CoolUtil.getSavePath());

		ClientPrefs.loadPrefs();

		Highscore.load();

        if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

		FlxG.mouse.visible = false;
     
		#if !debug

		//i fucking hate this setting so much.
        if(FlxG.save.data != null && FlxG.save.data.fullscreen)
		{
			FlxG.fullscreen = FlxG.save.data.fullscreen;
			trace('LOADED FULLSCREEN SETTING!!');
		}
		#end

		#if html5
		if(ClientPrefs.data.cacheOnGPU)
		{
			ClientPrefs.data.cacheOnGPU = false;
			ClientPrefs.saveSettings();
		}
		#end


    }
}