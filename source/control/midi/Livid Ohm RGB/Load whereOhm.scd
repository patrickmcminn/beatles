/*
Thursday, August 29th 2013
Load whereOhm.scd
prm
*/

{
	s.sync;
	~whereOhm = ( );
	~restoreOhm.where = ( );
	~restoreOhm.where.page = Array.fill(81, nil);

	s.sync;
	"/Where/Where Page.scd".loadRelative;
	"/Where/Load pianoChordsOhm.scd".loadRelative;
	"/Where/Load endChordsOhm.scd".loadRelative;
}.fork;