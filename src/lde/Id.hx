package lde;

class Id
{
	static var current : Int = 1;
	static public function get() : Int
	{
		var id = current;
		++current;
		return id;
	}
}
