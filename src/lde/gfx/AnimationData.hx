package lde.gfx;

import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;

class AnimationData
{
	public static var count : Int = 0;
	
	var _source : BitmapData;
	var _frames : Array<Rectangle>;
	var _offsets : Array<Point>;
	
	public function new(source : BitmapData, frames : Array<Rectangle>, offsets : Array<Point>)
	{
		++count;
		
		_source = source;
		_frames = frames;
		_offsets = offsets;
	}
	
	public var length(get, null) : Int;
	public function get_length() { return _frames.length; }
	
	public function renderFrameAt(target : BitmapData, frame : Int, p : Point)
	{
		target.copyPixels(_source, _frames[frame], p.subtract(_offsets[frame]));
	}
	
	public function get()
	{
		return new Animation(this);
	}
}
