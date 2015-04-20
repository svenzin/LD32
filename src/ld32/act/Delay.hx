package ld32.act;

class Delay extends Action
{
	var r : Int;
	public function new(d : Int)
	{
		super(null);
		r = d;
	}
	override public function step() 
	{
		_done = (r == 0);
		if (!_done) --r;
	}
}
