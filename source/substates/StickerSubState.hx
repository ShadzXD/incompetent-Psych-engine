package substates;

import haxe.Json;
import flixel.util.FlxSort;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
using backend.IteratorTools;
using StringTools;
import flixel.math.FlxMath;
class StickerSubState extends MusicBeatSubstate
{
  public var grpStickers:FlxTypedGroup<StickerSprite>;
  /**
   * The state to switch to after the stickers are done.
   * This is a FUNCTION so we can pass it directly to `FlxG.switchState()`,
   * and we can add constructor parameters in the caller.
   */
  var targetState:StickerSubState->FlxState;

  // what "folders" to potentially load from (as of writing only "keys" exist)
  var soundSelections:Array<String> = [];
  // what "folder" was randomly selected
  var soundSelection:String = "";
  var sounds:Array<String> = [];
  var nextState:NEXTSTATE = FREEPLAY;

  public function new(?oldStickers:Array<StickerSprite>,  ?nextState:NEXTSTATE = FREEPLAY):Void
  {
    super();

    this.nextState = nextState;

    // todo still
    // make sure that ONLY plays mp3/ogg files
    // if there's no mp3/ogg file, then it regenerates/reloads the random folder

    var assetsInList = openfl.utils.Assets.list();

    var soundFilterFunc = function(a:String) {
      return a.startsWith('assets/shared/sounds/stickersounds/');
    };

    soundSelections = assetsInList.filter(soundFilterFunc);
    soundSelections = soundSelections.map(function(a:String) {
      return a.replace('assets/shared/sounds/stickersounds/', '').split('/')[0];
    });

    // cracked cleanup... yuchh...
    for (i in soundSelections)
    {
      while (soundSelections.contains(i))
      {
        soundSelections.remove(i);
      }
      soundSelections.push(i);
    }

    trace(soundSelections);

    soundSelection = FlxG.random.getObject(soundSelections);

    var filterFunc = function(a:String) {
      return a.startsWith('assets/shared/sounds/stickersounds/' + soundSelection + '/');
    };
    var assetsInList3 = openfl.utils.Assets.list();
    sounds = assetsInList3.filter(filterFunc);
    for (i in 0...sounds.length)
    {
      sounds[i] = sounds[i].replace('assets/shared/sounds/', '');
      sounds[i] = sounds[i].substring(0, sounds[i].lastIndexOf('.'));
    }

    trace(sounds);

    grpStickers = new FlxTypedGroup<StickerSprite>();
    add(grpStickers);

    // makes the stickers on the most recent camera, which is more often than not... a UI camera!!
    // grpStickers.cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
    grpStickers.cameras = FlxG.cameras.list;

    if (oldStickers != null)
    {
      for (sticker in oldStickers)
      {
        grpStickers.add(sticker);
      }

      degenStickers();
    }
    else
      regenStickers();
  }

  public function degenStickers():Void
  {
    grpStickers.cameras = FlxG.cameras.list;

    /*
      if (dipshit != null)
      {
        FlxG.removeChild(dipshit);
        dipshit = null;
      }
     */

    if (grpStickers.members == null || grpStickers.members.length == 0)
    {
      switchingState = false;
      close();
      return;
    }

    for (ind => sticker in grpStickers.members)
    {
      new FlxTimer().start(sticker.timing, _ -> {
        sticker.visible = false;
        var daSound:String = FlxG.random.getObject(sounds);
        new FlxSound().loadEmbedded(Paths.sound(daSound)).play();

        if (grpStickers == null || ind == grpStickers.members.length - 1)
        {
          switchingState = false;
        

          close();
        }
      });
    }
  }

