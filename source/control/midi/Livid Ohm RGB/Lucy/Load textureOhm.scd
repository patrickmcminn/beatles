/*
Tuesday, August 20th 2013
Load textureOhm.scd
prm
*/

{
	s.sync;
	"/texture/textureOhm.scd".loadRelative;

	s.sync;
	~lucyOhm.texture.makeOSC;
}.fork;