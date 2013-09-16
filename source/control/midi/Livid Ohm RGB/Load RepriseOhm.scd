/*
Sunday, September 15th 2013
Load RepriseOhm.scd
prm
*/

{
	s.sync;
	~repriseOhm = ( );
	~restoreOhm.reprise = ( );
	~restoreOhm.reprise.page = Array.fill(81, nil);

	s.sync;
	"/Reprise/Reprise Page.scd".loadRelative;
  "/Reprise/warmUpOhm.scd".loadRelative;
  "/Reprise/laughTrackOhm.scd".loadRelative;

  s.sync;
  ~repriseOhm.warmUp.makeOSC;
  ~repriseOhm.laughTrack.makeOSC;

}.fork;