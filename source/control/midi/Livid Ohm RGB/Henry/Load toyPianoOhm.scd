/*
Tuesday, August 17th 2013
Load toyPianoOhm.scd
prm
*/

{
	s.sync;
	"/toyPiano/toyPianoOhm.scd".loadRelative;

	s.sync;
	~henryOhm.toyPiano.makeOSC;
}.fork;



	