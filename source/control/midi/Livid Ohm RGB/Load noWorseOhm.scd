/*
Saturday, August 17th 2013
Load noWorseOhm.scd
prm
*/

{
	s.sync;
	~worseOhm = ( );
	~restoreOhm.worse = ( );
	~restoreOhm.worse.page = Array.fill(81, nil);

	s.sync;
	"/No Worse/No Worse Page.scd".loadRelative;
	"/No Worse/Load stringsOhm.scd".loadRelative;
	"/No Worse/Load droneOhm.scd".loadRelative;
	"/No Worse/Load brokenPianoOhm.scd".loadRelative;
	"/No Worse/Load vampOhm.scd".loadRelative;