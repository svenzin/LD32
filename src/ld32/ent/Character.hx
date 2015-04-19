package ld32.ent ;

import lde.*;
import openfl.geom.Point;
import openfl.geom.Rectangle;

class Character extends Entity
{
	override public function get_z() 
	{
		return y;
	}
	
	var orientation : Point;
	var grabber : Entity;
	
	public var life : Meter;
	public var power : Meter;
	
	public function new(max_life : Float)
	{
		super();
		
		life = new Meter(max_life);
		life.value = max_life;
		life.color = Colors.RED;
		life.owner = this;
		Lde.gfx.custom.push(life);
		
		power = new Meter(max_life);
		power.color = Colors.CYAN;
		life.owner = this;
		Lde.gfx.custom.push(power);
		
		grabber = new Entity();
		grabber.box = new Rectangle(0, 0, 8, 8);
		grabber.anchored = true;
		Lde.phx.triggers.push(grabber);
		
		orientation = Orientation.random();
		setGrabber(orientation);
	}
	
	public function kill()
	{
		Lde.phx.triggers.remove(grabber);
	}
	
	public function ai()
	{
	}
	
	var bagage = new Array<Entity>();
	public function grab(e : Entity)
	{
		if (bagage.indexOf(e) == -1)
		{
			orientation = Orientation.closest(e.world_center().x - world_center().x,
			                                  e.world_center().y - world_center().y);
			setGrabber(orientation);
			
			e.x = x + reach(orientation).x - e.center().x;
			e.y = y + reach(orientation).y - e.center().y;
			e.anchored = true;
			bagage.push(e);
		}
	}
	
	public function drop(e : Entity)
	{
		if (bagage.indexOf(e) != -1)
		{
			e.anchored = false;
			bagage.remove(e);
		}
	}
	
	public function passOut()
	{
		
	}
	
	public function drink(b : Beer)
	{
		b.qty -= 1;
		power.value -= 1;
		
		if (power.value == power.max) passOut();
	}
	
	function reach(direction : Point)
	{
		return new Point(center().x + Const.Reach * direction.x,
		                 center().y + Const.Reach * direction.y);
	}
	
	function setGrabber(direction : Point)
	{
		var r = reach(direction);
		grabber.x = x + r.x - grabber.center().x;
		grabber.y = y + r.y - grabber.center().y;
	}
	
	public function moveTo(_x : Float, _y : Float)
	{
		x = _x;
		y = _y;
		
		setGrabber(orientation);
		life.x = x + center().x;
		life.y = y + center().y - Const.TileSize;
		power.x = x + center().x;
		power.y = y + center().y - Const.TileSize + Meter.Height - 3;
	}
	
	public function moveBy(dx : Float, dy : Float)
	{
		var oldx = x;
		var oldy = y;
		var oldo = orientation;
		
		orientation = Orientation.closest(dx, dy);
		if (orientation == Orientation.INVALID) orientation = oldo;
		
		x += dx;
		
		var hits = Lde.phx.hits(this);
		if (hits.length > 0)
		{
			var thisRect = box.clone();
			thisRect.offset(x, y);
			var rects = hits.map(function (e)
			{
				var r = e.box.clone();
				r.offset(e.x, e.y);
				return r;
			});
			x -= Util.sign(dx) * Util.max(rects.map(function (r) return r.intersection(thisRect).width));
		}
		
		y += dy;
		
		var hits = Lde.phx.hits(this);
		if (hits.length > 0)
		{
			var thisRect = box.clone();
			thisRect.offset(x, y);
			var rects = hits.map(function (e)
			{
				var r = e.box.clone();
				r.offset(e.x, e.y);
				return r;
			});
			y -= Util.sign(dy) * Util.max(rects.map(function (r) return r.intersection(thisRect).height));
		}
		
		setGrabber(orientation);
		life.x += x - oldx;
		life.y += y - oldy;
		power.x += x - oldx;
		power.y += y - oldy;
		for (e in bagage)
		{
			e.x += x - oldx + reach(orientation).x - reach(oldo).x;
			e.y += y - oldy + reach(orientation).y - reach(oldo).y;
		}
	}

	var anims = new Map<Int, TiledAnimation>();
	public function loadAnim(id : Int)
	{
		var a = Lde.gfx.getAnim(id);
		if (a != null) anims[id] = a;
	}
}
