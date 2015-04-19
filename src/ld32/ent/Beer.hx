package ld32.ent;

import lde.*;
import openfl.geom.Rectangle;

class Beer extends Object
{
	public var qty = 3.0;
	public function new() 
	{
		super(EntityType.BEER);
	
		animation = Lde.gfx.getAnim(Tiles.BEER);
		box = new Rectangle(0, 0, Const.TileSize, Const.TileSize);
		anchored = false;
	}
	
}
