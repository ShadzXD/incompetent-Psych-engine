package huds;

import objects.HealthIcon;
import objects.Bar;
import flixel.util.FlxStringUtil;
/*
* Recreation of Base Friday Night funkin's hud (V-Slice)
*/
class VanillaHUD extends MainHUD
{
    public var healthBar:Bar;
    var healthLerp:Float = 1;
    var iconOffset:Int = 26;

    public function new()
    {
		super();
        
		healthBar = new Bar(0, FlxG.height * (!ClientPrefs.data.downScroll ? 0.9 : 0.1), 'healthBar', function(){
			healthLerp = FlxMath.lerp(healthLerp, PlayState.instance.health, 0.12 / (ClientPrefs.data.framerate / 60));
			return healthLerp;
		}, 0, 2);		
		healthBar.screenCenter(X);
		healthBar.leftToRight = false;
		healthBar.scrollFactor.set();
		healthBar.alpha = ClientPrefs.data.healthBarAlpha;
		healthBar.setColors(FlxColor.RED, FlxColor.LIME);
		add(healthBar);

		scoreText = new FlxText(-400, healthBar.y + 40, FlxG.width, "", 20);
		scoreText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreText.scrollFactor.set();
		scoreText.updateHitbox();
		//updateScore(false);
		add(scoreText);

		iconP1 = new HealthIcon(PlayState.instance.boyfriend.healthIcon, true);
		iconP1.y = healthBar.y - 75;
		iconP1.alpha = ClientPrefs.data.healthBarAlpha;
		add(iconP1);

		iconP2 = new HealthIcon(PlayState.instance.dad.healthIcon, false);
		iconP2.y = healthBar.y - 75;
		iconP2.alpha = ClientPrefs.data.healthBarAlpha;
		add(iconP2);
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

    override public function updateScore(miss:Bool = false, ?score:Int, ?misses:Int, ?ratingName:String,?percent:Float)
	{
		var tempScore:String = 'Score: ${FlxStringUtil.formatMoney(score, false, true)}';
		scoreText.text = tempScore;
	}
	override public function botplayStuff():Void {
		scoreText.text = botplayText;
	}

    
	override function beatHit()
	{
		iconP1.scale.set(1.2, 1.2);
		iconP2.scale.set(1.2, 1.2);

		iconP1.updateHitbox();
		iconP2.updateHitbox();
    } 

}