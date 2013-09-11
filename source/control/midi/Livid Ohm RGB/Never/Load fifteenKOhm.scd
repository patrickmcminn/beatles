/*
Wednesday, September 4th 2013
Load fifteenKOhm.scd
prm
*/

{
	s.sync;
	"/fifteenK/fifteenKOhm.scd".loadRelative;

	s.sync;
	~neverOhm.fifteenK.makeOSC;
}.fork;