/*
Wednesday, September 4th 2013
Load routerOhm.scd
prm
*/

{
	s.sync;
	"/router/routerOhm.scd".loadRelative;

	s.sync;
	~neverOhm.router.makeOSC;
}.fork;