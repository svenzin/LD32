package lde;

import openfl.display.BitmapData;
import openfl.display.Graphics;

interface ICustomRenderer
{
	function render(graphics : Graphics) : Void;
	function render_cp(data : BitmapData) : Void;
}
