package lde;

import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import lde.gfx.IRender;
import lde.gfx.Animation;

class Entity implements IRender
{
	public var type : Int;

	// Physics
	public var x : Float = 0.0;
	public var y : Float = 0.0;
	
	public var box : Rectangle = new Rectangle();
	public var anchored : Bool = false;
	
	// Graphics
	public var z(get, set) : Float;
	public var animation : Animation;
	
	var _z = 0.0;
	public function get_z() { return _z; }
	public function set_z(zz : Float) { _z = zz; return _z; }
	
	public function render(target : BitmapData)
	{
		animation.update();
		animation.renderAt(target, new Point(x, y));
	}
	
	// Entity
	
	public function new(_type : Int = 0) { type = _type; }
	
	public function world_box()
	{
		var b = box.clone();
		b.offset(x, y);
		return b;
	}
	
	public function center()
	{
		if (box == null) return new Point();
		
		return new Point((box.left + box.right) / 2,
		                 (box.top + box.bottom) / 2);
	}

	public function world_center()
	{
		if (box == null) return new Point();
		
		return new Point(x + (box.left + box.right) / 2,
		                 y + (box.top + box.bottom) / 2);
	}
}
