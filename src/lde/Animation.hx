package lde;

import haxe.ds.Vector;
import lde.Animation.AnimationData;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.geom.Point;

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

class Animation
{
	public static var count : Int = 0;
	
	var _data : AnimationData;
	public function renderAt(target : BitmapData, p : Point)
	{
		_data.renderFrameAt(target, currentFrame, p);
	}
	
	public function new(data : AnimationData)
	{
		++count;
		
		_data = data;
		currentFrame = 0;
		stop();
	}

	var isRunning : Bool;
	var startFrame : Int;
	var currentFrame : Int;
	
	public function update()
	{
		if (isRunning)
		{
			currentFrame =  Std.int((Watch.frameCount - startFrame) / slowBy) % _data.length;
		}
	}

	var slowBy : Int;
	public function start(slowed : Int = 1)
	{
		startFrame = Watch.frameCount - currentFrame;
		slowBy = slowed;
		isRunning = true;
	}
	
	public function stop()
	{
		isRunning = false;
	}
	
	public function toggle()
	{
		if (isRunning) stop();
		else start();
	}
}
