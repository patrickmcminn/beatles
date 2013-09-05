/*
Friday, August 30th 2013
Load boyOhm.scd
prm
*/

{
	s.sync;
	~boyOhm = ( );
	~restoreOhm.boy = ( );
	~restoreOhm.boy.page = Array.fill(81, nil);

	s.sync;
	"/Boy/Boy Page.scd".loadRelative;
	"/Boy/Load noiseBedOhm.scd".loadRelative;
	"/Boy/Load numbersOhm.scd".loadRelative;
}.fork;