package ld32.act;

import ld32.act.FadeIn.Tween;
import ld32.Main.PlainRect;
import lde.*;
import lde.act.*;
import lde.act.Act.LoopWhile;
import lde.act.Act.Predicate;

class Tween extends Act.DelayN
{
	public var x(default, null) : Float;
	var dx : Float;
	public function new(start : Float, end : Float, n : Int)
	{
		super(n);
		x = start;
		dx = (end - start) / n;
	}
	
	override function step()
	{
		x += dx;
		return super.step();
	}
}
class FadeIn extends Action
{
	var s : Tween;
	var top = new PlainRect();
	var bottom = new PlainRect();
	
	public function new()
	{
		top.r.width = Lde.viewport.width;
		top.r.height = Lde.viewport.height / 2;
		top.r.x = 0;
		top.r.y = 0;
		top.c = Colors.GREY_25;
		
		bottom.r.width = Lde.viewport.width;
		bottom.r.height = Lde.viewport.height / 2;
		bottom.r.x = 0;
		bottom.r.y = Lde.viewport.height / 2;
		bottom.c = Colors.GREY_25;
		
		s = new Tween(0, Lde.viewport.height / 2, Const.FadeSpeed);
	}
	
	override function start() 
	{
		Layers.HUD.entities.push(top);
		Layers.HUD.entities.push(bottom);
	}
	
	override public function step()
	{
		var alive = s.next();
		if (alive)
		{
			top.r.y = - s.x;
			bottom.r.y = Lde.viewport.height / 2 + s.x;
		}
		return alive;
	}

	override public function stop() 
	{
		Layers.HUD.entities.remove(top);
		Layers.HUD.entities.remove(bottom);
	}
}
