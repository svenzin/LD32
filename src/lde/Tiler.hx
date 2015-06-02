package lde;

import lde.Animation.AnimationData;
import openfl.display.BitmapData;
import openfl.display.Tilesheet;
import openfl.geom.Point;
import openfl.geom.Rectangle;

private class Slice
{
	public function new() {}
	public var Tiles : Array<Int>;
	public var Rects : Array<Rectangle>;
}

class Tiler
{
	public var data : BitmapData;
	public var sheet : Tilesheet;
	
	var animations : Map<Int, Array<Int>>;
	var rectangles : Map<Int, Array<Rectangle>>;
	var _datamap = new Map<Int, AnimationData>();

	public function new(tilesheet : BitmapData)
	{
		data = tilesheet;
		sheet = new Tilesheet(tilesheet);
		animations = new Map();
		rectangles = new Map();
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
				tiles.push(sheet.addTileRect(rect));
				rects.push(rect);
			}
		}
		var result = new Slice();
		result.Tiles = tiles;
		result.Rects = rects;
		return result;
	}
	
	public function register(id : Int, indices : Array<Int>, rects : Array<Rectangle>)
	{
		animations[id] = indices;
		rectangles[id] = rects;
		_datamap[id] = new AnimationData(data, rects, [ for (r in rects) new Point() ]);
	}
	
	public function get(id : Int) : Animation
	{
		if (!_datamap.exists(id)) return null;
		
		return _datamap[id].get();
	}
}
