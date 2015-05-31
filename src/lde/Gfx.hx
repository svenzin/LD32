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
	
	public var tilers = new Array<Tiler>();
	
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
	
	public function getAnim(id : Int)
	{
		for (tiler in tilers)
		{
			var anim = tiler.get(id);
			if (anim != null) return anim;
		}
		return null;
	}
	
	public var entities = new Array<Entity>();
	public var custom = new Array<ICustomRenderer>();
	
	var datamap = new Map<Tiler, Array<Float>>();
	public function render()
	{
		render_cp();
	}
	public function render_ts()
	{
		var active = entities
			.filter(function (e) return (e.animation != null))
			.filter(function (e) return (Lde.viewport.left - 50 <= e.x && e.x <= Lde.viewport.right  + 50))
			.filter(function (e) return (Lde.viewport.top  - 50 <= e.y && e.y <= Lde.viewport.bottom + 50));
		active.sort(function (l, r) return Std.int(Util.sign(l.z - r.z)));
		
		datamap = new Map();
		for (tiler in tilers)
		{
			datamap[tiler] = [];
		}
		
		for (tiler in datamap.keys())
		{
			var items = active.filter(function (e) { return e.animation.tiler == tiler; } );
			var vec = new Vector<Float>(4 * items.length);
			var i = 0;
			for (e in items)
			{
				e.animation.update();
				vec[i++] = scale * (e.x - Lde.viewport.x);
				vec[i++] = scale * (e.y - Lde.viewport.y);
				vec[i++] = e.animation.get();
				vec[i++] = scale;
			}
			datamap[tiler] = vec.toArray();
		}
		
		graphics.clear();
		for (tiler in datamap.keys())
		{
			tiler.sheet.drawTiles(this.graphics, datamap[tiler], false, Tilesheet.TILE_SCALE);
		}
		for (e in custom)
		{
			e.render(this.graphics);
		}
	}
	var b = false;
	var count = 0;
	public function render_cp()
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
		
		var a : TiledAnimation;
		var p = new Point();
		
		var vp = Lde.viewport.clone();
		vp.inflate(50, 50);
		
		if (useDepthSort) entities.sort(function (l, r) return Std.int(Util.sign(l.z - r.z)));
		
		count = 0;
		for (e in entities)
		{
			if (vp.contains(e.x, e.y))
			{
				a = e.animation;
				a.update();
				++count;
				p.setTo(e.x, e.y);
				bd.copyPixels(a.tiler.data, a.get_rect(), p, null, null, false);
			}
		}
		for (e in custom)
		{
			e.render_cp(this.bmp.bitmapData);
		}
		bd.unlock();
	}
}

