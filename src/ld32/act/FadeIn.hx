package ld32.act;

import ld32.act.FadeIn.Tween;
import ld32.Main.PlainRect;
import lde.*;
import lde.act.*;

class Tween extends Action
{
	public var x(default, null) : Float;
	var x0 : Float;
	var x1 : Float;
	var dx : Float;
	public function new(start : Float, end : Float, step : Float)
	{
		x0 = start;
		x1 = end;
		dx = step;
	}
	
	override function start()
	{
		x = x0;
	}
	override function step()
	{
		x += dx;
		return x <= x1;
	}
}
class FadeIn extends Action
{
	var s : Tween;
	var top = new PlainRect();
	var bottom = new PlainRect();
	
	public function new(?speed : Float)
	{
		top.r.width = Lde.viewport.width / 2;
		top.r.height = Lde.viewport.height / 4;
		top.r.x = 0;
		top.r.y = 0;
		top.c = Colors.GREY_25;
		
		bottom.r.width = Lde.viewport.width / 2;
		bottom.r.height = Lde.viewport.height / 4;
		bottom.r.x = 0;
		bottom.r.y = Lde.viewport.height / 4;
		bottom.c = Colors.GREY_25;
		
		if (speed == null) s = new Tween(0, Lde.viewport.height / 4, Const.FadeSpeed);
		else s = new Tween(0, Lde.viewport.height / 4, speed);
	}
	
	override function start() 
	{
		Lde.gfx.custom.push(top);
		Lde.gfx.custom.push(bottom);
	}
	
	override public function step()
	{
		var alive = s.next();
		if (alive)
		{
			top.r.y = - s.x;
			bottom.r.y = Lde.viewport.height / 4 + s.x;
		}
		return alive;
	}

	override public function stop() 
	{
		Lde.gfx.custom.remove(top);
		Lde.gfx.custom.remove(bottom);
	}
}
