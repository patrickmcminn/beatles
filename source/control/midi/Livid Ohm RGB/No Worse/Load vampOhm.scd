/*
Saturday, August 17th 2013
Load vampOhm.scd
prm
*/

{
	s.sync;
	"/vamp/pianoVampOhm.scd".loadRelative;

	s.sync;
	~worseOhm.pianoVamp.makeOSC;

}.fork;