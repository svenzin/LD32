package lde ;

import haxe.Timer;
import openfl.Assets;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.events.Event;
import openfl.system.System;

class Stats extends TextField
{
	var _times = new Array<Float>();
	var _mem = 0.0;
	var _peak = 0.0;
	
	public function new(X : Float, Y : Float, color : Int) 
	{
		super();
		
		x = X;
		y = Y;
		selectable = false;
		
		embedFonts = true;
		defaultTextFormat = new TextFormat(Assets.getFont("font/bored6x8.ttf").fontName, 16, color);
		
		addEventListener(Event.ENTER_FRAME, onEnter);
		width = 256;
		height = 128;
		
		addSource(fps);
		addSource(mem);
		addSource(peak);
	}

	private function onEnter(_)
	{	
		var now = Timer.stamp();
		_times.push(now);
		
		while (_times[0] <= now - 1)
			_times.shift();
			
		_mem = Math.round(System.totalMemory / 1024 / 1024 * 100) / 100;
		if (_mem > _peak) _peak = _mem;
		
		if (visible)
		{
			text = "";
			for (s in sources) text = text + s() + "\n";
		}
	}
	
	function fps()  { return "Fps:  " + _times.length; }
	function mem()  { return "Mem:  " + _mem + " MB"; }
	function peak() { return "Peak: " + _peak + " MB"; }
	
	var sources = new List<Void -> String>();
	public function addSource(src : Void -> String)
	{
		sources.add(src);
	}
	public function removeSource(src : Void -> String)
	{
		sources.remove(src);
	}
}