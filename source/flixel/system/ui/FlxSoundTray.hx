package flixel.system.ui;

import flixel.system.ui.FlxSoundTray;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.utils.Assets;
import openfl.display.Sprite;
import openfl.Lib;

/**
 *  Extends the default flixel soundtray, but with some art
 *  and lil polish!
 */
class FlxSoundTray extends Sprite
{
  var graphicScale:Float = 0.30;
  var lerpYPos:Float = 0;
  var alphaTarget:Float = 0;

  var volumeMaxSound:String;
  public var volumeUpSound:String;
  public var volumeDownSound:String;
  var _timer:Float;
	var _bars:Array<Bitmap>;
	public var active:Bool;
	public var silent:Bool = false;
	var _width:Int = 80;

	var _defaultScale:Float = 2.0;

  public function new()
  {
    // calls super, then removes all children to add our own
    // graphics
    super();
    removeChildren();

    var bg:Bitmap = new Bitmap(Assets.getBitmapData(Paths.getPath("images/soundtray/volumebox.png")));
    bg.scaleX = graphicScale;
    bg.scaleY = graphicScale;
    //bg.smoothing = true;
    addChild(bg);

    //y = -height;
    visible = false;

    // makes an alpha'd version of all the bars (bar_10.png)
    var backingBar:Bitmap = new Bitmap(Assets.getBitmapData(Paths.getPath("images/soundtray/bars_10.png")));
    backingBar.x = 9;
    backingBar.y = 5;
    backingBar.scaleX = graphicScale;
    backingBar.scaleY = graphicScale;
    backingBar.smoothing = true;
    addChild(backingBar);
    backingBar.alpha = 0.4;

    // clear the bars array entirely, it was initialized
    // in the super class
    _bars = [];

    // 1...11 due to how block named the assets,
    // we are trying to get assets bars_1-10
    for (i in 1...11)
    {
      var bar:Bitmap = new Bitmap(Assets.getBitmapData(Paths.getPath("images/soundtray/bars_" + i+".png")));
      bar.x = 9;
      bar.y = 5;
      bar.scaleX = graphicScale;
      bar.scaleY = graphicScale;
      bar.smoothing = true;
      addChild(bar);
      _bars.push(bar);
    }

    y = -height;
    screenCenter();

    volumeUpSound = Paths.getPath("sounds/soundtray/Volup."+Paths.SOUND_EXT);
    volumeDownSound = Paths.getPath("sounds/soundtray/Voldown."+Paths.SOUND_EXT);
    volumeMaxSound = Paths.getPath("sounds/soundtray/VolMAX."+Paths.SOUND_EXT);

    trace("Custom tray added!");
  }

	public function update(MS:Float):Void
    {

      y = CoolUtil.coolLerp(y, lerpYPos, 0.1);
      alpha = CoolUtil.coolLerp(alpha, alphaTarget, 0.25);
  
      // Animate sound tray thing
      if (_timer > 0)
      {
        _timer -= (MS / 1000);
        alphaTarget = 1;
      }
      else if (y >= -height)
      {
        lerpYPos = -height - 10;
        alphaTarget = 0;
      }
  
      if (y <= -height)
      {
        visible = false;
        active = false;
  
        #if FLX_SAVE
        // Save sound preferences
        if (FlxG.save.isBound)
        {
          FlxG.save.data.mute = FlxG.sound.muted;
          FlxG.save.data.volume = FlxG.sound.volume;
          FlxG.save.flush();
        }
        #end
      }
    }

  /**
   * Makes the little volume tray slide out.
   *
   * @param	up Whether the volume is increasing.
   */
    public function show(up:Bool = false):Void
    {
      _timer = 1;
      lerpYPos = 10;
      visible = true;
      active = true;
      var globalVolume:Int = Math.round(FlxG.sound.volume * 10);
  
      if (FlxG.sound.muted || FlxG.sound.volume == 0)
      {
        globalVolume = 0;
      }
  
      if (!silent)
      {
        var sound = up ? volumeUpSound : volumeDownSound;
  
        if (globalVolume == 10) sound = volumeMaxSound;
  
        if (sound != null) FlxG.sound.load(sound).play();
      }
  
      for (i in 0..._bars.length)
      {
        if (i < globalVolume)
        {
          _bars[i].visible = true;
        }
        else
        {
          _bars[i].visible = false;
        }
      }
    }
    
  public function screenCenter():Void
    {
      scaleX = _defaultScale;
      scaleY = _defaultScale;
  
      x = (0.5 * (Lib.current.stage.stageWidth - _width * _defaultScale) - FlxG.game.x);
    }
}