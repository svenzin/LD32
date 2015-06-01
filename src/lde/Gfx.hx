package lde;

import haxe.ds.Vector;
import ld32.Main;
import ld32.Util;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.Tilesheet;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Lib;

class Gfx extends Sprite
{
	public var useDepthSort : Bool;
	public var scale(get, set) : Float;
	
	var _scale : Float;
	public function get_scale() { return _scale; }
	public function set_scale(x : Float)
	{
		_scale = x;
		bmp.scaleX = _scale;
		bmp.scaleY = _scale;
		return _scale;
	}
	
	var bmp : Bitmap;
	public function new()
	{
		super();
		bmp = new Bitmap(new BitmapData(Std.int(Lib.current.stage.stageWidth / 2), Std.int(Lib.current.stage.stageHeight / 2), false, Colors.BLUE));
		addChild(bmp);
		
		useDepthSort = true;
		scale = 1.0;
	}
	
	public var entities = new Array<Entity>();
	public var custom = new Array<ICustomRenderer>();
	
	var b = false;
	var count = 0;
	public function render()
	{
		if (!b)
		{
			b = true;
			var main = cast(Lib.current.getChildByName("Main"), Main);
			main.stats.addSource(function () { return "Act:  " + count; } );
		}
		
		var bd = bmp.bitmapData;
		bd.lock();
		bd.fillRect(new Rectangle(0, 0, bmp.width, bmp.height), Colors.BLUE);
		
		var vp = Lde.viewport.clone();
		vp.inflate(50, 50);
		
		if (useDepthSort)
		{
			entities.sort(function (l, r) return Std.int(Util.sign(l.z - r.z)));
		}
		
		count = 0;
		for (e in entities)
		{
			if (vp.contains(e.x, e.y))
			{
				e.render(bd);
				++count;
			}
		}
		for (e in custom)
		{
			e.render(bd);
		}
		bd.unlock();
	}
}
