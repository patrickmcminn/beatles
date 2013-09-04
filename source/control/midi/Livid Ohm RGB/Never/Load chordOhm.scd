/*
Wednesday, September 4th 2013
Load chordOhm.scd
prm
*/

{
	s.sync;
	"/chord/chordOhm.scd".loadRelative;

	s.sync;
	~neverOhm.chord.makeOSC;
}.fork;