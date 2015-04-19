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

	static public var BEER = Id.get();
	
	static public var P = Id.get();
	static public var G = Id.get();

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
		
		reg(BEER, [0, 6], [1, 1]);
		
		reg(P, [0, 5], [1, 1]);
		reg(G, [0, 4], [1, 1]);
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
