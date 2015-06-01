package lde;

import openfl.geom.Rectangle;

class Lde
{
	public static var viewport : Rectangle;
	
	public static var keys(get, null) : Keys;
	public static var gfx(get, null) : Gfx;
	public static var phx(get, null) : Phx;
	
	public static var chapter(get, null) : Chapter;
	
	public static function initialize()
	{
		_keys = new Keys();
		_gfx = new Gfx();
		_phx = new Phx();
		Watch.init();
	}
	
	static var _keys : Keys;
	static function get_keys() { return _keys; }

	static var _gfx : Gfx;
	static function get_gfx() { return _gfx; }

	static var _phx : Phx;
	static function get_phx() { return _phx; }
	
	static var _nextChapter : Chapter = null;
	static var _chapter : Chapter;
	static function get_chapter() { return _chapter; }
	
	public static function open(chapter : Chapter)
	{
		//_nextChapter = chapter;
		if (_chapter != null) _chapter.quit();
		_chapter = chapter;
		_chapter.start();
		_chapter.step();
	}
	
	public static function step()
	{
		if (_nextChapter != null)
		{
			if (_chapter != null) _chapter.quit();
			_chapter = _nextChapter;
			_nextChapter = null;
			_chapter.start();
		}
		
		// A.I.
		chapter.step();
		
		// Physics
		phx.step();
		
		// Graphics
		phx.render();
		gfx.render();
	}
}
