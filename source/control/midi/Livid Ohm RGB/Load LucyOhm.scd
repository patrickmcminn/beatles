/*
Saturday, August 17th 2013
Load LucyOhm.scd
prm
*/

{
	s.sync;
	~lucyOhm = ( );
	~restoreOhm.lucy = ( );
	~restoreOhm.lucy.page = Array.fill(81, nil);

	s.sync;
	"/Lucy/Lucy Page.scd".loadRelative;
	"/Lucy/Load textureOhm.scd".loadRelative;
	"/Lucy/Load taikoOhm.scd".loadRelative;
}.fork;