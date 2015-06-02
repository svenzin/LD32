package lde;

import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;

import lde.gfx.Animation;
import lde.gfx.AnimationData;

class Tiler
{
	public var data : BitmapData;
	var _datamap = new Map<Int, AnimationData>();

	public function new(tilesheet : BitmapData)
	{
		data = tilesheet;
	}
	
	public function slice(origin : Array<Int>, size : Array<Int>, count : Array<Int>)
	{
		var tiles = new Array<Int>();
		var rects = new Array<Rectangle>();
		for (y in 0...count[1])
		{
			for (x in 0...count[0])
			{
				var rect = new Rectangle(origin[0] + x * size[0], origin[1] + y * size[1], size[0], size[1]);
				rects.push(rect);
			}
		}
		return rects;
	}
	
	public function register(id : Int, rects : Array<Rectangle>)
	{
		_datamap[id] = new AnimationData(data, rects, [ for (r in rects) new Point() ]);
	}
	
	public function get(id : Int) : Animation
	{
		if (!_datamap.exists(id)) return null;
		
		return _datamap[id].get();
	}
}
