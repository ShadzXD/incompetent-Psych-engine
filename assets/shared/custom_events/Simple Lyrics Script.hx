

import flixel.text.FlxText;
import flixel.text.FlxTextBorderStyle;
var text:FlxText;
function onCreatePost()
{     
    text = new FlxText(2,FlxG.height * 0.65,600, "", 32);
    text.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 5);
    text.cameras = [game.camPreHUD];
    text.borderSize = 2;
    text.screenCenter(1);
    text.updateHitbox();
    game.add(text);
}

function onEvent(n, v1, v2)
{
    if (n == 'Simple Lyrics Script')
    {
        text.text = v1;
        if(v2 == '0') text.visible = false;
        else text.visible = true;
    }
}
