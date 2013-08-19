/*
Saturday, August 17th 2013
stringsOhm.scd
prm
*/

~worseOhm.strings = (

	main: 0,
	playGran: 7,

	trigRateTop: 17,
	durLoTop: 16,
	durHiTop: 9,
	cutoffTop: 8,

	vol: 14,

	makeOSC: { | self |
		OSCdef(\worseStringsOhm, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \stringsTop } { self.spawn(val); }
		}, \worseControl, ~scLang);

		OSCdef(\worseStringsOhmRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case

			{ id == \stringsVol } { if ( val == 1, { self.makeVol; }) }

		}, \restoreOhmWorse, ~scLang);

		self;
	}



);