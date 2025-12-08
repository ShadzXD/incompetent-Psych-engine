package states.editors;

import backend.WeekData;
import objects.Character;
import states.FreeplayState;
import states.MainMenuState;

class MasterEditorMenu extends MusicBeatState
{
	var options:Array<String> = [
		'Chart Editor',
		'Character Editor',
		'Week Editor',
		'Menu Character Editor',
		'Dialogue Editor',
		'Dialogue Portrait Editor',
		'Note Splash Debug'
	];
	private var grpTexts:FlxTypedGroup<Alphabet>;
	private var directories:Array<String> = [null];

	private var curSelected = 0;
	private var curDirectory = 0;
	private var directoryTxt:FlxText;

	override function create()
	{
		FlxG.camera.bgColor = FlxColor.BLACK;
		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Editors Main Menu", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/menuDesat'));
		bg.scrollFactor.set();
		bg.color = 0xFF353535;
		add(bg);

		grpTexts = new FlxTypedGroup<Alphabet>();
		add(grpTexts);

		for (i in 0...options.length)
		{
			var leText:Alphabet = new Alphabet(90, 320, options[i], true);
			leText.isMenuItem = true;
			leText.targetY = i;
			grpTexts.add(leText);
			leText.snapToPosition();
		}
		

		changeSelection();

		FlxG.mouse.visible = false;
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			FlxG.switchState(() -> new MainMenuState());
		}

		if (controls.ACCEPT)
		{
			switch(options[curSelected]) {
				case 'Chart Editor'://felt it would be cool maybe
					LoadingState.loadAndSwitchState(new ChartingState(), false);
				case 'Character Editor':
					LoadingState.loadAndSwitchState(new CharacterEditorState(Character.DEFAULT_CHARACTER, false));
				case 'Week Editor':
					FlxG.switchState(() -> new WeekEditorState());
				case 'Menu Character Editor':
					FlxG.switchState(() -> new MenuCharacterEditorState());
				case 'Dialogue Editor':
					LoadingState.loadAndSwitchState(new DialogueEditorState(), false);
				case 'Dialogue Portrait Editor':
					LoadingState.loadAndSwitchState(new DialogueCharacterEditorState(), false);
				case 'Note Splash Debug':
					FlxG.switchState(() -> new NoteSplashEditorState());
			}
			FlxG.sound.music.volume = 0;
			FreeplayState.destroyFreeplayVocals();
		}
		
		var bullShit:Int = 0;
		for (item in grpTexts.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;
	}
}