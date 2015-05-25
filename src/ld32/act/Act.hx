package ld32.act;

class ActOnce extends Act
{
	var _f : Void -> Void;
	public function new(f : Void -> Void) { _f = f; }
	
	public function init() { }
	public function step() { _f(); return true; }
	public function clean() { return true; }
}

class ActSeq extends Act
{
	var _actions : Array<Act>;
	var _finished : Array<Act>;
	public function new(a : Act)
	{
		_actions = { a };
		_finished = { };
	}
	public function then(a : Act) : Act
	{
		_actions.push(a);
		return this;
	}
	
	public function init() { }
	public function step()
	{
		while (_actions.length > 0)
		{
			if (_actions[0].isDone)
			{
				_finished.push(_actions.shift());
			}
		}
			else
			{
				a.step();
			}
		}
		return (_actions.length > 0);
	}
	public function clean()
	{
		while (_finished.length > 0)
		{
			var a = _actions[0];
			if (a.isClean)
			{
				_finished.shift();
			}
			else
			{
				_finished.step();
			}
		}
		return (_finished.length > 0);
	}
}

class Act
{
	public function init() : Void;
	public function one() : Bool;
	public function clean() : Bool;
	
	public static function Once(f : Void -> Void) : Act
	{
		return new ActOnce(f);
	}
	public function then(a : Act)
	{
		return new ActSeq(this).then(a);
	}

	public var step(default, null) = _init;
	private function _init()
	{
		step = _step;
		
		init();
		step();
	}
	
	private function _step()
	{
		if (one())
		{
			step = _clean;
			isDone = true;
		}
	}
	
	private function _clean()
	{
		if (clean())
		{
			step = _wait;
			isClean = true;
		}
	}
	
	private function _wait() { }
	
	public var isDone(default, null) = false;
	public var isClean(default, null) = false;
}