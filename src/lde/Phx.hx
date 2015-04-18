package lde;

import openfl.display.Sprite;

class Phx extends Sprite
{
	public static var COLOR_CENTER = Colors.GREEN;
	public static var COLOR_BOX = Colors.RED;
	public static var COLOR_TRIGGER = Colors.YELLOW;

	public var scale = 1.0;
	
	public function new()
	{
		super();
	}
	
	public var entities = new Array<Entity>();
	public var triggers = new Array<Entity>();
	
	public function step()
	{
	}
	
	public function hits(target : Entity) : Array<Entity>
	{
		if (entities.indexOf(target) == -1) return new Array<Entity>();

		var tbox = target.world_box();
		var hitters = entities.filter(function (e)
		{
			var ebox = e.world_box();
			return ebox.intersects(tbox);
		});
		hitters.remove(target);
		
		return hitters;
	}
	
	public function trigs(target : Entity) : Array<Entity>
	{
		if (target.box == null) return new Array<Entity>();

		var tbox = target.world_box();
		var triggerers = triggers.filter(function (e)
		{
			var ebox = e.world_box();
			return ebox.intersects(tbox);
		});
		triggerers.remove(target);
		
		return triggerers;
	}

	function draw(x : Float, y : Float, w : Float, h : Float)
	{
		graphics.drawRect(scale * x, scale * y, scale * w, scale * h);
	}
	public function render()
	{
		var activeE = entities
			.filter(function (e) return (e.box != null))
			.filter(function (e) return (Lde.viewport.left - 50 <= e.x && e.x <= Lde.viewport.right  + 50))
			.filter(function (e) return (Lde.viewport.top  - 50 <= e.y && e.y <= Lde.viewport.bottom + 50));

		var activeT = triggers
			.filter(function (e) return (e.box != null))
			.filter(function (e) return (Lde.viewport.left - 50 <= e.x && e.x <= Lde.viewport.right  + 50))
			.filter(function (e) return (Lde.viewport.top  - 50 <= e.y && e.y <= Lde.viewport.bottom + 50));

		graphics.clear();
		for (e in activeE)
		{
			graphics.beginFill(COLOR_BOX);
			draw(e.x + e.box.left - Lde.viewport.x, e.y + e.box.top - Lde.viewport.y, e.box.width, e.box.height);
			graphics.endFill();
			
			graphics.beginFill(COLOR_CENTER);
			draw(e.x - Lde.viewport.x, e.y - Lde.viewport.y, 1, 1);
			graphics.endFill();
		}
		for (e in activeT)
		{
			graphics.beginFill(COLOR_TRIGGER);
			draw(e.x + e.box.left - Lde.viewport.x, e.y + e.box.top - Lde.viewport.y, e.box.width, e.box.height);
			graphics.endFill();
			
			graphics.beginFill(COLOR_CENTER);
			draw(e.x - Lde.viewport.x, e.y - Lde.viewport.y, 1, 1);
			graphics.endFill();
		}
	}
}
