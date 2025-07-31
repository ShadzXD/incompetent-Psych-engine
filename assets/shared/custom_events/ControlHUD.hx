var hudItems:Array<FlxSprite> = [game.timeBar, game.healthBar, game.iconP1, game.iconP2, game.botplayTxt, game.comboGroup];

function onEvent(n:String, v1:String)
{
	if (n == "ControlHUD")
	{
		var visible:Bool = (v1.toLowerCase() == "true");
		var daAlpha:Float = visible ? 1 : 0;
		var t:Float = Conductor.crochet * (1 + daAlpha) / 1000;

		for (item in hudItems)
			FlxTween.tween(item, {alpha: daAlpha}, t, {ease: FlxEase.backInOut});
		for (item in game.opponentStrums.members)
			FlxTween.tween(item, {alpha: daAlpha}, t);
		for (item in game.playerStrums.members)
			FlxTween.tween(item, {alpha: visible ? 1 : 0.75}, t);
	}
}