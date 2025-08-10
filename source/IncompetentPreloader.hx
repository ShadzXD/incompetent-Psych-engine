package;

import flixel.system.FlxBasePreloader;
import flash.display.*;
import flash.Lib;
import flash.text.*;
import openfl.display.Sprite;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;
import flixel.math.FlxMath;

@:bitmap("assets/shared/images/preloader.png")class LogoImage extends BitmapData{}

class IncompetentPreloader extends FlxBasePreloader
{
    public function new(MinDisplayTime:Float  = 0, ?AllowedURLS:Array<String>)
    {
        super(MinDisplayTime, AllowedURLS);
    }
        var logo:Sprite;
        var text:TextField;

    override  function create() {
        this._width = Lib.current.stage.stageWidth;
        this._height = Lib.current.stage.stageHeight;
        var ratio:Float = this._width / 800; //This allows us to scale assets depending on the size of the screen.
         
        logo = new Sprite();
        logo.addChild(new Bitmap(new LogoImage(0,0))); //Sets the graphic of the sprite to a Bitmap object, which uses our embedded BitmapData class.
        addChild(logo); //Adds the graphic to the NMEPreloader's buffer.

        super.create();
    }

    override public function update(percent:Float):Void
	{   
        
        if(percent < 0.3)
            logo.alpha = FlxMath.lerp(percent*(10/3), logo.alpha, 0.7);
        else
            logo.alpha = 1;
	}

        override function destroy():Void
    {

        logo = null;
        super.destroy();
    }
}