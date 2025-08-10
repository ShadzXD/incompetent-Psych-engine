//by kornelbut. credit would be neat

import flixel.FlxCamera;
import flixel.FlxObject;

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
