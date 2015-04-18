package ld32;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import ld32.Main.Meter;
import lde.Chapter;
import lde.Colors;
import lde.Entity;
import lde.ICustomRenderer;
import lde.Lde;
import lde.Stats;
import lde.TiledAnimation;
import openfl.display.Graphics;
import openfl.geom.Point;
import openfl.display.DisplayObject;
import openfl.geom.Rectangle;
import openfl.ui.Keyboard;

/**
 * ...
 * @author scorder
 */
class Pad
{
	public static var UP    = Keyboard.UP;
	public static var DOWN  = Keyboard.DOWN;
	public static var LEFT  = Keyboard.LEFT;
	public static var RIGHT = Keyboard.RIGHT;
	
	public static var A = Keyboard.SPACE;
}
class Orientation
{
	public static var N  = new Point( 0, -1);
	public static var E  = new Point( 1,  0);
	public static var S  = new Point( 0,  1);
	public static var W  = new Point(-1,  0);
	
	public static var NE = new Point( 0.707, -0.707);
	public static var SE = new Point( 0.707,  0.707);
	public static var SW = new Point(-0.707,  0.707);
	public static var NW = new Point(-0.707, -0.707);
	
	public static function random()
	{
		var o = [ N, NE, E, SE, S, SW, S, NW ];
		return o[Std.random(o.length)];
	}
}
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
		
		//graphics.beginFill(Colors.WHITE);
		//rect(graphics, x - w / 2 - 2, y - 3, w + 4, Height);
		graphics.beginFill(Colors.BLACK);
		rect(graphics, x - w / 2 - 1, y - 2, w + 2, Height - 2);
		graphics.beginFill(color);
		rect(graphics, x - w / 2, y - 1, w, Height - 4);
		graphics.endFill();
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
		life.value /= 2;
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
	
	function setGrabber(direction : Point)
	{
		grabber.x = x + center().x - grabber.center().x + Const.Reach * direction.x;
		grabber.y = y + center().y - grabber.center().y + Const.Reach * direction.y;
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
		
		setGrabber(orientation);
		life.x += x - oldx;
		life.y += y - oldy;
		power.x += x - oldx;
		power.y += y - oldy;
		for (e in bagage)
		{
			e.x += x - oldx;
			e.y += y - oldy;
		}
	}

	var anims = new Map<Int, TiledAnimation>();
	public function loadAnim(id : Int)
	{
		var a = Lde.gfx.getAnim(id);
		if (a != null) anims[id] = a;
	}
}
class Player extends Character
{
	public function new()
	{
		super(Const.MaxLife);
		loadAnim(Tiles.P);
		
		animation = anims[Tiles.P];
		
		box = new Rectangle(0, 0, Const.TileSize, Const.TileSize);
	}

	var speed = 1.0;
	override public function ai()
	{
		var dx = 0.0;
		var dy = 0.0;
		
		if (Lde.keys.isKeyDown(Pad.UP)) dy -= speed;
		if (Lde.keys.isKeyDown(Pad.DOWN)) dy += speed;
		if (Lde.keys.isKeyDown(Pad.LEFT)) dx -= speed;
		if (Lde.keys.isKeyDown(Pad.RIGHT)) dx += speed;
		
		if (Lde.keys.isKeyPushed(Pad.A))
		{
			if (bagage.length > 0)
			{
				drop(bagage[0]);
			}
			else
			{
				var grabs = Lde.phx.trigs(this.grabber).filter(function (e) return !e.anchored);
				if (grabs.length > 0)
				{
					grab(grabs[0]);
				}
			}
		}
		
		moveBy(dx, dy);
	}
}
class Grunt extends Character
{
	public function new()
	{
		super(Const.MaxLife);
		loadAnim(Tiles.G);
		
		animation = anims[Tiles.G];
		
		box = new Rectangle(0, 0, Const.TileSize, Const.TileSize);
	}
	
	override public function ai() 
	{
	}
}
class Chapter_Test extends Chapter
{
	var size = [ 20, 15 ];
	var background : Array<Array<Int>>;
	var foreground : Array<Array<Int>>;
	var walls : Array<Entity>;
	
	public function new() { }

	var player : Player;
	var grunts : Array<Character>;
	