  function regenStickers():Void
  {
    if (grpStickers.members.length > 0)
    {
      grpStickers.clear();
    }

    var stickerInfo:StickerInfo = new StickerInfo('stickers-set-1');
    var stickers:Map<String, Array<String>> = new Map<String, Array<String>>();
    for (stickerSets in stickerInfo.getPack("all"))
    {
      stickers.set(stickerSets, stickerInfo.getStickers(stickerSets));
    }

    var xPos:Float = -100;
    var yPos:Float = -100;
    while (xPos <= FlxG.width)
    {
      var stickerSet:String = FlxG.random.getObject(stickers.keys().array());
      var sticker:String = FlxG.random.getObject(stickers.get(stickerSet));
      var sticky:StickerSprite = new StickerSprite(0, 0, stickerInfo.name, sticker);
      sticky.visible = false;

      sticky.x = xPos;
      sticky.y = yPos;
      xPos += sticky.frameWidth * 0.5;

      if (xPos >= FlxG.width)
      {
        if (yPos <= FlxG.height)
        {
          xPos = -100;
          yPos += FlxG.random.float(70, 120);
        }
      }

      sticky.angle = FlxG.random.int(-60, 70);
      grpStickers.add(sticky);
    }

    FlxG.random.shuffle(grpStickers.members);

    for (ind => sticker in grpStickers.members)
    {
      sticker.timing = FlxMath.remapToRange(ind, 0, grpStickers.members.length, 0, 0.9);

      new FlxTimer().start(sticker.timing, _ -> {
        if (grpStickers == null) return;

        sticker.visible = true;
        var daSound:String = FlxG.random.getObject(sounds);
        new FlxSound().loadEmbedded(Paths.sound(daSound)).play();

        var frameTimer:Int = FlxG.random.int(0, 2);

        // always make the last one POP
        if (ind == grpStickers.members.length - 1) frameTimer = 2;

        new FlxTimer().start((1 / 24) * frameTimer, _ -> {
          if (sticker == null) return;

          sticker.scale.x = sticker.scale.y = FlxG.random.float(0.97, 1.02);

          if (ind == grpStickers.members.length - 1)
          {
            switchingState = true;

            FlxTransitionableState.skipNextTransIn = true;
            FlxTransitionableState.skipNextTransOut = true;
            /*
            *Use this to add it to your state
            */
             switch (nextState)
             {
                case FREEPLAY:
                  FlxG.switchState(new states.FreeplayState(this));
                case STORY:
                  FlxG.switchState(new states.StoryMenuState(this));
                default:
                  FlxG.switchState(new states.FreeplayState(this));
             }
          }
        });
      });
    }

    grpStickers.sort((ord, a, b) -> {
      return FlxSort.byValues(ord, a.timing, b.timing);
    });

    // centers the very last sticker
    var lastOne:StickerSprite = grpStickers.members[grpStickers.members.length - 1];
    lastOne.updateHitbox();
    lastOne.angle = 0;
    lastOne.screenCenter();
    
  }

  var switchingState:Bool = false;

  override public function close():Void
  {
    if (switchingState) return;
    super.close();
  }

  override public function destroy():Void
  {
    if (switchingState) return;
    super.destroy();
  }
}

class StickerSprite extends FlxSprite
{
  public var timing:Float = 0;

  public function new(x:Float, y:Float, stickerSet:String, stickerName:String):Void
  {
    super(x, y);
    var str:String ='menus/transitionSwag/' + stickerSet + '/' + stickerName;
    loadGraphic(Paths.image(str));
    updateHitbox();
  
 

    scrollFactor.set();
  }
}

class StickerInfo
{
  public var name:String;
  public var artist:String;
  public var stickers:Map<String, Array<String>>;
  public var stickerPacks:Map<String, Array<String>>;

  public function new(stickerSet:String):Void
  {
		var json = tjson.TJSON.parse(Paths.getTextFromFile('stickers.json'));

    // doin this dipshit nonsense cuz i dunno how to deal with casting a json object with
    // a dash in its name (sticker-packs)
    var jsonInfo:StickerShit = cast json;

    this.name = jsonInfo.name;
    this.artist = jsonInfo.artist;

    stickerPacks = new Map<String, Array<String>>();

    for (field in Reflect.fields(json.stickerPacks))
    {
      var stickerFunny = json.stickerPacks;
      var stickerStuff = Reflect.field(stickerFunny, field);

      stickerPacks.set(field, cast stickerStuff);
    }

    // creates a similar for loop as before but for the stickers
    stickers = new Map<String, Array<String>>();

    for (field in Reflect.fields(json.stickers))
    {
      var stickerFunny = json.stickers;
      var stickerStuff = Reflect.field(stickerFunny, field);

      stickers.set(field, cast stickerStuff);
    }
  }

  public function getStickers(stickerName:String):Array<String>
  {
    return this.stickers[stickerName];
  }

  public function getPack(packName:String):Array<String>
  {
    return this.stickerPacks[packName];
  }
}

// somethin damn cute just for the json to cast to!
typedef StickerShit =
{
  name:String,
  artist:String,
  stickers:Map<String, Array<String>>,
  stickerPacks:Map<String, Array<String>>
}

enum abstract NEXTSTATE(String)
{
  var FREEPLAY = 'freeplay';
  var MAINMENU = 'mainmenu';
  var STORY = 'story';
  var PLAYSTATE = 'playstate';

}