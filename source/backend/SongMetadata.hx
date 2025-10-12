package backend;
import lime.utils.Assets;
import haxe.Json;
typedef JsonMetaDataInfo =
{
	?composer:String,
	?artist:String,
	?charter:String,
	?coder:String
}

class SongMetadata
{
	public var songComposer:String;
	public var songCharter:String;
	public var songArtist:String;
	public var songCoder:String;

	public static var usesJson:Bool = false;
	public static var string:String;
	public function new()
	{
		string = Paths.json(Paths.formatToSongPath('tutorial') +'/metadata');

		var json:JsonMetaDataInfo =  Json.parse(Paths.getTextFromFile('data/tutorial/metadata.json'));
		
		songComposer = json.composer;
		songCharter = json.charter;
		songArtist = json.artist;
		songCoder = json.coder;

	
	}
	/**
	* Checks if theres metadata available for the selected song.
	* @param songName 
	* @return Bool
	*/
	public static function songMetaDataCheck(songName:String):Void
	{
		var	formattedSongString:String = Paths.formatToSongPath(songName);
		trace(formattedSongString);
		trace((Paths.json(formattedSongString +'/metadata')));
		string = Paths.json(formattedSongString +'/metadata');
		if(Assets.exists(string)) usesJson = true;
		else  usesJson = false;
	}
}

