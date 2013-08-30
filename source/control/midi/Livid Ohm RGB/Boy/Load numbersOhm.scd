/*
Friday, August 30th 2013
numbersOhm.scd
prm
*/

{
	s.sync;
	"/numbers/numbersOhm.scd".loadRelative;

	s.sync;
	~boyOhm.numbers.makeOSC;
}.fork;