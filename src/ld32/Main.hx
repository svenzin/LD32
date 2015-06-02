package ld32;

import ld32.ent.*;
import ld32.act.*;
import openfl.display.BitmapData;

import lde.*;
import lde.act.*;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
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
		
		loadOrAnim(Orientation.N , Tiles.P_N ());
		loadOrAnim(Orientation.NW, Tiles.P_NW());
		loadOrAnim(Orientation.W , Tiles.P_W ());
		loadOrAnim(Orientation.SW, Tiles.P_SW());
		loadOrAnim(Orientation.S , Tiles.P_S ());
		loadOrAnim(Orientation.SE, Tiles.P_SE());
		loadOrAnim(Orientation.E , Tiles.P_E ());
		loadOrAnim(Orientation.NE, Tiles.P_NE());
		
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
				var grabs = Lde.phx.trigs(this.grabber).filter(F.notAnchored()).map(F.obj());
				if (grabs.length > 0)
				{
					grab(grabs[0]);
				}
			}
		}
		
		moveBy(dx, dy);
	}
	
	var i = 0;
	var cooldown : Int;
	override public function moveBy(dx:Float, dy:Float) 
	{
		super.moveBy(dx, dy);
		if (cooldown > 0) --cooldown;
		else if (dx != 0 || dy != 0)
		{
			var s = [ Sfx.STEP1, Sfx.STEP2 ];
			i = (i + 1) % s.length;
			Audio.play(s[i]);
			cooldown = 14;
		}
	}
}
class Grunt extends Character
{
	public function new()
	{
		super(Const.MaxLife);
		
		loadOrAnim(Orientation.N , Tiles.G_N ());
		loadOrAnim(Orientation.NW, Tiles.G_NW());
		loadOrAnim(Orientation.W , Tiles.G_W ());
		loadOrAnim(Orientation.SW, Tiles.G_SW());
		loadOrAnim(Orientation.S , Tiles.G_S ());
		loadOrAnim(Orientation.SE, Tiles.G_SE());
		loadOrAnim(Orientation.E , Tiles.G_E ());
		loadOrAnim(Orientation.NE, Tiles.G_NE());
		
		box = new Rectangle(0, 0, Const.TileSize, Const.TileSize);
	}
	
	var action = ActionType.IDLE;
	override public function ai() 
	{
		switch (action)
		{
			case IDLE:
			{
				var c = world_center();
				var r = new Rectangle(c.x - Const.Range / 2, c.y - Const.Range / 2,
									  Const.Range, Const.Range);
				
				var beers = Lde.phx.trigsBox(r)
					.filter(F.isA(EntityType.BEER))
					.filter(F.notAnchored())
					.map(F.obj());
				if (beers.length > 0)
				{
					beers.sort(function (l, r) { return Util.sign(Util.dist2(this, l) - Util.dist2(this, r)); } );
					grab(beers[0]);
					action = ActionType.DRINK;
				}
			}
			case DRINK:
			{
				doDrink();
			}
			default: {}
		}
	}
	
	override public function passOut() 
	{
		var acts = cast(Lde.chapter, Level).actions;
		acts.also(
			Act.Call(function () Audio.play(Sfx.DRUNK))
			.then(Act.Call(function () action = ActionType.LOCKED))
			.then(Act.DelayN(80))
			.then(Act.Call(function () Audio.play(Sfx.FALL)))
			.then(Act.Call(function () animation = Tiles.G_OUT()))
			.then(Act.Call(function () power.value = 0))
			);
	}
	
	public function doDrink()
	{
		var beers = bagage.filter(F.isA(EntityType.BEER)).map(function (e) return cast(e, Beer));
		if (beers.length > 0)
		{
			var b = beers[0];
			drink(b);
			if (b.qty == 0)
			{
				drop(b);
				action = IDLE;
			}
		}
	}

}

class Level01 extends Level
{
	public function new() { super("data/map_01.tmx"); }

	var spawner : Void -> Action;
	override public function start() 
	{
		super.start();
		
		spawner = function ()
		{
			return Act.DelayN(60)
				.then(Act.Call(function ()
				{
					spawnBeer();
					actions.also(spawner());
				}));
		};
		actions.also(
			Act.Call(lock)
			.then(new FadeIn())
			.then(Act.Call(unlock))
			.then(spawner())
			);
		actions.also(Act.Loop(ai));
	}

	function ai()
	{
		if (!locked())
		{
			player.ai();
			for (g in grunts) g.ai();
		}
	}

	override public function step() 
	{
		super.step();
		
		var outs = grunts.filter(F.isOut());
		if (outs.length == grunts.length)
		{
			actions.also(Act.Call(lock).then(new FadeOut()).then(Act.Call(function ()
			{
				Lde.open(new Level01());
			})));
		}

		actions.next();
	}
}

class PlainRect implements IRender
{
	public var r = new Rectangle();
	public var c = Colors.BLACK;
	public function new() {}
	public function render(data : BitmapData)
	{
		data.fillRect(new Rectangle(r.x, r.y, r.width, r.height), c);
	}
}




class Level00 extends Level
{
	public function new() { super("data/map_00.tmx"); }
	
	var spawner : Void -> Action;
	override public function start() 
	{
		super.start();
		
		spawner = function ()
		{
			return Act.DelayN(30 + Std.random(90))
				.then(Act.Call(function ()
				{
					spawnBeer();
					actions.also(spawner());
				}));
		};
		actions.also(
			Act.Call(lock)
			.then(new FadeIn())
			.then(Act.DelayN(10))
			.then(new Dialog("Welcome to Grok's Helm!                  \n" +
			                 "The finest elf roast around these parts! \n" +
							 "                                         \n" +
							 "                  (SPACE to continue)... "))
			.then(new Dialog("Keep the beers coming,             \n" +
			                 "and these orcs won't get to rowdy. \n" +
							 "                                   \n" +
							 "                               ... "))
			.then(new Dialog("Just grab the beers with SPACE \n" +
							 "                               \n" +
							 "And drop'em the same way.      \n" +
							 "                               \n" +
							 "Don't break your keyboard!     \n" +
							 "                               \n" +
			                 "                           ... "))
			.then(Act.Call(unlock))
			.then(spawner())
			);
		actions.also(Act.Loop(ai));
	}
	
	function ai()
	{
		if (!locked())
		{
			player.ai();
			for (g in grunts) g.ai();
		}
	}
	
	override public function step()
	{
		super.step();
		
		var outs = grunts.filter(F.isOut());
		if (outs.length == grunts.length && !locked())
		{
			actions.also(Act.Call(lock).then(new FadeOut()).then(Act.Call(function ()
			{
				Lde.open(new Level01());
			})));
		}
		
		actions.next();
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
	
	public var stats = new Stats(0, 0, Colors.WHITE);
	function init() 
	{
		if (inited) return;
		inited = true;

		Lde.initialize();
		Lde.viewport = new Rectangle(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		
		Lde.gfx.scale = 2.0;
		Lde.phx.scale = 2.0;

		Lde.keys.remap("CONSOLE", 223);
		Lde.keys.remap("LAYER_GFX", Keyboard.F1);
		Lde.keys.remap("LAYER_PHX", Keyboard.F2);
		Lde.keys.addEventListener("CONSOLE", switchChild(stats));
		Lde.keys.addEventListener("LAYER_GFX", switchChild(Lde.gfx));
		Lde.keys.addEventListener("LAYER_PHX", switchChild(Lde.phx));
		
		this.addEventListener(Event.ENTER_FRAME, function (_) Lde.step());
		
		this.addChild(Lde.gfx);
		Lde.open(new Level00());
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
		this.name = "Main";
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
