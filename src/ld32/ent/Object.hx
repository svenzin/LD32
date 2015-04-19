package ld32.ent;

import lde.Entity;

class Object extends Entity
{
	public var owner : Character;
	
	override public function get_z() 
	{
		return y - 0.1;
	}
}
