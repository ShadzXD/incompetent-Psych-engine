//by kornelbut. credit would be neat

import flixel.FlxCamera;
import flixel.FlxObject;
import psychlua.LuaUtils;

var camLeft:FlxCamera;
var camRight:FlxCamera;
var camFollowDad:FlxObject;
var camFollowBf:FlxObject;

var leftEdge:FlxCamera;
var rightEdge:FlxCamera;

var dual:Bool = false;
var swapped:Bool = false;

var camLeftOffsets:Array<Float> = [0, 0];
var camRightOffsets:Array<Float> = [0, 0];
var camLeftZoom:Float = 1;
var camRightZoom:Float = 1;

function onCreate() {}

function onCreatePost()
{    
    camLeft = new FlxCamera();
    camLeft.width = FlxG.width/2;
    camLeft.alpha = 0.001;
    camRight = new FlxCamera();
    camRight.x = FlxG.width/2;
    camRight.width = FlxG.width/2;
    camRight.alpha = 0.001;

    leftEdge = new FlxCamera();
    leftEdge.x = -FlxG.width-1;
    leftEdge.alpha = 0.001;
    rightEdge = new FlxCamera();
    rightEdge.x = FlxG.width+1;
    rightEdge.alpha = 0.001;

    FlxG.cameras.remove(game.camHUD, false);
    FlxG.cameras.remove(game.camOther, false);
    FlxG.cameras.add(camLeft, false);
    FlxG.cameras.add(camRight, false);
    FlxG.cameras.add(leftEdge, false);
    FlxG.cameras.add(rightEdge, false);
    FlxG.cameras.add(game.camHUD, false);
    FlxG.cameras.add(game.camOther, false);

    camFollowDad = new FlxObject();
    splitCameraPos(false);
    add(camFollowDad);

    camFollowBf = new FlxObject();
    splitCameraPos(true);
    add(camFollowBf);

    camLeft.follow(camFollowDad, Type.getEnum(game.camGame.style).LOCKON, 0);
    camRight.follow(camFollowBf, Type.getEnum(game.camGame.style).LOCKON, 0);

    camLeft.x = -(FlxG.width/2);
    camRight.x = FlxG.width;
    camLeftZoom = defaultCamZoom;
    camRightZoom = defaultCamZoom;
}

function onEvent(n, v1, v2)
{
    if (n == 'Split Screen')
    {
        var values1 = v1.split(',');
        var values2 = v2.split(',');

        var duration = (values1[0] != '' && values1[0] != null ? values1[0] : 0.001);
        var ease = (values1[1] != '' && values1[1] != null ? values1[1] : 'linear');
        var leftZoom = (values1[2] != '' && values1[2] != null ? values1[2] : defaultCamZoom);
        var rightZoom = (values1[3] != '' && values1[3] != null ? values1[3] : defaultCamZoom);
        var swap = (values1[4] == '' && values1[4] != null ? swapped : values1[4] == 'true');

        var leftX = (values2[0] != '' && values2[0] != null ? values2[0] : 0);
        var leftY = (values2[1] != '' && values2[1] != null ? values2[1] : 0);
        var rightX = (values2[2] != '' && values2[2] != null ? values2[2] : 0);
        var rightY = (values2[3] != '' && values2[3] != null ? values2[3] : 0);

        dual = !dual;
        if (dual) swapped = swap;

        if (Std.parseFloat(duration) <= 0) duration = 0.001;

        camLeft.alpha = camRight.alpha = leftEdge.alpha = rightEdge.alpha = 1;

        FlxTween.cancelTweensOf(camLeft);
        FlxTween.cancelTweensOf(camRight);
        FlxTween.tween(!swapped ? camLeft : camRight, {x: dual ? 0 : -(FlxG.width/2)}, duration,
        {
            ease: LuaUtils.getTweenEaseByString(ease),
            onComplete: function(twn:FlxTween)
            {
                if (!dual) (!swapped ? camLeft : camRight).alpha = leftEdge.alpha = rightEdge.alpha = 0.001;
            }
        });
        FlxTween.tween(!swapped ? camRight : camLeft, {x: dual ? FlxG.width/2 : FlxG.width}, duration,
        {
            ease: LuaUtils.getTweenEaseByString(ease),
            onComplete: function(twn:FlxTween)
            {
                if (!dual) (!swapped ? camRight : camLeft).alpha = leftEdge.alpha = rightEdge.alpha = 0.001;
            }
        });

        if (!dual) return;

        splitCameraPos(false, Std.parseFloat(leftX), Std.parseFloat(leftY));
        splitCameraPos(true, Std.parseFloat(rightX), Std.parseFloat(rightY));
        if (swapped && dual)
        {
            camLeft.x = FlxG.width;
            camRight.x = -(FlxG.width/2);
        }
        camLeftZoom = Std.parseFloat(leftZoom);
        camRightZoom = Std.parseFloat(rightZoom);
        camLeft.snapToTarget();
        camRight.snapToTarget();
    }

    if (n == 'Add Camera Zoom')
    {
        if(ClientPrefs.data.camZooms && FlxG.camera.zoom < 1.35 + Std.parseFloat(v1))
        {
            var zoom = (v1 != '' && v1 != null ? v1 : 0.015);
            camLeft.zoom += Std.parseFloat(zoom);
            camRight.zoom += Std.parseFloat(zoom);
        }
    }
}

function splitCameraPos(left, ?x = null, ?y = null)
{
    if (!left)
    {
        if (x != null) camLeftOffsets[0] = x;
        if (y != null) camLeftOffsets[1] = y;
        camFollowDad.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
        camFollowDad.x += dad.cameraPosition[0] + opponentCameraOffset[0] + camLeftOffsets[0];
        camFollowDad.y += dad.cameraPosition[1] + opponentCameraOffset[1] + camLeftOffsets[1];
    }
    else
    {
        if (x != null) camRightOffsets[0] = x;
        if (y != null) camRightOffsets[1] = y;
        camFollowBf.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
        camFollowBf.x -= boyfriend.cameraPosition[0] - boyfriendCameraOffset[0] - camRightOffsets[0];
        camFollowBf.y += boyfriend.cameraPosition[1] + boyfriendCameraOffset[1] + camRightOffsets[1];
    }
}

function onUpdate(elapsed)
{
    for (shit in game)
    {
        if (shit.camera == game.camGame && shit.camera != game.camLeft && shit.camera != game.camRight)
            shit.cameras = [camGame, camLeft, camRight];
    }

    for (cam in [camLeft, camRight])
    {
        if (cam.filters != game.camGame.filters)
            cam.filters = game.camGame.filters;
    }

    if (camZooming)
    {
        camLeft.zoom = FlxMath.lerp(camLeftZoom, camLeft.zoom, Math.exp(-elapsed * 3.125 * camZoomingDecay * playbackRate));
        camRight.zoom = FlxMath.lerp(camRightZoom, camRight.zoom, Math.exp(-elapsed * 3.125 * camZoomingDecay * playbackRate));
    }
}

function onSectionHit()
{
    if (camZooming && FlxG.camera.zoom < 1.35 && ClientPrefs.data.camZooms)
    {
        camLeft.zoom += 0.015 * camZoomingMult;
        camRight.zoom += 0.015 * camZoomingMult;
    }
}

function onGameOver()
{
    FlxG.cameras.remove(camLeft, false);
    FlxG.cameras.remove(camRight, false);
    FlxG.cameras.remove(leftEdge, false);
    FlxG.cameras.remove(rightEdge, false);
}