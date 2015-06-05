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

import lde.gfx.IRender;
import lde.gfx.Animation;
import lde.gfx.AnimationData;

class Layer
{
	public var depthSort = false;
	public var entities = new Array<IRender>();
}

class Gfx extends Sprite
{
	public var layers = new Array<Layer>();
	
	public var scale(get, set) : Float;
	
	var _scale : Float;
	public function get_scale() { return _scale; }
	public function set_scale(x : Float)
	{
		_scale = x;
		//_data.width = Math.ceil(Lib.current.stage.stageWidth / _scale);
		//_data.height = Math.ceil(Lib.current.stage.stageHeight / _scale);
		_bitmap.scaleX = _scale;
		_bitmap.scaleY = _scale;
		return _scale;
	}
	
	var _bitmap : Bitmap;
	var _data : BitmapData;
	public function new()
	{
		super();
		
		_data = new BitmapData(Lib.current.stage.stageWidth, Lib.current.stage.stageHeight, false, Colors.BLUE);
		_bitmap = new Bitmap(_data);
		addChild(_bitmap);
		
		scale = 1.0;
	}
	
	var b = false;
	var count = 0;
	public function render()
	{
		if (!b)
		{
			b = true;
			var main = cast(Lib.current.getChildByName("Main"), Main);
			main.stats.addSource(function () { return "Ent:  " + count; } );
			main.stats.addSource(function () { return "Anim: " + Animation.count + "/" + AnimationData.count; } );
		}
		
		_data.lock();
		_data.fillRect(_data.rect, Colors.BLUE);
		
		var vp = Lde.viewport.clone();
		vp.inflate(50, 50);
			
		count = 0;
		for (layer in layers)
		{
			if (layer.depthSort)
			{
				layer.entities.sort(function (l, r) return Std.int(Util.sign(l.getDepth() - r.getDepth())));
			}
		
			count += layer.entities.length;
			for (e in layer.entities)
			{
				e.render(_data);
			}
		}
		
		_data.unlock();
	}
}
