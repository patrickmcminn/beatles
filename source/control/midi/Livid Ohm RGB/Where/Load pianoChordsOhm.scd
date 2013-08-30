/*
Thursday, August 29th 2013
Load pianoChordsOhm.scd
prm
*/

{
	s.sync;
	"/pianoChords/pianoChordsOhm.scd".loadRelative;

	s.sync;
	~whereOhm.pianoChords.makeOSC;
}.fork;