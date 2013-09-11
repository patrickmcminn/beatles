/*
Wednesday, August 28th 2013
Load trumpetChordsOhm.scd
prm
*/

{
	s.sync;
	"/trumpetChords/trumpetChordsOhm.scd".loadRelative;

	s.sync;
	~billyOhm.trumpetChords.makeOSC;
}.fork;