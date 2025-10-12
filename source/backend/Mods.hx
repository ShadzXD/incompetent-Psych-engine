package backend;

import haxe.Json;

typedef ModsList = {
	enabled:Array<String>,
	disabled:Array<String>,
	all:Array<String>
};

class Mods
{
	static public var currentModDirectory:String = '';
	public static var ignoreModFolders:Array<String> = [
		'characters',
		'custom_events',
		'custom_notetypes',
		'data',
		'songs',
		'music',
		'sounds',
		'shaders',
		'videos',
		'images',
		'stages',
		'weeks',
		'fonts',
		'scripts',
		'achievements'
	];

	private static var globalMods:Array<String> = [];

	inline public static function getGlobalMods()
		return globalMods;

	inline public static function pushGlobalMods() // prob a better way to do this but idc
	{
		globalMods = [];
		for(mod in parseList().enabled)
		{
			var pack:Dynamic = getPack(mod);
			if(pack != null && pack.runsGlobally) globalMods.push(mod);
		}
		return globalMods;
	}

	inline public static function getModDirectories():Array<String>
	{
		var list:Array<String> = [];
		return list;
	}
	
	inline public static function mergeAllTextsNamed(path:String, defaultDirectory:String = null, allowDuplicates:Bool = false)
	{
		if(defaultDirectory == null) defaultDirectory = Paths.getSharedPath();
		defaultDirectory = defaultDirectory.trim();
		if(!defaultDirectory.endsWith('/')) defaultDirectory += '/';
		if(!defaultDirectory.startsWith('assets/')) defaultDirectory = 'assets/$defaultDirectory';

		var mergedList:Array<String> = [];
		var paths:Array<String> = directoriesWithFile(defaultDirectory, path);

		var defaultPath:String = defaultDirectory + path;
		if(paths.contains(defaultPath))
		{
			paths.remove(defaultPath);
			paths.insert(0, defaultPath);
		}

		for (file in paths)
		{
			var list:Array<String> = CoolUtil.coolTextFile(file);
			for (value in list)
				if((allowDuplicates || !mergedList.contains(value)) && value.length > 0)
					mergedList.push(value);
		}
		return mergedList;
	}

	inline public static function directoriesWithFile(path:String, fileToFind:String, mods:Bool = true)
	{
		var foldersToCheck:Array<String> = [];
		#if sys
		if(FileSystem.exists(path + fileToFind))
		#end
			foldersToCheck.push(path + fileToFind);
		return foldersToCheck;
	}

	public static function getPack(?folder:String = null):Dynamic
	{
		return null;
	}

	public static var updatedOnState:Bool = false;
	inline public static function parseList():ModsList {
		
		var list:ModsList = {enabled: [], disabled: [], all: []};

		return list;
	}
	

	public static function loadTopMod()
	{
		Mods.currentModDirectory = '';
	}
}