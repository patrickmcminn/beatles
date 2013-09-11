/*
Tuesday, August 17th 2013
Load basslineOhm.scd
prm
*/

{
	s.sync;
	"/bassline/basslineOhm.scd".loadRelative;

	s.sync;
	~billyOhm.bassline.makeOSC;
}.fork;