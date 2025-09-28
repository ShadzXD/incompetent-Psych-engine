package cutscenes;

import objects.HealthIcon;
import cutscenes.DialogueBoxPsych.DialogueLine;

class DialogueLogSubstate extends MusicBeatSubstate
{
    var dialogue_lines:Array<String> = [""];
    var character_names_string:Array<String> = [""];
    var icon_names:Array<String> = [""];

    public function new(curDialogue:Array<DialogueLine>)
    {
        super();
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

        for (i in 0...curDialogue.length)
        {
            trace(curDialogue[i].text);
            dialogue_lines[i] = curDialogue[i].text;
            character_names_string[i] = curDialogue[i].portrait;
             icon_names[i] = curDialogue[i].iconName;

        }
    }
    override function create()
    {
        super.create();

        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.screenCenter();
		bg.scrollFactor.set();
        bg.alpha = 0.8;
		add(bg);

        var title:FlxText = new FlxText(0, 0, FlxG.width, "DIALOGUE RECORD", 23);
        title.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(title);

        for (i in 0... dialogue_lines.length)
        {
            var names:FlxText = new FlxText(20, 40 + (i * 80), FlxG.width, character_names_string[i], 25);
            names.setFormat(Paths.font('vcr.ttf'), 25, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            add(names);

            var icon:HealthIcon = new HealthIcon('icon-bf', false);
            icon.x = names.x + 80;
            icon.y = names.y - 30;
            icon.scale.set(0.4, 0.4);
            add(icon);

            var dialogue:FlxText = new FlxText(20, 70 + (i * 80), FlxG.width, dialogue_lines[i], 32);
            dialogue.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            add(dialogue);
        }
    }

    override  function update(elapsed:Float)
    {
        super.update(elapsed / 2); //saves on processes time since this is only gonna be used for if checks
        if(controls.BACK) close();
    }

    
	override function destroy()
	{
        trace('destroy vars');
		super.destroy();
	}
}