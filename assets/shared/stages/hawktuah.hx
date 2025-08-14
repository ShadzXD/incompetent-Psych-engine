



function onCreatePost()
{
  trace('s');
    var SKY:FlxSprite = new FlxSprite(-1000,-400).loadGraphic(Paths.image('hawktuahtown/sky_gradient'));
 add(SKY);
}

function onSongStart()
{
    trace('created!');
}
