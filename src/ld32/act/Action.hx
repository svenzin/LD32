package ld32.act;

import ld32.act.Seq;

class Action
{
	var _f : Void -> Void;
	
	var _done : Bool;
	
	public function new(f : Void -> Void)
	{
		_f = f;
		_done = false;
		stepFunction = step;
	}
	
	var stepFunction : Void -> Void;
	public function stepper()
	{
		if (_done) stepFunction = cleaner;
		if (_cleaned) stepFunction = waiter;
		
		stepFunction();
	}
	
	public function step()
	{}
	
	var _cleaned = false;
	public function cleaner()
	{ _cleaned = true; }
	
	public function waiter()
	{}
	
	public function done()
	{ return _done; }
	
	public function then(a : Action)
	{
		return new Seq(this, a);
	}
}
