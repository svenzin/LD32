package ld32.act;

import lde.Colors;
import lde.ICustomRenderer;
import lde.Keys;
import lde.Lde;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.Assets;

class DialogContent extends TextField implements ICustomRenderer
{
	public var data : BitmapData;
	public var amount : Float;
	public function render(graphics : Graphics)
	{
		var d = Util.clamp(amount, 0, 1);
		var tl0 = new Point(Lde.viewport.width / 2 - data.width / 2,
		                   Lde.viewport.height / 2 - data.height / 2);
		var tl = new Point(Lde.viewport.width / 2 - d * data.width / 2,
		                   Lde.viewport.height / 2 - d * data.height / 2);
		
		graphics.beginFill(Colors.BLACK);
		graphics.drawRect(tl.x - 6, tl.y - 6, d * data.width + 12, d * data.height + 12);
		graphics.endFill();
		graphics.beginFill(Colors.WHITE);
		graphics.drawRect(tl.x - 4, tl.y - 4, d * data.width + 8, d * data.height + 8);
		graphics.endFill();
		graphics.beginFill(Colors.BLACK);
		graphics.drawRect(tl.x - 2, tl.y - 2, d * data.width + 4, d * data.height + 4);
		graphics.endFill();
		
		var m = new Matrix();
		m.translate(tl0.x, tl0.y);
		graphics.beginBitmapFill(data, m);
		graphics.drawRect(tl.x, tl.y, d * data.width, d * data.height);
		graphics.endFill();
	}
}

class Dialog extends Action
{
	var content = new DialogContent();
	
	public function new(text : String)
	{
		super(null);
		
		content.selectable = false;
		content.embedFonts = true;
		content.defaultTextFormat = new TextFormat(Assets.getFont("font/bored6x8.ttf").fontName, 16, Colors.WHITE);
		content.autoSize = TextFieldAutoSize.LEFT;
		content.text = text;
		
		content.amount = 0;
		content.data = new BitmapData(Math.ceil(content.width), Math.ceil(content.height), false, 0xFF000000);
		content.data.draw(content);
		
		Lde.gfx.custom.push(content);
	}

	
	override public function step() 
	{
		if (content.amount >= 1)
		{
			if (Lde.keys.isKeyPushed(Pad.A))
			{
				_done = true;
				cleaner();
			}
		}
		else
		{
			content.amount += Const.DialogSpeed;
		}
	}

	override public function cleaner() 
	{
		super.cleaner();
		Lde.gfx.custom.remove(content);
	}
}