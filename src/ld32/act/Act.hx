package ld32.act;

class Delay extends Act
{
	var n : Int;
	public function new(d : Int) { n = d; }
	
	function start() { }
	function step()
	{
		--n;
		return (n >= 0);
	}
	function stop() { }	
}

class Empty extends Act
{
	function start() {}
	function step() { return true; }
	function stop() {}
}

class Once extends Act
{
	var f : Void -> Void;
	public function new(fn : Void -> Void) { f = fn; }
	
	var called = false;
	function start() {}
	function step()
	{
		if (!called)
		{
			f();
			called = true;
			return false;
		}
		return true;
	}
	function stop() {}
}

class Loop extends Act
{
	var f : Void -> Void;
	public function new(fn : Void -> Void) { f = fn; }
	
	function start() {}
	function step()
	{
		f();
		return false;
	}
	function stop() {}
}

class Seq extends Act
{
	var _acts : Array<Act>;
	
	public function new(a : Act) { _acts = { a }; }
	public override function then(a : Act) { _acts.push(a); return this; }

	function start() {}
	function step()
	{
		while ((_acts.length > 0) && (!_acts[0].next()))
		{
			_acts.shift();
		}
		return (_acts.length > 0);
	}
	function stop() {}
}

class Sim extends Act
{
	var _acts : Array<Act>;
	
	public function new(a : Act) { _acts = { a }; }
	public override function also(a : Act) { _acts.push(a); return this; }

	function start() {}
	function step()
	{
		_acts = _acts.filter(function (a) a.next());
		return (_acts.length > 0);
	}
	function stop() {}
}

class Act
{
	public function then(a : Act) { return new Seq(this).then(a); }
	public function also(a : Act) { return new Sim(this).also(a); }
	
	public var done(default, null) = false;
	var started = false;
	
	function start() : Void;
	function step() : Bool;
	function stop() : Void;
	
	public function next() : Bool
	{
		if (!started)
		{
			start();
			started = true;
		}
		
		done = step();
		if (done) stop();
		return !done;
	}
}
