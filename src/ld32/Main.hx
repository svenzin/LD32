package ld32;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import lde.Chapter;
import lde.Colors;
import lde.Entity;
import lde.ICustomRenderer;
import lde.Lde;
import lde.Stats;
import lde.TiledAnimation;
import lde.Tiler;
import openfl.Assets;
import openfl.display.Graphics;
import openfl.geom.Point;
import openfl.display.DisplayObject;
import openfl.geom.Rectangle;
import openfl.ui.Keyboard;

/**
 * ...
 * @author scorder
 */

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
	static var LAYER_BG      = 0;
	static var LAYER_CONTENT = 0;
	static var LAYER_ZONE    = 1;
	static var LAYER_STARTUP = 2;
	
	var map : TiledMap;
	var mapTiles : Tiles;
	var size = [ 20, 15 ];
	var background : Array<Array<Int>>;
	var walls : Array<Entity>;
	
	public function new() { }

	var player : Player;
	var grunts : Array<Character>;
	var seats = new Array<Point>();
	
	var bg = new Array<Entity>();
	var entities = new Array<Entity>();
	override public function start() 
	{
		map = new TiledMap("data/map_01.tmx");
		for (y in 0...map.size[1])
			for (x in 0...map.size[0])
				if (map.layers[LAYER_ZONE][y][x] == 1) seats.push(new Point(x, y));
		
		Lde.gfx.scale = 2.0;
		Lde.phx.scale = 2.0;
		
		mapTiles = new Tiles();
		Lde.gfx.tilers = [ mapTiles ];
		
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
				tile.z = - 1000 + tile.y;
				tile.animation = Lde.gfx.getAnim(background[y][x]);
				bg.push(tile);
			}
		}
		
		for (y in 0...size[1])
		{
			for (x in 0...size[0])
			{
				var tileid = map.layers[LAYER_CONTENT][y][x];
				if (tileid > 0)
				{
					var tile = new Entity();
					tile.x = Const.TileSize * x;
					tile.y = Const.TileSize * y;
					tile.z = tile.y;
					tile.animation = mapTiles.getTile(tileid - 1);
					tile.box = new Rectangle(0, 0, Const.TileSize, Const.TileSize);
					entities.push(tile);
				}
			}
		}
		
		player = new Player();
		grunts = new Array();
	
		for (y in 0...map.size[1])
			for (x in 0...map.size[0])
				switch (map.layers[LAYER_STARTUP][y][x])
				{
					case Tiles.TILE_PLAYER:
					{
						player.moveTo(Const.TileSize * x, Const.TileSize * y);
						Lde.gfx.entities.push(player);
						Lde.phx.entities.push(player);
					}
					case Tiles.TILE_GRUNT:
					{
						var g = new Grunt();
						g.moveTo(Const.TileSize * x, Const.TileSize * y);
						grunts.push(g);
						Lde.gfx.entities.push(g);
						Lde.phx.entities.push(g);
					}
					case Tiles.TILE_BEER:
					{
						var b = new Entity();
						b.x = Const.TileSize * x;
						b.y = Const.TileSize * y;
						b.animation = Lde.gfx.getAnim(Tiles.BEER);
						b.box = new Rectangle(2, 2, Const.TileSize - 4, Const.TileSize - 4);
						b.anchored = false;
						Lde.gfx.entities.push(b);
						Lde.phx.triggers.push(b);
					}
				}
		
		Lde.gfx.entities = Lde.gfx.entities.concat(bg).concat(entities);
		Lde.phx.entities = Lde.phx.entities.concat(walls).concat(entities);
		//Lde.phx.triggers = Lde.phx.triggers.concat([ b ]);
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
