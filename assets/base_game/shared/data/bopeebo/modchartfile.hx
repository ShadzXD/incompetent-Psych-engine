function onStepHit()
{
    switch(curStep)
    {
        case 4:
            trace('first step hit!');
            for (i in 0...game.playerStrums.length)
            {
                 FlxTween.tween(playerStrums.members[i], {x: 200 * i}, 2, {ease: FlxEase.quartInOut});
		         FlxTween.angle(playerStrums.members[i], 0, 360, 2,  {ease: FlxEase.quadIn});
            }

            for (ass in game.opponentStrums) {
		        FlxTween.tween( ass, {alpha: 0}, 2, {ease: FlxEase.quartInOut});

			}
        case 16:
            FlxTween.tween(playerStrums.members[2], {y: 200}, 2, {ease: FlxEase.quartInOut});


    }
}
function opponentNoteHit(n)
{
    iconP1.scale.set(0.2,0.2);
}

