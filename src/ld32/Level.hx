package ld32;

import haxe.Constraints.Function;
import ld32.ent.*;
import ld32.act.*;
import ld32.Main.Player;
import ld32.Main.Grunt;
import lde.*;
import lde.act.*;
import openfl.geom.Rectangle;

class Level extends Chapter
{
	public static var LAYER_BG      = 0;
	public static var LAYER_CONTENT = 0;
	public static var LAYER_ZONE    = 1;
	public static var LAYER_STARTUP = 2;
	
	public var map : TiledMap;
	var tiles : Tiles;

	var walls : Array<Entity>;
	var bg : Array<Entity>;
	
	public var bartop = new Array<Rectangle>();
	public var seats = new Array<Rectangle>();
	
	public var player : Player;
	public var grunts : Array<Grunt>;
	public var items : Array<Object>;
	
	public var actions = new Parallel(Act.KeepAlive());
	
	public function new(name : String)
	{
		tiles = new Tiles();
		
		map = new TiledMap(name);
		makeWalls();
	}
	
	override public function start() 
	{
		super.start();
		
		makeBG();
		makeFurniture();
		makeZones();
		makeContent();
	}
	
	override public function step() 
	{
		super.step();
	}
	
	override public function quit() 
	{
		super.quit();
		
		Lde.gfx.entities = [];
		Lde.gfx.custom = [];
		
		Lde.phx.entities = [];
		Lde.phx.triggers = [];
	}
	
	var _locked = false;
	public function lock() { _locked = true; }
	public function unlock() { _locked = false; }
	public function locked() { return _locked; }
	
	public function spawnBeer()
	{
		var r = Util.random(bartop);
		if (Lde.phx.trigsBox(r).length == 0)
		{
			var b = new Beer();
			b.x = r.x;
			b.y = r.y;
			items.push(b);
			
			Lde.gfx.entities.push(b);
			Lde.phx.triggers.push(b);
		}
	}
	
	function makeContent()
	{
		player = new Player();
		grunts = new Array();
		items = new Array();
		
		for (y in 0...map.size[1])
		{
			for (x in 0...map.size[0])
			{
				switch (map.layers[Level.LAYER_STARTUP][y][x])
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
						var b = new Beer();
						b.x = Const.TileSize * x;
						b.y = Const.TileSize * y;
						items.push(b);
						
						Lde.gfx.entities.push(b);
						Lde.phx.triggers.push(b);
					}
				}
			}
		}
	}
	
	function makeZones()
	{
		for (y in 0...map.size[1])
		{
			for (x in 0...map.size[0])
			{
				switch (map.layers[LAYER_ZONE][y][x])
				{
					case 1: seats.push(new Rectangle(x * Const.TileSize, y * Const.TileSize,
					                                 Const.TileSize, Const.TileSize));
					case 2: bartop.push(new Rectangle(x * Const.TileSize, y * Const.TileSize,
					                                  Const.TileSize, Const.TileSize));
					default:
				}
			}
		}
	}
	
	function makeFurniture()
	{
		for (y in 0...map.size[1])
		{
			for (x in 0...map.size[0])
			{
				var tileid = map.layers[Level.LAYER_CONTENT][y][x];
				if (tileid > 0)
				{
					var tile = new Furniture();
					tile.x = Const.TileSize * x;
					tile.y = Const.TileSize * y;
					tile.animation = tiles.getTile(tileid - 1);
					tile.box = new Rectangle(0, 0, Const.TileSize, Const.TileSize);
					walls.push(tile);
					
					Lde.gfx.entities.push(tile);
					Lde.phx.entities.push(tile);
				}
			}
		}
	}
	
	function makeWalls()
	{
		var s = Const.TileSize;
		walls = [ new Entity(), new Entity(), new Entity(), new Entity() ];
		walls[0].x = -s;
		walls[0].y = 0;
		walls[0].box = new Rectangle(0, 0, s, map.size[1] * s);
		walls[1].x = map.size[0] * s;
		walls[1].y = 0;
		walls[1].box = new Rectangle(0, 0, s, map.size[1] * s);
		walls[2].x = 0;
		walls[2].y = -s;
		walls[2].box = new Rectangle(0, 0, map.size[0] * s, s);
		walls[3].x = 0;
		walls[3].y = map.size[1] * s;
		walls[3].box = new Rectangle(0, 0, map.size[0] * s, s);
		
		Lde.phx.entities.push(walls[0]);
		Lde.phx.entities.push(walls[1]);
		Lde.phx.entities.push(walls[2]);
		Lde.phx.entities.push(walls[3]);
	}
	
	function makeBG()
	{
		bg = new Array();
		for (y in 0...map.size[1])
		{
			for (x in 0...map.size[0])
			{
				var tile = new Entity();
				tile.x = Const.TileSize * x;
				tile.y = Const.TileSize * y;
				tile.z = - 1000 + tile.y;
				if ((((x % 2) + (y % 2)) % 2) == 0)
					tile.animation = Tiles.BG1.get();
				else
					tile.animation = Tiles.BG2.get();
				bg.push(tile);
				
				for (i in 1...10)
					Lde.gfx.entities.push(tile);
			}
		}
	}
}
