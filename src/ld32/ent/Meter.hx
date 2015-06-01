package ld32.ent;

import lde.*;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.geom.Rectangle;

class Meter extends Entity
{
	public static var Height = 6;
	
	public var owner : Entity;
	public var max : Float;
	public var value(get, set) : Float;
	
	var _v : Float;
	public function get_value() { return _v; }
	public function set_value(v) { _v = Util.clamp(v, 0.0, max); return v; }
	
	public var color = Colors.RED;
	
	override public function get_z() 
	{
		return owner.z;
	}
	
	public function new(_max : Float)
	{
		super();
		
		max = _max;
		value = max;
	}
	
	override public function render(data : BitmapData)
	{
		var s = Lde.gfx.scale;
		var w = Const.TileSize * value / max;
		
		data.fillRect(new Rectangle(x - w / 2 - 1, y - 2, w + 2, Height - 2), Colors.BLACK);
		data.fillRect(new Rectangle(x - w / 2, y - 1, w, Height - 4), color);
	}
}
