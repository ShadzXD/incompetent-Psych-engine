function onEvent(n, v1, v2)
{
    if (n == 'Flash Camera')
    {
        var parser:Int = Std.parseInt(v2);
        FlxG.camera.flash(parser, v1);
       
    }
}
