package ld32.act;

class Seq extends Action
{
	var current : Action;
	var next : Action;
	
	public function new(a : Action, b : Action)
	{
		super(null);
		current = a;
		next = b;
	}
	
	override public function step() 
	{
		if (!current.done())
		{
			current.step();
		}
		else if (!next.done())
		{
			next.step();
		}
	}
	
	override public function done() : Bool 
	{
		return current.done() && next.done();
	}
}
