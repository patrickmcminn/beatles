/*
Tuesday, August 20th 2013
Load taikoOhm.scd
prm
*/

{
	s.sync;
	"/taiko/taikoOhm.scd".loadRelative;

	s.sync;
	~lucyOhm.taiko.makeOSC;
}.fork;