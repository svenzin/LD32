package ld32;
import lde.Entity;

/**
 * ...
 * @author scorder
 */
class Util
{
	public static function sign(x : Float)
	{
		if (x > 0) return 1;
		else if (x < 0) return -1;
		else return 0;
	}
	
	public static function max(items : Array<Float>)
	{
		if (items.length == 0) return 0.0;
		var m = items[0];
		for (i in items)
		{
			if (i > m) m = i;
		}
		return m;
	}
	
	public static function dist2(a : Entity, b : Entity)
	{
		var dx = b.x - a.x;
		var dy = b.y - a.y;
		return (dx * dx + dy * dy);
	}
	
	public static function distance(a : Entity, b : Entity)
	{
		return Math.sqrt(dist2(a, b));
	}
}
