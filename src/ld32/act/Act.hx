package ld32.act;

class Predicate
{
	static public function True() { return true; }
	static public function False() { return false; }
}

class Function
{
	static public function Nothing() {}
}

class LoopWhile extends Act
{
	var f : Void -> Void;
	var p : Void -> Bool;
	public function new(fn : Void -> Void, pred : Void -> Bool)
	{
		f = fn;
		p = pred;
	}
	
	override function step()
	{
		f();
		return p();
	}
}

class Delay extends LoopWhile
{
	var n : Int;
	public function new(d : Int) { super(dec, test); n = d; }
	
	function dec() { --n; }
	function test() { return (n >= 0); }
}

class Call extends LoopWhile { public function new(f : Void -> Void) { super(f, Predicate.False); } }
class Loop extends LoopWhile { public function new(f : Void -> Void) { super(f, Predicate.True); } }

class Seq extends Act
{
	var _acts : Array<Act>;
	
	public function new(a : Act) { _acts = [ a ]; }
	public override function then(a : Act) { _acts.push(a); return this; }

	override function step()
	{
		while ((_acts.length > 0) && (!_acts[0].next()))
		{
			_acts.shift();
		}
		return (_acts.length > 0);
	}
}

class Sim extends Act
{
	var _acts : Array<Act>;
	
	public function new(a : Act) { _acts = [ a ]; }
	public override function also(a : Act) { _acts.push(a); return this; }

	override function step()
	{
		_acts = _acts.filter(function (a) return a.next());
		return (_acts.length > 0);
	}
}

class Act
{
	static public function Call(f : Void -> Void) { return new Call(f); }
	static public function Loop(f : Void -> Void) { return new Loop(f); }
	static public function Delay(d : Int) { return new Delay(d); }
	
	public function then(a : Act) { return new Seq(this).then(a); }
	public function also(a : Act) { return new Sim(this).also(a); }
	
	public var done(default, null) = false;
	var started = false;
	
	function start() { }
	function step() { return false; }
	function stop() { }
	
	public function next() : Bool
	{
		if (!started)
		{
			start();
			started = true;
		}
		
		done = !step();
		if (done) stop();
		return !done;
	}
}
