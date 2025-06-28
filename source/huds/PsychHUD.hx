package huds;

import objects.HealthIcon;
import objects.Bar;
import flixel.util.FlxStringUtil;

class PsychHUD extends MainHUD
{
	var scoreTxtTween:FlxTween;
	public var scoreTxt:FlxText;

    public var healthBar:Bar;

    var healthLerp:Float = 1;
    var iconOffset:Int = 26;

    public function new()
    {
		super();
        
		healthBar = new Bar(0, FlxG.height * (!ClientPrefs.data.downScroll ? 0.88 : 0.1), 'healthBar', function(){
			healthLerp = FlxMath.lerp(healthLerp, PlayState.instance.health, 0.12 / (ClientPrefs.data.framerate / 60));
			return healthLerp;
		}, 0, 2);		
		healthBar.screenCenter(X);
		healthBar.leftToRight = false;
		healthBar.scrollFactor.set();
		healthBar.alpha = ClientPrefs.data.healthBarAlpha;
		reloadHealthBarColors();
		add(healthBar);

		iconP1 = new HealthIcon(PlayState.instance.boyfriend.healthIcon, true);
		iconP1.y = healthBar.y - 75;
		iconP1.alpha = ClientPrefs.data.healthBarAlpha;
		add(iconP1);

		iconP2 = new HealthIcon(PlayState.instance.dad.healthIcon, false);
		iconP2.y = healthBar.y - 75;
		iconP2.alpha = ClientPrefs.data.healthBarAlpha;
		add(iconP2);

		scoreTxt = new FlxText(0, healthBar.y + 40, FlxG.width, "", 20);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.25;
		updateScore(false);
		add(scoreTxt);
    }
    override function update(elapsed:Float)
    {
        var mult:Float = FlxMath.lerp(1, iconP1.scale.x, Math.exp(-elapsed * 5));
		iconP1.scale.set(mult, mult);
		iconP1.updateHitbox();

		var mult:Float = FlxMath.lerp(1, iconP2.scale.x, Math.exp(-elapsed * 5));
		iconP2.scale.set(mult, mult);
		iconP2.updateHitbox();

		iconP1.x = healthBar.barCenter + (150 * iconP1.scale.x - 150) / 2 - iconOffset;
		iconP2.x = healthBar.barCenter - (150 * iconP2.scale.x) / 2 - iconOffset * 2;
		var newPercent:Null<Float> = FlxMath.remapToRange(FlxMath.bound(healthBar.valueFunction(), healthBar.bounds.min, healthBar.bounds.max), healthBar.bounds.min, healthBar.bounds.max, 0, 100);
		healthBar.percent = (newPercent != null ? newPercent : 0);
		iconP1.animation.curAnim.curFrame = (healthBar.percent < 20) ? 1 : 0; //If health is under 20%, change player icon to frame 1 (losing icon), otherwise, frame 0 (normal)
		iconP2.animation.curAnim.curFrame = (healthBar.percent > 80) ? 1 : 0; //If health is over 80%, change opponent icon to frame 1 (losing icon), otherwise, frame 0 (normal)
    }
    override public dynamic function updateScore(miss:Bool = false, ?score:Int, ?misses:Int, ?ratingName:String,?percent:Float)
	{
		var str:String = ratingName;
		
		var percent:Float = CoolUtil.floorDecimal(percent * 100, 2);
		str += ' (${percent}%)';
		

		var tempScore:String = 'Score: ${FlxStringUtil.formatMoney(score, false, true)}'
		+ (' | Misses: ${misses}')
		+ ' | Rating: ${str}';
		// "tempScore" variable is used to prevent another memory leak, just in case
		// "\n" here prevents the text from being cut off by beat zooms

				scoreTxt.text = tempScore;
		//if (!miss && !cpuControlled)

	} 
	override public function doScoreBop():Void {
		if(!ClientPrefs.data.scoreZoom)
			return;

		if(scoreTxtTween != null)
			scoreTxtTween.cancel();

		scoreTxt.scale.x = 1.075;
		scoreTxt.scale.y = 1.075;
		scoreTxtTween = FlxTween.tween(scoreTxt.scale, {x: 1, y: 1}, 0.2, {
			onComplete: function(twn:FlxTween) {
				scoreTxtTween = null;
			}
		});
	}
    
	override function beatHit()
	{
		iconP1.scale.set(1.1, 1.1);
		iconP2.scale.set(1.1, 1.1);

		iconP1.updateHitbox();
		iconP2.updateHitbox();
    } 

    // fun fact: Dynamic Functions can be overriden by just doing this
	// `updateScore = function(miss:Bool = false) { ... }
	// its like if it was a variable but its just a function!
	// cool right? -Crow
    override public function reloadHealthBarColors() {
		healthBar.setColors(FlxColor.fromRGB(PlayState.instance.dad.healthColorArray[0], PlayState.instance.dad.healthColorArray[1], PlayState.instance.dad.healthColorArray[2]),
		FlxColor.fromRGB(PlayState.instance.boyfriend.healthColorArray[0], PlayState.instance.boyfriend.healthColorArray[1], PlayState.instance.boyfriend.healthColorArray[2]));
	}

}