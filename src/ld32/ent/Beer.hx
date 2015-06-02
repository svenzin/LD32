package ld32.ent;

import lde.*;
import openfl.geom.Rectangle;

class Beer extends Object
{
	public var qty = 13.0;
	public function new() 
	{
		super(EntityType.BEER);
	
		box = new Rectangle(2, 2, Const.TileSize - 2 - 2, Const.TileSize - 2 - 2);
		anchored = false;
		
		update();
	}
	
	function update()
	{
		if (broken) animation = Tiles.BEER_BROKEN.get();
		else if (qty > 2) animation = Tiles.BEER_FULL.get();
		else if (qty > 1) animation = Tiles.BEER_HALF.get();
		else animation = Tiles.BEER_EMPTY.get();
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
