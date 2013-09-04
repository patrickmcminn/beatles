/*
Wednesday, September 4th 2013
Load rewindOhm.scd
prm
*/

{
	s.sync;
	"/rewind/rewindOhm.scd".loadRelative;

	s.sync;
	~neverOhm.rewind.makeOSC;
}.fork;