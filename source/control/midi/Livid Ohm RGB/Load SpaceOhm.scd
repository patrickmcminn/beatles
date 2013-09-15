/*
Sunday September 15th 2013
Load spaceOhm.scd
prm
*/

{
	s.sync;
	~spaceOhm = ( );
	~restoreOhm.space = ( );
	~restoreOhm.space.page = Array.fill(81, nil);

	s.sync;
  "/Space/Space Page.scd".loadRelative;
  "/Space/tanpuraOhm.scd".loadRelative;
  "/Space/droneOhm.scd".loadRelative;

  s.sync;
  ~spaceOhm.tanpura.makeOSC;
  ~spaceOhm.drone .makeOSC;

}.fork;