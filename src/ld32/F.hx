package ld32;
import ld32.ent.Character;
import ld32.ent.EntityType;
import ld32.ent.Object;
import lde.Entity;

/**
 * ...
 * @author scorder
 */
class F
{
	public static function obj()
	{
		return function (e : Entity)
		{
			return cast(e, Object);
		};
	}
	
	public static function isA(type : Int)
	{
		return function (e : Entity)
		{
			return e.type == type;
		};
	}

	public static function notAnchored()
	{
		return function (e : Entity)
		{
			return !e.anchored;
		};
	}
	
	public static function isOut()
	{
		return function (e : Character)
		{
			return (e.life.value == 0) ||
			       (e.power.value == 0);
		}
	}
}