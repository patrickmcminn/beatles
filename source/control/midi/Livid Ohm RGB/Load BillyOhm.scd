/*
Tuesday, August 27th 2013
Load HenryOhm.scd
prm
*/

{
	s.sync;
	~billyOhm = ( );
	~restoreOhm.billy = ( );
	~restoreOhm.billy.page = Array.fill(81, nil);

	s.sync;
	"/Billy/Billy Page.scd".loadRelative;
	"/Billy/Load transportOhm.scd".loadRelative;
	"/Billy/Load vibraphoneOhm.scd".loadRelative;
	"/Billy/Load trumpetChordsOhm.scd".loadRelative;
	"/Billy/Load basslineOhm.scd".loadRelative;
}.fork;