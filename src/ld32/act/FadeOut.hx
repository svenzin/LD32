package ld32.act;

import ld32.Main.PlainRect;
import lde.*;
import lde.act.*;

class FadeOut extends Action
{
	var s : Float;
	var top = new PlainRect();
	var bottom = new PlainRect();
	
	public function new(?speed : Float)
	{
		top.r.width = Lde.viewport.width / 2;
		top.r.height = Lde.viewport.height / 4;
		top.r.x = 0;
		top.r.y = -Lde.viewport.height / 4;
		top.c = Colors.GREY_25;
		
		bottom.r.width = Lde.viewport.width / 2;
		bottom.r.height = Lde.viewport.height / 4;
		bottom.r.x = 0;
		bottom.r.y = Lde.viewport.height / 2;
		bottom.c = Colors.GREY_25;
		
		if (speed == null) s = Const.FadeSpeed; else s = speed;
		
		Layers.HUD.entities.push(top);
		Layers.HUD.entities.push(bottom);
	}
	
	override public function step()
	{
		var d = (top.r.y > 0);
		if (!d)
		{
			top.r.y += s;
			bottom.r.y -= s;
		}
		return !d;
	}
	
	override public function stop() 
	{
		Layers.HUD.entities.remove(top);
		Layers.HUD.entities.remove(bottom);
	}
}
