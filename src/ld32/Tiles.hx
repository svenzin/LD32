package ld32;

import lde.Id;
import lde.gfx.Animation;
import lde.gfx.AnimationData;
import lde.Tiler;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * ...
 * @author scorder
 */
class Tiles extends Tiler
{
	static public var TILE_SEAT = 1;
	static public var TILE_BAR  = 2;

	static public var TILE_PLAYER = 17;
	static public var TILE_GRUNT  = 18;
	static public var TILE_BEER   = 19;

	static public var BG1 : AnimationData;
	static public var BG2 : AnimationData;

	static public var BEER_FULL   : AnimationData;
	static public var BEER_HALF   : AnimationData;
	static public var BEER_EMPTY  : AnimationData;
	static public var BEER_BROKEN : AnimationData;
	
	static public var P_N  : AnimationData;
	static public var P_S  : AnimationData;
	static public var P_E  : AnimationData;
	static public var P_W  : AnimationData;
	static public var P_NE : AnimationData;
	static public var P_NW : AnimationData;
	static public var P_SE : AnimationData;
	static public var P_SW : AnimationData;
	
	static public var G_N  : AnimationData;
	static public var G_S  : AnimationData;
	static public var G_E  : AnimationData;
	static public var G_W  : AnimationData;
	static public var G_NE : AnimationData;
	static public var G_NW : AnimationData;
	static public var G_SE : AnimationData;
	static public var G_SW : AnimationData;
	static public var G_OUT: AnimationData;

	static var initialized = false;
	static var singleton : Tiles;
	public static function init()
	{
		if (!initialized)
		{
			initialized = true;
			singleton = new Tiles();
		}
	}

	var tileRects : Array<Rectangle>;
	public function new() 
	{
		super(Assets.getBitmapData("img/tiles.png"));
		
		var sx = Const.TileSize;
		var sy = Const.TileSize;
		
		tileRects = slice([0, 0], [sx, sy], [16, 16]);
		
		BG1 = load([0, 0], [1, 1]);
		BG2 = load([1, 0], [1, 1]);
		
		BEER_FULL   = load([0, 6], [1, 1]);
		BEER_HALF   = load([1, 6], [1, 1]);
		BEER_EMPTY  = load([2, 6], [1, 1]);
		BEER_BROKEN = load([3, 6], [1, 1]);
		
		P_N  = load([0, 5], [1, 1]);
		P_NW = load([1, 5], [1, 1]);
		P_W  = load([2, 5], [1, 1]);
		P_SW = load([3, 5], [1, 1]);
		P_S  = load([4, 5], [1, 1]);
		P_SE = load([5, 5], [1, 1]);
		P_E  = load([6, 5], [1, 1]);
		P_NE = load([7, 5], [1, 1]);
		
		G_N   = load([0, 4], [1, 1]);
		G_NW  = load([1, 4], [1, 1]);
		G_W   = load([2, 4], [1, 1]);
		G_SW  = load([3, 4], [1, 1]);
		G_S   = load([4, 4], [1, 1]);
		G_SE  = load([5, 4], [1, 1]);
		G_E   = load([6, 4], [1, 1]);
		G_NE  = load([7, 4], [1, 1]);
		G_OUT = load([8, 4], [1, 1]);
	}
	
	var _tilemap = new Map<Int, AnimationData>();
	public function getTile(id : Int) : Animation
	{
		if (id >= tileRects.length) return null;
		
		if (!_tilemap.exists(id)) _tilemap[id] = new AnimationData(data, [ tileRects[id] ], [ new Point() ]);

		return _tilemap[id].get();
	}
	
	public function load(x : Array<Int>, s : Array<Int>)
	{
		var ts = Const.TileSize;
		var rects = slice([ ts * x[0], ts * x[1] ], [ ts, ts ], s);
		return get(rects);
	}
}
