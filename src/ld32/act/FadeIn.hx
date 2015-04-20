package ld32.act;

import ld32.Main.PlainRect;
import lde.*;

class FadeIn extends Action
{
	var s : Float;
	var top = new PlainRect();
	var bottom = new PlainRect();
	
	public function new(?speed : Float)
	{
		super(null);
		
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
		
		if (speed == null) s = Const.FadeSpeed; else s = speed;
		
		Lde.gfx.custom.push(top);
		Lde.gfx.custom.push(bottom);
	}
	
	override public function step()
	{
		_done = (bottom.r.y > Lde.viewport.height);
		if (!done())
		{
			top.r.y -= s;
			bottom.r.y += s;
		}
	}

	override public function cleaner() 
	{
		super.cleaner();
		Lde.gfx.custom.remove(top);
		Lde.gfx.custom.remove(bottom);
	}
}
