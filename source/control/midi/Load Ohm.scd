/*
Thursday, October 18th 2012
edited 12/10/2012
reflects new control surface function handling
Load Ohm.scd
prm
*/


try
{
	"/Livid Ohm RGB/ohmInit.scd".loadRelative;
	"/Livid Ohm RGB/beatlesOhm.scd".loadRelative;
	"/Livid Ohm RGB/loadStructural.scd".loadRelative;
	"/Livid Ohm RGB/loadStructural.scd".loadRelative;
	"/Livid Ohm RGB/topPage.scd".loadRelative;
	"/Livid Ohm RGB/Load LucyOhm.scd".loadRelative;
	"/Livid Ohm RGB/Load noWorseOhm.scd".loadRelative;


	"/Livid Ohm RGB/ohmStartup.scd".loadRelative;
}

{ "Livid Ohm RGB not present!".postln; }