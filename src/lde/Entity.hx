package lde;
import openfl.geom.Point;
import openfl.geom.Rectangle;

class Entity
{
	// Physics
	public var x : Float = 0.0;
	public var y : Float = 0.0;
	
	public var box : Rectangle = new Rectangle();
	public var anchored : Bool = false;
	
	// Graphics
	public var animation : TiledAnimation;
	
	public function new() { }
	
	public function world_box()
	{
		var b = box.clone();
		b.offset(x, y);
		return b;
	}
	
	public function center()
	{
		return new Point((box.left + box.right) / 2,
		                 (box.top + box.bottom) / 2);
	}
}
