package ld32.ent;

import lde.*;
import openfl.geom.Rectangle;

class Beer extends Object
{
	public var qty = 3.0;
	public function new() 
	{
		super(EntityType.BEER);
	
		box = new Rectangle(2, 2, Const.TileSize - 2 - 2, Const.TileSize - 2 - 2);
		anchored = false;
		
		update();
	}
	
	function update()
	{
		if (broken) animation = Lde.gfx.getAnim(Tiles.BEER_BROKEN);
		else if (qty > 2) animation = Lde.gfx.getAnim(Tiles.BEER_FULL);
		else if (qty > 1) animation = Lde.gfx.getAnim(Tiles.BEER_HALF);
		else animation = Lde.gfx.getAnim(Tiles.BEER_EMPTY);
	}
	
	public function drink()
	{
		var q = qty;
		qty = Util.clamp(0, qty - 1, 3);
		update();
		return q - qty;
	}
	
	var broken = false;
	public function drop()
	{
		broken = true;
		box = new Rectangle(4, 4, Const.TileSize - 4 - 4, Const.TileSize - 4 - 4);
		update();
	}
}
