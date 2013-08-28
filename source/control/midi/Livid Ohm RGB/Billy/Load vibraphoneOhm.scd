/*
Wednesday, August 28th 2013
Load vibraphoneOhm.scd
prm
*/

{
	s.sync;
	"/vibraphone/vibraphoneOhm.scd".loadRelative;

	s.sync;
	~billyOhm.vibraphone.makeOSC;
}.fork;