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

	static public var TILE_PLAYER = 3;
	static public var TILE_GRUNT  = 4;
	static public var TILE_BEER   = 5;

	static public var BG1 = Id.get();
	static public var BG2 = Id.get();

	static public var CHAIR = Id.get();
	static public var WINE = Id.get();
	static public var BEER = Id.get();
	
	static public var BAR_0 = Id.get();
	
	static public var TABLE_0 = Id.get();
	
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
		
		register(BG1, slice([ 0, 0 ], [ sx, sy ], [ 1, 1 ]));
		register(BG2, slice([ sx, 0 ], [ sx, sy ], [ 1, 1 ]));
		
		register(CHAIR, slice([ 2*sx, 0 ], [ sx, sy ], [ 1, 1 ]));
		register(WINE, slice([ 3*sx, 0 ], [ sx, sy ], [ 1, 1 ]));
		register(BEER, slice([ 4*sx, 0 ], [ sx, sy ], [ 1, 1 ]));
		
		register(BAR_0, slice([ 0 * sx, 2 * sy ], [ sx, sy ], [ 1, 1 ]));
		register(TABLE_0, slice([ 0 * sx, 1 * sy ], [ sx, sy ], [ 1, 1 ]));
		
		register(P, slice([ 0 * sx, 3 * sy ], [ sx, sy ], [ 1, 1 ]));
		
		register(G, slice([ 0 * sx, 5 * sy ], [ sx, sy ], [ 1, 1 ]));
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
