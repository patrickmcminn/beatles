/*
Friday, August 30th 2013
Load noiseBedOhm.scd
prm
*/

{
	s.sync;
	"/noiseBed/noiseBedOhm.scd".loadRelative;

	s.sync;
	~boyOhm.noiseBed.makeOSC;
}.fork;