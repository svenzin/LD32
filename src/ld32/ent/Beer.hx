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
		box = new Rectangle(2, 2, Const.TileSize - 4, Const.TileSize - 4);
		anchored = false;
	}
	
}
