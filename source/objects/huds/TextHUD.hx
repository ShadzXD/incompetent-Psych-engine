package objects.huds;

import flixel.util.FlxStringUtil;

/**
 * Hud that only includes Score Text and Timer. 
 */
class TextHUD extends MainHUD
{
	var scoreTxtTween:FlxTween;

    public function new()
    {
		super('TEXT');
	
		timeTxt = new FlxText(PlayState.STRUM_X + (FlxG.width / 2) - 248, ClientPrefs.data.downScroll ? FlxG.height - 44 : 19, 400, "", 27);
		timeTxt.setFormat(Paths.font(hudFont), 27, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.alpha = 0;
		timeTxt.borderSize = 1.25;
		add(timeTxt);
	
		scoreText = new FlxText(0, FlxG.height * (!ClientPrefs.data.downScroll ? 0.9 : 0.1), FlxG.width, "", 20);
		scoreText.setFormat(Paths.font(hudFont), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreText.scrollFactor.set();
		scoreText.borderSize = 1.25;
		add(scoreText);
    }

    override function update(elapsed:Float)
    {
		timeTxt.text = FlxStringUtil.formatTime(songSeconds, false) + ' // ' + FlxStringUtil.formatTime(songLength, false);
    }
    override public function updateScore(miss:Bool = false, ?score:Int, ?misses:Int, ?ratingName:String,?percent:Float)
	{
		var str:String = ratingName;
		
		var percent:Float = CoolUtil.floorDecimal(percent * 100, 2);
		str += ' (${percent}%)';
		
		// "tempScore" variable is used to prevent another memory leak, just in case
		// "\n" here prevents the text from being cut off by beat zooms
		var tempScore:String = 'Score: ${FlxStringUtil.formatMoney(score, false, true)}'
		+ (' | Misses: ${misses}')
		+ ' | Rating: ${str}';
	
		 scoreText.text = tempScore;
	} 

	override public function botplayStuff() scoreText.text = botplayText;

	override public function doScoreBop():Void {
		if(scoreTxtTween != null)
			scoreTxtTween.cancel();

		scoreText.scale.x = 1.075;
		scoreText.scale.y = 1.075;
		scoreTxtTween = FlxTween.tween(scoreText.scale, {x: 1, y: 1}, 0.2, {
			onComplete: function(twn:FlxTween) {
				scoreTxtTween = null;
			}
		});
	}
    

	override function startSong()
	{
		FlxTween.tween(timeTxt, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
	}

}