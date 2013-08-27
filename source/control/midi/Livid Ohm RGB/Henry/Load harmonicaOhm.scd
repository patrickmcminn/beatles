/*
Tuesday, August 17th 2013
Load harmonicaOhm.scd
prm
*/

{
	s.sync;
	"/harmonica/harmonicaOhm.scd".loadRelative;

	s.sync;
	~henryOhm.harmonica.makeOSC;
}.fork;