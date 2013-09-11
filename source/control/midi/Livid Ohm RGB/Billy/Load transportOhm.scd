/*
Wednesday, August 28th 2013
Load transportOhm.scd
prm
*/

{
	s.sync;
	"/transport/transportOhm.scd".loadRelative;

	s.sync;
	~billyOhm.transport.makeOSC;
}.fork;