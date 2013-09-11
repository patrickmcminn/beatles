/*
Wednesday, September 4th 2013
Load mainLoopOhm.scd
prm
*/

{
	s.sync;
	"/mainLoop/mainLoopOhm.scd".loadRelative;

	s.sync;
	~neverOhm.mainLoop.makeOSC;
}.fork;