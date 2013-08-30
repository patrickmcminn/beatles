/*
Thursday, August 29th 2013
Load endChordsOhm.scd
prm
*/

{
	s.sync;
	"/endChords/endChordsOhm.scd".loadRelative;

	s.sync;
	~whereOhm.endChords.makeOSC;
}.fork;