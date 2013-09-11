/*
Tuesday, August 27th 2013
Load HenryOhm.scd
prm
*/

{
	s.sync;
	~ritaOhm = ( );
	~restoreOhm.rita = ( );
	~restoreOhm.rita.page = Array.fill(81, nil);

	s.sync;
	"/Rita/Rita Page.scd".loadRelative;
	"/Rita/Load TrumpetOhm.scd".loadRelative;
}.fork;