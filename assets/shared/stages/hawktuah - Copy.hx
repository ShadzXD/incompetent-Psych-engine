



function onCreatePost()
{
  trace('s');
    var SKY:FlxSprite = new FlxSprite(-1000,-400).loadGraphic(Paths.image('hawktuahtown/sky_gradient'));
    addBehindGF(SKY);

    var clouds:FlxSprite = new FlxSprite(-400, -200);
    clouds.frames = Paths.getSparrowAtlas('hawktuahtown/clouds');
    clouds.animation.addByPrefix('idle', 'cloud', 24, true);
		clouds.animation.play('idle');
    clouds.velocity.x = 10;
    addBehindGF(clouds);

    var buildings:FlxSprite = new FlxSprite(-1000,-200).loadGraphic(Paths.image('hawktuahtown/buildings'));
    addBehindGF(buildings);

    var backHill:FlxSprite = new FlxSprite(-1000,-200).loadGraphic(Paths.image('hawktuahtown/back_hill'));
    addBehindGF(backHill);

    var frontHill:FlxSprite = new FlxSprite(-1000,-200).loadGraphic(Paths.image('hawktuahtown/front_hill_layer'));
    addBehindGF(frontHill);
    var frenchie:FlxSprite = new FlxSprite(1880, 250);
    frenchie.frames = Paths.getSparrowAtlas('hawktuahtown/frenchie_hai');
    frenchie.animation.addByPrefix('idle', 'frenchie hai idle', 24, true);
		frenchie.animation.play('idle');
    frenchie.velocity.x = 1;
    addBehindGF(frenchie);

   var sign:FlxSprite = new FlxSprite(-1000,-200).loadGraphic(Paths.image('hawktuahtown/hawk_tuah_sign'));
   sign.scrollFactor.set(1.2,1.2);
    add(sign);

    var overlay:FlxSprite = new FlxSprite(-1000,-100).loadGraphic(Paths.image('hawktuahtown/overlay'));
    overlay.alpha = 0.9;
    add(overlay);
}

function onSongStart()
{
    trace('created!');
}
