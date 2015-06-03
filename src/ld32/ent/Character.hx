package ld32.ent ;

import ld32.Orientation;
import lde.*;
import lde.gfx.*;
import openfl.geom.Point;
import openfl.geom.Rectangle;

class Character extends Entity
{
	override public function getDepth() { return y; }
	
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
		Layers.Foreground.entities.push(life);
		
		power = new Meter(max_life);
		power.color = Colors.CYAN;
		power.owner = this;
		Layers.Foreground.entities.push(power);
		
		grabber = new Entity();
		grabber.box = new Rectangle(0, 0, 8, 8);
		grabber.anchored = true;
		Lde.phx.triggers.push(grabber);

		orient(Orientation.random());
	}
	
	public function kill()
	{
		Lde.phx.triggers.remove(grabber);
	}
	
	public function ai()
	{
	}
	
	var bagage = new Array<Object>();
	public function grab(e : Object)
	{
		if (bagage.indexOf(e) == -1)
		{
			bagage.push(e);
			e.anchored = true;
			e.owner = this;
			
			orient(Orientation.closest(e.world_center().x - world_center().x,
			                           e.world_center().y - world_center().y));
		}
	}
	
	public function drop(e : Object)
	{
		if (bagage.indexOf(e) != -1)
		{
			bagage.remove(e);
			e.anchored = false;
			e.owner = null;
			
			var c = Util.toGrid(e.x, e.y);
			var i = cast(Lde.chapter, Level).map.layers[Level.LAYER_CONTENT][c[1]][c[0]];
			if (i == 0)
			{
				cast(e, Beer).drop();
			}
		}
	}
	
	public function passOut()
	{
	}

	var a = false;
	public function drink(b : Beer)
	{
		power.value -= b.drink();
		if (b.qty <= 0) drop(b);
		if (power.value == 0)
		{
			power.value = 0.01;
			passOut();
		}
		else if (!a)
		{
			a = true;
			Audio.play(Sfx.DRINK);
		}
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
		
		orient(orientation);
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
		
		orient(orientation);
		life.x += x - oldx;
		life.y += y - oldy;
		power.x += x - oldx;
		power.y += y - oldy;
	}
	
	public function orient(o : Point)
	{
		orientation = o;
		
		setGrabber(o);
		var r = reach(o);
		for (e in bagage)
		{
			e.x = x + r.x - e.center().x;
			e.y = y + r.y - e.center().y;
		}
		
		animation = oranims[o];
	}

	var oranims = new Map<Point, Animation>();
	public function loadOrAnim(orientation : Point, anim : Animation)
	{
		oranims[orientation] = anim;
	}
}
