package ld32;

import openfl.geom.Point;

class Orientation
{
	public static var INVALID = new Point();
	
	public static var E  = Point.polar(1.0, 0 * Math.PI / 4);
	public static var SE = Point.polar(1.0, 1 * Math.PI / 4);
	public static var S  = Point.polar(1.0, 2 * Math.PI / 4);
	public static var SW = Point.polar(1.0, 3 * Math.PI / 4);
	public static var W  = Point.polar(1.0, 4 * Math.PI / 4);
	public static var NW = Point.polar(1.0, 5 * Math.PI / 4);
	public static var N  = Point.polar(1.0, 6 * Math.PI / 4);
	public static var NE = Point.polar(1.0, 7 * Math.PI / 4);
	
	public static function random()
	{
		var o = [ N, NE, E, SE, S, SW, S, NW ];
		return o[Std.random(o.length)];
	}
	
	public static function closest(dx : Float, dy : Float)
	{
		if (dx == 0 && dy == 0) return INVALID;
		
		var o = [ S, SE, E, NE, N, NW, W, SW, S ];
		var angle = Math.atan2(dx, dy);
		while (angle < 0) angle += 2 * Math.PI;
		var index = Math.round(angle / (Math.PI / 4));
		
		return o[index];
	}
}
