package ld32.act;

class Once extends Action
{
	override public function step() 
	{
		if (!done()) _f();
		_done = true;
	}
}
