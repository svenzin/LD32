package ld32;

import openfl.Assets;

class TiledMap
{
	public var size = [ 0, 0 ];
	
	public var layers = new Array<Array<Array<Int>>>();
	
	function isElement(e : Xml) { return e.nodeType == Xml.Element; }
	public function new(name : String)
	{
		var text = Assets.getText(name);
		var root = Xml.parse(text).firstElement();
		size[0] = Std.parseInt(root.get("width"));
		size[1] = Std.parseInt(root.get("height"));
		
		for (node in root)
		{
			if (isElement(node))
			{
				if (node.nodeName == "layer")
				{
					var layer = new Array<Array<Int>>();
					for (item in node)
					{
						if (isElement(item))
						{
							if (item.nodeName == "data")
							{
								var x = 0;
								var y = 0;
								var line = new Array<Int>();
								for (tile in item)
								{
									if (isElement(tile))
									{
										if (x == size[0])
										{
											x = 0;
											++y;
											layer.push(line);
											line = new Array();
										}
										line.push(Std.parseInt(tile.get("gid")));
										++x;
									}
								}
								if (x == size[0])
								{
									x = 0;
									++y;
									layer.push(line);
									line = new Array();
								}
							}
						}
					}
					layers.push(layer);
				}
			}
		}
	}
}
