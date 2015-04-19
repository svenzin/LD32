package ld32;

import openfl.geom.Point;

class Orientation
{
	public static var N  = new Point( 0, -1);
	public static var E  = new Point( 1,  0);
	public static var S  = new Point( 0,  1);
	public static var W  = new Point(-1,  0);
	
	public static var NE = new Point( 0.707, -0.707);
	public static var SE = new Point( 0.707,  0.707);
	public static var SW = new Point(-0.707,  0.707);
	public static var NW = new Point(-0.707, -0.707);
	
	public static function random()
	{
		var o = [ N, NE, E, SE, S, SW, S, NW ];
		return o[Std.random(o.length)];
	}
}
