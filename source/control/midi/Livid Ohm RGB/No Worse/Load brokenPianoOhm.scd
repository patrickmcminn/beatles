/*
Saturday, August 17th 2013
Load brokenPianoOhm.scd
prm
*/

{
	s.sync;
	"/brokenPiano/brokenPianoOhm.scd".loadRelative;

	s.sync;
	~worseOhm.brokenPiano.makeOSC;
}.fork;