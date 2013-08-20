/*
Saturday, August 17th 2013
Load stringsOhm.scd
prm
*/

{
	s.sync;
	"/strings/stringsOhm.scd".loadRelative;

	s.sync;
	~worseOhm.strings.makeOSC;
}.fork;

