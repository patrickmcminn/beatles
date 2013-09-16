/*
Sunday, September 15th 2013
Load NothingOhm.scd
prm
*/

{
	s.sync;
	~nothingOhm = ( );
	~restoreOhm.nothing = ( );
	~restoreOhm.nothing.page = Array.fill(81, nil);

	s.sync;
	"/Nothing/Nothing Page.scd".loadRelative;
  "/Nothing/birdSongOhm.scd".loadRelative;
  "/Nothing/brassOhm.scd".loadRelative;

  s.sync;
  ~nothingOhm.birdSong.makeOSC;
  ~nothingOhm.brass.makeOSC;

}.fork;