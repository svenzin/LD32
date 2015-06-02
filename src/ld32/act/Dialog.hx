package ld32.act;

import lde.Colors;
import lde.IRender;
import lde.Keys;
import lde.Lde;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.Assets;

class DialogContent extends TextField implements IRender
{
	public var content : BitmapData;
	public var amount : Float;
	function snap(p : Point) { p.x = Math.round(p.x); p.y = Math.round(p.y); }
	public function render(data : BitmapData)
	{
		var d = Util.clamp(amount, 0, 1);
		
		var ul0 = new Point((data.width - content.width) / 2, (data.height - content.height) / 2);
		snap(ul0);
		
		var dul = new Point((1 - d) / 2 * content.width, (1 - d) / 2 * content.height);
		var s = new Point(d * content.width, d * content.height);
		snap(dul);
		snap(s);

		var ul = ul0.add(dul);
		data.fillRect(new Rectangle(ul.x - 3, ul.y - 3, s.x + 6, s.y + 6), Colors.BLACK);
		data.fillRect(new Rectangle(ul.x - 2, ul.y - 2, s.x + 4, s.y + 4), Colors.WHITE);
		data.fillRect(new Rectangle(ul.x - 1, ul.y - 1, s.x + 2, s.y + 2), Colors.BLACK);
		
		data.copyPixels(content, new Rectangle(dul.x, dul.y, s.x, s.y), ul);
	}
}

class Dialog extends lde.act.Action
{
	var content = new DialogContent();
	
	public function new(text : String)
	{
		content.selectable = false;
		content.embedFonts = true;
		content.defaultTextFormat = new TextFormat(Assets.getFont("font/bored6x8.ttf").fontName, 8, Colors.WHITE);
		content.autoSize = TextFieldAutoSize.LEFT;
		content.text = text;
		
		content.amount = 0;
		content.content = new BitmapData(Math.ceil(content.width), Math.ceil(content.height), false, 0xFF000000);
		content.content.draw(content);
	}

	override public function start() 
	{
		Lde.gfx.custom.push(content);
	}
	
	override public function step() 
	{
		if (content.amount >= 1)
		{
			if (Lde.keys.isKeyPushed(Pad.A))
			{
				return false;
			}
		}
		else
		{
			content.amount += Const.DialogSpeed;
		}
		return true;
	}

	override public function stop() 
	{
		Lde.gfx.custom.remove(content);
	}
}