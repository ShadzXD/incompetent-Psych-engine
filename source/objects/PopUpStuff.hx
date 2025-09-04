package objects;

import flixel.group.FlxGroup.FlxTypedGroup;
import backend.Rating;
using StringTools;



class PopUpStuff extends FlxTypedGroup<FlxSprite>
{
	var antialias:Bool = true;
	var placement:Float;
	var uiPrefix:String = '';
	var uiSuffix:String = '';
	public var hudType:String;
	var size:Float = 0.6;
	var speedRate:Float = 1;
	var ratingsData:Array<Rating> = Rating.loadDefault();
	var isBotplay:Bool = false;
	// Stores Ratings and Combo Sprites in a group
	override public function new(hud:String, ?fromPlayState:Bool = false, ?botplay:Bool = false)
	{
		super();

		placement = FlxG.width * 0.35;

		hudType = hud;

		
		if(fromPlayState)speedRate = PlayState.instance.playbackRate;

		isBotplay = botplay;
		loadStuff();
	}

	public function displayRating(daRating:String)
	{
		var rating:FlxSprite = new FlxSprite();
		rating.loadGraphic(Paths.image(uiPrefix + daRating + uiSuffix));
		rating.screenCenter();
		rating.x = placement - 40;
		rating.y -= 60;
		rating.acceleration.y = 550 * speedRate * speedRate;
		rating.velocity.y -= FlxG.random.int(140, 175) * speedRate;
		rating.velocity.x -= FlxG.random.int(0, 10) * speedRate;
		rating.x += ClientPrefs.data.comboOffset[0];
		rating.y -= ClientPrefs.data.comboOffset[1];
		rating.antialiasing = antialias;

		rating.setGraphicSize(Std.int(rating.width * size));
		rating.updateHitbox();
		add(rating);
		
			FlxTween.tween(rating, {alpha: 0}, 0.2 / speedRate, {
			onComplete: function(tween:FlxTween)
			{
				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001 / speedRate
		});
	}

	public function displayCombo(?combo:Int = 0)
	{
		var seperatedScore:Array<Int> = [];

		if(combo >= 1000) {
			seperatedScore.push(Math.floor(combo / 1000) % 10);
		}
		seperatedScore.push(Math.floor(combo / 100) % 10);
		seperatedScore.push(Math.floor(combo / 10) % 10);
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		var xThing:Float = 0;

		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(uiPrefix + 'num' + Std.int(i) + uiSuffix));
			numScore.screenCenter();
			numScore.x = placement + (43 * daLoop) - 90 + ClientPrefs.data.comboOffset[2];
			numScore.y += 80 - ClientPrefs.data.comboOffset[3];

			numScore.setGraphicSize(Std.int(numScore.width * (size - 0.1)));
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300) * speedRate * speedRate;
			numScore.velocity.y -= FlxG.random.int(140, 160) * speedRate;
			numScore.velocity.x = FlxG.random.float(-5, 5) * speedRate;
			numScore.antialiasing = antialias;
			add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2 / speedRate, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002 / speedRate
			});

			daLoop++;
			if(numScore.x > xThing) xThing = numScore.x;
		}
	}

	public function loadStuff()
	{
		switch(hudType)
		{
			case 'FUNKIN':
			uiPrefix = 'popups/base_game/';

			case 'PIXEL':
			uiPrefix = 'pixelUI/';
			uiSuffix = '-pixel';
			size = 5;
			antialias = false;

			case 'OSHA':
			uiPrefix = 'popups/oshawott/';
			antialias = false;

			case 'COCOON':
			uiPrefix = 'popups/cocoon/';
			antialias = false;

		}

		if(!isBotplay) cachePopUpScore();
	}

	private function cachePopUpScore()
	{
		trace('precaching');

		for (rating in ratingsData)
			Paths.image(uiPrefix + rating.image + uiSuffix);
		for (i in 0...10)
			Paths.image(uiPrefix + 'num' + i + uiSuffix);
	}
}
