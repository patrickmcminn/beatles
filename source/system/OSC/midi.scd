/*
Thursday, October 18th 2012
midi.scd
prm
*/

OSCdef(\page, { | msg |
	var id, val;
	id = msg.at(1);
	val = msg.at(2);

	case
	{ id == \top } { ~page[\top].value }

}, \page, ~scLang);