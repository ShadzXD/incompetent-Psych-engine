/*
 * By NickNGC
 * If used, give proper credit
*/

import psychlua.LuaUtils;

var camTween;

function onEvent(name, val1, val2) {
    if (name != 'Simple Cam Zoom') return;

    final val = val1.split(',');

    if (camTween != null) camTween.cancel();
    camTween = FlxTween.num(game.defaultCamZoom, Std.parseFloat(val[0]), Std.parseFloat(val[1]) ?? 1, {ease: LuaUtils.getTweenEaseByString(val2)}, (v) -> game.defaultCamZoom = v);
}