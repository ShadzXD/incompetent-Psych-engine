function onStepHit()
{
    switch(curStep)
    {
        case 4:
            if(!ClientPrefs.data.middleScroll)
            for (i in 0...game.playerStrums.length)
            {
                 FlxTween.tween(playerStrums.members[i], {x: 418 +  (112 * i)}, 2, {ease: FlxEase.quartInOut});
		         FlxTween.angle(playerStrums.members[i], 0, 360, 1.5);
            }
            for (i in 0...game.opponentStrums.length){
		        FlxTween.tween( opponentStrums.members[i], {alpha: 0, y: 800}, 1, {ease: FlxEase.quartIn, startDelay:  (0.2 * i)});

			}


    }
}

