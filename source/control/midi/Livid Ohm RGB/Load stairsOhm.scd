/*
Tuesday, September 10th 2013
Load stairsOhm.scd
prm
*/

{
	s.sync;
	~stairsOhm = ( );
	~restoreOhm.stairs = ( );
	~restoreOhm.stairs.page = Array.fill(81, nil);

	s.sync;
	"/stairs/Stairs Page.scd".loadRelative;
	"/stairs/tapeChoraleOhm.scd".loadRelative;

	s.sync;
	~stairsOhm.tapeChorale.makeOSC;
}.fork;