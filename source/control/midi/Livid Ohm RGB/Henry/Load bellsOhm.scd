/*
Tuesday, August 17th 2013
Load bellsOhm.scd
prm
*/

{
	s.sync;
	"/bells/bellsOhm.scd".loadRelative;

	s.sync;
	~henryOhm.bells.makeOSC;
}.fork;