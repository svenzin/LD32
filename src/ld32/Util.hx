package ld32;
import lde.Entity;
import openfl.geom.Point;

/**
 * ...
 * @author scorder
 */
class Util
{
	public static function random<T>(items : Array<T>)
	{
		return items[Std.random(items.length)];
	}
	
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
	
	public static function clamp(x : Float, min : Float, max : Float)
	{
		return Math.max(min, Math.min(max, x));
	}
	
	public static function toGrid(x : Float, y : Float)
	{
		return [ Math.floor(x / Const.TileSize), Math.floor(y / Const.TileSize) ];
	}

	public static function fromGrid(x : Int, y : Int)
	{
		return new Point(x * Const.TileSize, y * Const.TileSize);
	}
}
