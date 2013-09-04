/*
Wednesday, September 4th 2013
Load NeverOhm.scd
prm
*/

{
	s.sync;
	~neverOhm = ( );
	~restoreOhm.never = ( );
	~restoreOhm.never.page = Array.fill(81, nil);

	s.sync;
	"/Never/Never Page.scd".loadRelative;
	"/Never/Load fifteenKOhm.scd".loadRelative;
	"/Never/Load tptAccompOhm.scd".loadRelative;
	"/Never/Load routerOhm.scd".loadRelative;
	//"/Never/Load chordOhm.scd".loadRelative;
	//"/Never/Load mainLoopOhm.scd".loadRelative;
	//"/Never/Load beatlesGranOhm.scd".loadRelative;
	//"/Never/Load rewindOhm.scd".loadRelative;
}.fork;