	var bg = new Array<Entity>();
	var entities = new Array<Entity>();
	override public function start() 
	{
		Lde.gfx.scale = 2.0;
		Lde.phx.scale = 2.0;
		
		Lde.gfx.tilers = [ new Tiles() ];
		
		walls = [ new Entity(), new Entity(), new Entity(), new Entity() ];
		walls[0].x = -1 * Const.TileSize;
		walls[0].y = 0;
		walls[0].box = new Rectangle(0, 0, Const.TileSize, size[1] * Const.TileSize);
		walls[1].x = size[0] * Const.TileSize;
		walls[1].y = 0;
		walls[1].box = new Rectangle(0, 0, Const.TileSize, size[1] * Const.TileSize);
		walls[2].x = 0;
		walls[2].y = -1 * Const.TileSize;
		walls[2].box = new Rectangle(0, 0, size[0] * Const.TileSize, Const.TileSize);
		walls[3].x = 0;
		walls[3].y = size[1] * Const.TileSize;
		walls[3].box = new Rectangle(0, 0, size[0] * Const.TileSize, Const.TileSize);
		
		foreground = new Array();
		for (y in 0...size[1])
		{
			foreground.push(new Array());
			for (x in 0...size[0])
			{
				foreground[y].push(0);
			}
		}
		foreground[5][ 8] = Tiles.TABLE_H;
		foreground[5][ 9] = Tiles.TABLE_H;
		foreground[5][10] = Tiles.TABLE_H;
		foreground[6][ 8] = Tiles.TABLE_H;
		foreground[6][ 9] = Tiles.TABLE_H;
		foreground[6][10] = Tiles.TABLE_H;
		
		background = new Array();
		for (y in 0...size[1])
		{
			background.push(new Array());
			for (x in 0...size[0])
			{
				if ((((x % 2) + (y % 2)) % 2) == 0)
				{
					background[y].push(Tiles.BG1);
				}
				else
				{
					background[y].push(Tiles.BG2);
				}
			}
		}
		
		for (y in 0...size[1])
		{
			for (x in 0...size[0])
			{
				var tile = new Entity();
				tile.x = Const.TileSize * x;
				tile.y = Const.TileSize * y;
				tile.animation = Lde.gfx.getAnim(background[y][x]);
				bg.push(tile);
			}
		}
		
		for (y in 0...size[1])
		{
			for (x in 0...size[0])
			{
				if (foreground[y][x] > 0)
				{
					var tile = new Entity();
					tile.x = Const.TileSize * x;
					tile.y = Const.TileSize * y;
					tile.animation = Lde.gfx.getAnim(foreground[y][x]);
					tile.box = new Rectangle(0, 0, Const.TileSize, Const.TileSize);
					entities.push(tile);
				}
			}
		}
		
		player = new Player();
		player.moveTo(50, 50);
		
		var b = new Entity();
		b.x = 0;
		b.y = 0;
		b.animation = Lde.gfx.getAnim(Tiles.BEER);
		b.box = new Rectangle(2, 2, Const.TileSize - 4, Const.TileSize - 4);
		b.anchored = false;
		//entities.push(b);
		
		grunts = new Array();
		grunts.push(new Grunt());
		grunts[0].moveTo(160, 64);
		for (g in grunts)
			entities.push(g);
		
		entities.push(player);
		
		Lde.gfx.entities = Lde.gfx.entities.concat(bg).concat(entities).concat([ b ]) ;
		Lde.phx.entities = Lde.phx.entities.concat(walls).concat(entities);
		Lde.phx.triggers = Lde.phx.triggers.concat([ b ]);
	}
	
	override public function step() 
	{
		player.ai();
		for (g in grunts) g.ai();
	}
}
class Main extends Sprite 
{
	var inited:Bool;

	/* ENTRY POINT */
	
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
	}
	
	function switchChild(e : DisplayObject) { return function (_) { if (this.contains(e)) this.removeChild(e); else this.addChild(e); }; }
	
	var stats = new Stats(0, 0, Colors.WHITE);
	function init() 
	{
		if (inited) return;
		inited = true;

		Lde.initialize();
		Lde.viewport = new Rectangle(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		
		Lde.keys.remap("CONSOLE", 223);
		Lde.keys.remap("LAYER_GFX", Keyboard.F1);
		Lde.keys.remap("LAYER_PHX", Keyboard.F2);
		Lde.keys.addEventListener("CONSOLE", switchChild(stats));
		Lde.keys.addEventListener("LAYER_GFX", switchChild(Lde.gfx));
		Lde.keys.addEventListener("LAYER_PHX", switchChild(Lde.phx));
		
		this.addEventListener(Event.ENTER_FRAME, function (_) Lde.step());
		
		this.addChild(Lde.gfx);
		Lde.open(new Chapter_Test());
		// (your code here)
		
		// Stage:
		// stage.stageWidth x stage.stageHeight @ stage.dpiScale
		
		// Assets:
		// nme.Assets.getBitmapData("img/assetname.jpg");
	}

	/* SETUP */

	public function new() 
	{
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}
