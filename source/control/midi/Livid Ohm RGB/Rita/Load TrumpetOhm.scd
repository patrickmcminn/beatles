/*
Tuesday, August 20th 2013
Load textureOhm.scd
prm
*/

{
	s.sync;
	"/trumpet/trumpetOhm.scd".loadRelative;

	s.sync;
	~ritaOhm.trumpet.makeOSC;
}.fork;