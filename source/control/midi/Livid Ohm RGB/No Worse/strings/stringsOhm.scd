/*
Saturday, August 17th 2013
stringsOhm.scd
prm
*/

~worseOhm.strings = (

	main: 0,
	playGran: 8,

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
			{ id == \stringsToggleGran } { self.playGranOhm(val); }
		}, \worseControl, ~scLang);

		OSCdef(\worseStringsOhmRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case

			{ id == \stringsVol } { if ( val == 1, { self.makeVol; }) }
			{ id == \stringsPlayGran } { if ( val == 1, { self.makePlayGranMIDI; } ) }
			{ id == \stringDials } { if ( val == 1, { self.makeDials; }); }

		}, \restoreOhmWorse, ~scLang);

		self;
	},

	spawn: { | self, val |
		if( val == 1, { self.init; }, { self.kill; });
		self;
	},

	init: { | self |
		self.makeButtons;
		self.makeFaders;
		self.makeDials;
		self;
	},

	kill: { | self |
		self.killButtons;
		self.killFaders;
		self.killDials;
		self;
	},

	makeButtons: { | self |
		self.topOhm(1);
		self.makePlayGran;
		self;
	},

	killButtons: { | self |
		self.topOhm(0);
		self.killPlayGran;
		self;
	},

	makeFaders: { | self |
		self.makeVol;
		self;
	},

	killFaders: { | self |
		self.killVol;
		self;
	},

	topOhm: { | self, val |
		if( val == 1,
			{
				~ohm.turnWhite(self.main);
				~restoreOhm.worse.page.put(self.main, \white);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.worse.page.put(self.main, \red);
			}
		);
		self;
	},

	makePlayGran: { | self |
		~ohm.turnBlue(self.playGran);
		~restoreOhm.worse.page.put(self.playGran, \blue);
		self.makePlayGranMIDI;
		~restoreOhm.worse.stringsPlayGran = 1;
		self;
	},

	killPlayGran: { | self |
		~ohm.turnOff(self.playGran);
		~restoreOhm.worse.page.put(self.playGran, \off);
		self.killPlayGranMIDI;
		~restoreOhm.worse.stringsPlayGran = 0;
		self;
	},

	makePlayGranMIDI: { | self |
		MIDIdef.noteOn(\stringsPlayGran, {
			~worse.stringHaze.toggleGran;
			~scLang.sendMsg(\worseControl, \stringsToggleGran, ~worse.stringHaze.playState);
		}, self.playGran);
		self;
	},

	killPlayGranMIDI: { | self |
		MIDIdef(\stringsPlayGran).free;
		self;
	},

	playGranOhm: { | self, val |
		if( val == 1,
			{
				~ohm.turnGreen(self.playGran);
				~restoreOhm.worse.page.put(self.playGran, \green);
			},
			{
				~ohm.turnRed(self.playGran);
				~restoreOhm.worse.page.put(self.playGran, \red);
			}
		);
		self;
	},


	makeVol: { | self |
		MIDIdef.cc(\stringsVol, { | val |
			var amp = val.linlin(0, 127, 0, 5.dbamp);
			~worse.stringHaze.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.worse.stringsVol = 1;
		self;

	},

	killVol: { | self |
		MIDIdef(\stringsVol).free;
		~restoreOhm.worse.stringsVol = 0;
		self;
	},

	makeDials: { | self |
		self.makeTrigRate;
		self.makeDurLo;
		self.makeDurHi;
		self.makeCutoff;
		~restoreOhm.worse.stringDials = 1;
		self;
	},

	killDials: { | self |
		self.killTrigRate;
		self.killDurLo;
		self.killDurHi;
		self.killCutoff;
		~restoreOhm.worse.stringDials = 0;
		self;
	},

	makeTrigRate: { | self |
		MIDIdef.cc(\stringsTrigRate, { | val |
			var rate = val.linlin(0, 127, 1.0, 100.0);
			~worse.stringHaze.trigRate = rate;
			if( ~worse.stringHaze.playState == 1, { ~worse.stringHaze.gran.set(\trigRate, rate); });
		}, self.trigRateTop);
		self;
	},

	killTrigRate: { | self |
		MIDIdef(\stringsTrigRate).free;
		self;
	},

	makeDurLo: { | self |
		MIDIdef.cc(\stringsDurLo, { | val |
			var dur = val.linlin(0, 127, 0.00005, 0.1);
			~worse.stringHaze.durLo = dur;
			if( ~worse.stringHaze.playState ==1, { ~worse.stringHaze.gran.set(\grainDurLo, dur); });
		}, self.durLoTop);
		self;
	},

	killDurLo: { | self |
		MIDIdef(\stringsDurLo).free;
		self;
	},

	makeDurHi: { | self |
		MIDIdef.cc(\stringsDurHi, { | val |
			var dur = val.linlin(0, 127, 0.001, 0.5);
			~worse.stringHaze.durHi = dur;
			if( ~worse.stringHaze.playState == 1, { ~worse.stringHaze.gran.set(\grainDurHi, dur); });
		}, self.durHiTop);
		self;
	},

	killDurHi: { | self |
		MIDIdef(\stringsDurHi).free;
		self;
	},

	makeCutoff: { | self |
		MIDIdef.cc(\stringsCutoff, { | val |
			var cutoff = val.linlin(0, 127, 600, 10000);
			~worse.stringHaze.cutoff = cutoff;
			if ( ~worse.stringHaze.playState == 1, { ~worse.stringHaze.gran.set(\cutoff, cutoff); });
		}, self.cutoffTop);
		self;
	},

	killCutoff: { | self |
		MIDIdef(\stringsCutoff).free;
		self;
	},
);