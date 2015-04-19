package ld32.ent;

import lde.*;
import openfl.display.Graphics;

class Meter extends Entity implements ICustomRenderer
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
	
	function rect(g : Graphics, x : Float, y : Float, w : Float, h : Float)
	{
		var s = Lde.gfx.scale;
		g.drawRect(s * x, s * y, s * w, s * h);
	}
	public function render(graphics : Graphics)
	{
		var s = Lde.gfx.scale;
		var w = Const.TileSize * value / max;
		
		//if (w < 1.0)
		{
		//graphics.beginFill(Colors.WHITE);
		//rect(graphics, x - w / 2 - 2, y - 3, w + 4, Height);
		graphics.beginFill(Colors.BLACK);
		rect(graphics, x - w / 2 - 1, y - 2, w + 2, Height - 2);
		graphics.beginFill(color);
		rect(graphics, x - w / 2, y - 1, w, Height - 4);
		graphics.endFill();
		}
	}
}
