/*
Sunday, September 15th 2013
Load IntroOhm.scd
prm
*/

{
	s.sync;
	~introOhm = ( );
	~restoreOhm.intro = ( );
	~restoreOhm.intro.page = Array.fill(81, nil);

	s.sync;
	"/Intro/Intro Page.scd".loadRelative;
  "/Intro/textureOhm.scd".loadRelative;

  s.sync;
  ~introOhm.texture.makeOSC;

}.fork;