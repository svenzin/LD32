package lde;

import haxe.ds.Vector;
import ld32.Util;
import openfl.display.Sprite;
import openfl.display.Tilesheet;

class Gfx extends Sprite
{
	public var scale = 1.0;
	public var tilers = new Array<Tiler>();
	
	public function new()
	{
		super();
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
}
