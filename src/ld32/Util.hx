package ld32;

/**
 * ...
 * @author scorder
 */
class Util
{
	public static function sign(x : Float)
	{
		if (x >= 0) return 1.0; else return -1.0;
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
}
