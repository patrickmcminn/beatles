/*
Tuesday, August 27th 2013
Load HenryOhm.scd
prm
*/

{
	s.sync;
	~henryOhm = ( );
	~restoreOhm.henry = ( );
	~restoreOhm.henry.page = Array.fill(81, nil);

	s.sync;
	"/Henry/Henry Page.scd".loadRelative;
	"/Henry/Load triangleOhm.scd".loadRelative;
	"/Henry/Load toyPianoOhm.scd".loadRelative;
	"/Henry/Load bellsOhm.scd".loadRelative;
	"/Henry/Load harmonicaOhm.scd".loadRelative;
}.fork;