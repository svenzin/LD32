package lde.gfx;

import openfl.display.BitmapData;
import openfl.geom.Point;

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
