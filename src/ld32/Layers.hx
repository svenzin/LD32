package ld32;
import lde.Gfx.Layer;

/**
 * ...
 * @author scorder
 */
class Layers
{
	static public var Background = new Layer();
	static public var Foreground = new Layer();
	static public var HUD = new Layer();
	
	static public function init()
	{
		Background.depthSort = false;
		Foreground.depthSort = true;
		HUD.depthSort = false;
	}
	
	static public function clear()
	{
		Background.entities = [];
		Foreground.entities = [];
		HUD.entities = [];
	}
}