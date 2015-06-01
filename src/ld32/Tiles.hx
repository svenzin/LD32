package ld32;

import lde.Id;
import lde.TiledAnimation;
import lde.Tiler;
import openfl.Assets;
import openfl.display.BitmapData;
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

	static public var BG1 : Void -> TiledAnimation;
	static public var BG2 : Void -> TiledAnimation;

	static public var BEER_FULL   : Void -> TiledAnimation;
	static public var BEER_HALF   : Void -> TiledAnimation;
	static public var BEER_EMPTY  : Void -> TiledAnimation;
	static public var BEER_BROKEN : Void -> TiledAnimation;
	
	static public var P_N  : Void -> TiledAnimation;
	static public var P_S  : Void -> TiledAnimation;
	static public var P_E  : Void -> TiledAnimation;
	static public var P_W  : Void -> TiledAnimation;
	static public var P_NE : Void -> TiledAnimation;
	static public var P_NW : Void -> TiledAnimation;
	static public var P_SE : Void -> TiledAnimation;
	static public var P_SW : Void -> TiledAnimation;
	
	static public var G_N  : Void -> TiledAnimation;
	static public var G_S  : Void -> TiledAnimation;
	static public var G_E  : Void -> TiledAnimation;
	static public var G_W  : Void -> TiledAnimation;
	static public var G_NE : Void -> TiledAnimation;
	static public var G_NW : Void -> TiledAnimation;
	static public var G_SE : Void -> TiledAnimation;
	static public var G_SW : Void -> TiledAnimation;
	static public var G_OUT: Void -> TiledAnimation;

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

	var tileIds : Array<Int>;
	var tileRects : Array<Rectangle>;
	public function new() 
	{
		super(Assets.getBitmapData("img/tiles.png"));
		
		var sx = Const.TileSize;
		var sy = Const.TileSize;
		
		var slices = slice([0, 0], [sx, sy], [16, 16]);
		tileIds = slices.Tiles;
		tileRects = slices.Rects;
		
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
	
	function reg(id : Int, x : Array<Int>, s : Array<Int>)
	{
		var ts = Const.TileSize;
		var slc = slice([ ts * x[0], ts * x[1] ], [ ts, ts ], s);
		register(id, slc.Tiles, slc.Rects);
	}
	
	public function getTile(id : Int) : TiledAnimation
	{
		if (id >= tileIds.length) return null;
		
		var a = new TiledAnimation();
		a.id = id;
		a.indices = [ tileIds[id] ];
		a.rectangles = [ tileRects[id] ];
		a.tiler = this;
		return a;
	}
	
	public function load(x : Array<Int>, s : Array<Int>)
	{
		var id = Id.get();
		
		var ts = Const.TileSize;
		var slc = slice([ ts * x[0], ts * x[1] ], [ ts, ts ], s);
		register(id, slc.Tiles, slc.Rects);
		
		return function()
		{
			return get(id);
		}
	}
}
