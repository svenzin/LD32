package lde.gfx ;

import openfl.display.BitmapData;

interface IRender
{
	function getDepth() : Float;
	function render(target : BitmapData) : Void;
}
