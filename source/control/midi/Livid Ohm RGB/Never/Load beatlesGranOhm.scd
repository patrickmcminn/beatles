/*
Wednesday, September 4th 2013
Load beatlesGranOhm.scd
prm
*/

{
	s.sync;
	"/beatlesGran/beatlesGranOhm.scd".loadRelative;

	s.sync;
	~neverOhm.beatlesGran.makeOSC;
}.fork;