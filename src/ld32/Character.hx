package ld32;

import lde.Lde;
import lde.Colors;
import lde.Entity;
import lde.ICustomRenderer;
import lde.TiledAnimation;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.display.Graphics;

class Meter extends Entity implements ICustomRenderer
{
	public static var Height = 6;
	
	public var max : Float;
	public var value : Float;
	
	public var color = Colors.RED;
	
	public function new(_max : Float)
	{
		super();
		
		max = _max;
		value = max;
	}
	
	function rect(g : Graphics, x : Float, y : Float, w : Float, h : Float)
	{
		var s = Lde.gfx.scale;
		g.drawRect(s * x, s * y, s * w, s * h);
	}
	public function render(graphics : Graphics)
	{
		var s = Lde.gfx.scale;
		var w = Const.TileSize * value / max;
		
		if (w < 1.0)
		{
		//graphics.beginFill(Colors.WHITE);
		//rect(graphics, x - w / 2 - 2, y - 3, w + 4, Height);
		graphics.beginFill(Colors.BLACK);
		rect(graphics, x - w / 2 - 1, y - 2, w + 2, Height - 2);
		graphics.beginFill(color);
		rect(graphics, x - w / 2, y - 1, w, Height - 4);
		graphics.endFill();
		}
	}
}

class Character extends Entity
{
	var orientation : Point;
	var grabber : Entity;
	
	var life : Meter;
	var power : Meter;
	
	public function new(max_life : Float)
	{
		super();
		
		life = new Meter(max_life);
		life.color = Colors.RED;
		Lde.gfx.custom.push(life);
		
		power = new Meter(max_life);
		power.color = Colors.CYAN;
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
		z = -y;
		
		setGrabber(orientation);
		life.x = x + center().x;
		life.y = y + center().y - Const.TileSize;
		life.z = life.y;
		power.x = x + center().x;
		power.y = y + center().y - Const.TileSize + Meter.Height - 3;
		power.z = power.y;
	}
	
	public function moveBy(dx : Float, dy : Float)
	{
		var oldx = x;
		var oldy = y;
		var oldo = orientation;
		
		if      (dx > 0) if      (dy > 0) orientation = Orientation.SE;
		                 else if (dy < 0) orientation = Orientation.NE;
					     else             orientation = Orientation.E;
		else if (dx < 0) if      (dy > 0) orientation = Orientation.SW;
		                 else if (dy < 0) orientation = Orientation.NW;
					     else             orientation = Orientation.W;
		else             if      (dy > 0) orientation = Orientation.S;
		                 else if (dy < 0) orientation = Orientation.N;
		
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
		
		z = y;
		
		setGrabber(orientation);
		life.x += x - oldx;
		life.y += y - oldy;
		life.z = life.y;
		power.x += x - oldx;
		power.y += y - oldy;
		power.z = power.y;
		for (e in bagage)
		{
			e.x += x - oldx + reach(orientation).x - reach(oldo).x;
			e.y += y - oldy + reach(orientation).y - reach(oldo).y;
			e.z = e.y;
		}
	}

	var anims = new Map<Int, TiledAnimation>();
	public function loadAnim(id : Int)
	{
		var a = Lde.gfx.getAnim(id);
		if (a != null) anims[id] = a;
	}
}
