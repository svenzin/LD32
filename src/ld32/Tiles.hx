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

	static public var BG1 = Id.get();
	static public var BG2 = Id.get();

	static public var BEER_FULL   = Id.get();
	static public var BEER_HALF   = Id.get();
	static public var BEER_EMPTY  = Id.get();
	static public var BEER_BROKEN = Id.get();
	
	static public var P_N  = Id.get();
	static public var P_S  = Id.get();
	static public var P_E  = Id.get();
	static public var P_W  = Id.get();
	static public var P_NE = Id.get();
	static public var P_NW = Id.get();
	static public var P_SE = Id.get();
	static public var P_SW = Id.get();
	
	static public var G_N  = Id.get();
	static public var G_S  = Id.get();
	static public var G_E  = Id.get();
	static public var G_W  = Id.get();
	static public var G_NE = Id.get();
	static public var G_NW = Id.get();
	static public var G_SE = Id.get();
	static public var G_SW = Id.get();
	static public var G_OUT= Id.get();

	static public var _ = Id.get();

	var tileIds : Array<Int>;
	public function new() 
	{
		super(Assets.getBitmapData("img/tiles.png"));
		
		var sx = Const.TileSize;
		var sy = Const.TileSize;
		
		tileIds = slice([0, 0], [sx, sy], [16, 16]);
		
		reg(BG1, [0, 0], [1, 1]);
		reg(BG2, [1, 0], [1, 1]);
		
		reg(BEER_FULL,   [0, 6], [1, 1]);
		reg(BEER_HALF,   [1, 6], [1, 1]);
		reg(BEER_EMPTY,  [2, 6], [1, 1]);
		reg(BEER_BROKEN, [3, 6], [1, 1]);
		
		reg(P_N , [0, 5], [1, 1]);
		reg(P_NW, [1, 5], [1, 1]);
		reg(P_W , [2, 5], [1, 1]);
		reg(P_SW, [3, 5], [1, 1]);
		reg(P_S , [4, 5], [1, 1]);
		reg(P_SE, [5, 5], [1, 1]);
		reg(P_E , [6, 5], [1, 1]);
		reg(P_NE, [7, 5], [1, 1]);
		
		reg(G_N , [0, 4], [1, 1]);
		reg(G_NW, [1, 4], [1, 1]);
		reg(G_W , [2, 4], [1, 1]);
		reg(G_SW, [3, 4], [1, 1]);
		reg(G_S , [4, 4], [1, 1]);
		reg(G_SE, [5, 4], [1, 1]);
		reg(G_E , [6, 4], [1, 1]);
		reg(G_NE, [7, 4], [1, 1]);
		reg(G_OUT,[8, 4], [1, 1]);
	}
	
	function reg(id : Int, x : Array<Int>, s : Array<Int>)
	{
		var ts = Const.TileSize;
		register(id, slice([ ts * x[0], ts * x[1] ], [ ts, ts ], s));
	}
	
	public function getTile(id : Int) : TiledAnimation
	{
		if (id >= tileIds.length) return null;
		
		var a = new TiledAnimation();
		a.id = id;
		a.indices = [ tileIds[id] ];
		a.tiler = this;
		return a;
	}
}
