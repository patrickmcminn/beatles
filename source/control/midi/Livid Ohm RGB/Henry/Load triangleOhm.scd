/*
Tuesday, August 17th 2013
Load bellsOhm.scd
prm
*/

{
	s.sync;
	"/triangle/triangleOhm.scd".loadRelative;

	s.sync;
	~henryOhm.triangle.makeOSC;
}.fork;