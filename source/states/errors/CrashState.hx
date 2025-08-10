
package states.errors;

import flixel.util.FlxGradient;

class CrashState extends MusicBeatState
{
    var errorMssg:String;
    var allowInput:Bool = false;
    public function new(err:String)
    {
        super();
        errorMssg = err;
    }

    override function create()
    {
        super.create();

        Paths.clearStoredMemory();
        Paths.clearUnusedMemory();
        FlxG.sound.play(Paths.sound('badnoise1'));
        FlxG.sound.music.stop();
        FlxG.sound.playMusic(Paths.music('crash'), 0);
		FlxG.sound.music.fadeIn(3, 0, 0.5);

        var bg:FlxSprite = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height, [0xFF000000, 0xFF1B1919], 1);
        add(bg);

        var shitText:FlxText = new FlxText(0, 10, FlxG.width, "OH SHIT, YOUR SHITS FUCKED!", 40);
        shitText.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        shitText.screenCenter(X);
		add(shitText);

        var errText:FlxText = new FlxText(20, 70, FlxG.width, errorMssg, 27);
        errText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(errText);

        var exitText:FlxText = new FlxText(0,  FlxG.height - 34, FlxG.width, "Press the ACCEPT Button to return to the Main Menu.", 27);
        exitText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(exitText);

        new FlxTimer().start(0.7, function(tmr:FlxTimer)
        {
            allowInput = true;
        });
                
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
        if(controls.ACCEPT && allowInput)
        {
            FlxG.switchState(() -> new MainMenuState());
            FlxG.sound.music.stop();
        }
    }
}