package ld32.ent;

import lde.Entity;

class Furniture extends Entity
{
	override public function get_z() 
	{
		return 0;// Math.floor(y / Const.TileSize);
	}
}
