/*
Wednesday, September 4th 2013
Load tptAccompOhm.scd
prm
*/

{
	s.sync;
	"/tptAccomp/tptAccompOhm.scd".loadRelative;

	s.sync;
	~neverOhm.tptAccomp.makeOSC;
}.fork;