/*
Saturday, August 17th 2013
Load droneOhm.scd
prm
*/

{
	s.sync;
	"/drone/droneOhm.scd".loadRelative;

	s.sync;
	~worseOhm.drone.makeOSC;
}.fork;
	