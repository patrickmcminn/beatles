/*
Wednesday, September 4th 2013
fifteenKOhmscd
prm
*/

~neverOhm.fifteenK = (

	main: 0,
	play1: 36,
	play2: 44,
	play3: 52,
	stopAll: 32,

	vol: 23,

	makeOSC: { | self |
		OSCdef(\neverfifteenKOhm, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \fifteenKTop } { self.spawn(val); }
			{ id == \fifteenKPlay1 } { self.play1Ohm(val); }
			{ id == \fifteenKPlay2 } { self.play2Ohm(val); }
			{ id == \fifteenKPlay3 } { self.play3Ohm(val); }
		}, \neverControl, ~scLang);

		OSCdef(\neverFifteenKOhmRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case

			{ id == \fifteenKVol } { if ( val == 1, { self.makeVol; }) }
			{ id == \fifteenKPlay1 } { if ( val == 1, { self.makePlay1MIDI; }) }
			{ id == \fifteenKPlay2 } { if ( val == 1, { self.makePlay2MIDI; }) }
			{ id == \fifteenKPlay3 } { if ( val == 1, { self.makePlay3MIDI; }) }
			{ id == \fifteenKStopAll } { if ( val == 1, { self.makeStopAllMIDI; }) }

		}, \restoreOhmNever, ~scLang);

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
		self.makePlay1;
		self.makePlay2;
		self.makePlay3;
		self.makeStopAll;
		self;
	},

	killButtons: { | self |
		self.topOhm(0);
		self.killPlay1;
		self.killPlay2;
		self.killPlay3;
		self.killStopAll;
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
				~ohm.turnYellow(self.main);
				~restoreOhm.never.page.put(self.main, \yellow);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.never.page.put(self.main, \red);
			}
		);
		self;
	},

	makePlay1: { | self |
		~ohm.turnCyan(self.play1);
		~restoreOhm.never.page.put(self.play1, \cyan);
		self.makePlay1MIDI;
		~restoreOhm.never.fifteenKPlay1 = 1;
		self;
	},

	killPlay1: { | self |
		~ohm.turnOff(self.play1);
		~restoreOhm.never.page.put(self.play1, \off);
		self.killPlay1MIDI;
		~restoreOhm.never.fifteenKPlay1 = 0;
		self;
	},

	makePlay1MIDI: { | self |
		MIDIdef.noteOn(\fifteenKPlay1, {
			~never.fifteenK.play1;
			~scLang.sendMsg(\neverControl, \fifteenKPlay1, 1);
		}, self.play1);
		self;
	},

	killPlay1MIDI: { | self |
		MIDIdef(\fifteenKPlay1).free;
		self;
	},

	play1Ohm: { | self, val |
		if( val == 1,
			{ ~ohm.turnWhite(self.play1); ~restoreOhm.never.page.put(self.play1, \white); },
			{ ~ohm.turnCyan(self.play1); ~restoreOhm.never.page.put(self.play1, \cyan); },
		);
		self;
	},

	makePlay2: { | self |
		~ohm.turnBlue(self.play2);
		~restoreOhm.never.page.put(self.play2, \blue);
		self.makePlay2MIDI;
		~restoreOhm.never.fifteenKPlay2 = 1;
		self;
	},

	killPlay2: { | self |
		~ohm.turnOff(self.play2);
		~restoreOhm.never.page.put(self.play2, \off);
		self.killPlay2MIDI;
		~restoreOhm.never.fifteenKPlay2 = 0;
		self;
	},

	makePlay2MIDI: { | self |
		MIDIdef.noteOn(\fifteenKPlay2, {
			~never.fifteenK.play2;
			~scLang.sendMsg(\neverControl, \fifteenKPlay2, 1);
		}, self.play2);
		self;
	},

	killPlay1MIDI: { | self |
		MIDIdef(\fifteenKPlay2).free;
		self;
	},

	play2Ohm: { | self, val |
		if( val == 1,
			{ ~ohm.turnWhite(self.play2); ~restoreOhm.never.page.put(self.play2, \white); },
			{ ~ohm.turnBlue(self.play2); ~restoreOhm.never.page.put(self.play2, \blue); },
		);
		self;
	},

	makePlay3: { | self |
		~ohm.turnPurple(self.play3);
		~restoreOhm.never.page.put(self.play3, \purple);
		self.makePlay3MIDI;
		~restoreOhm.never.fifteenKPlay3 = 1;
		self;
	},

	killPlay3: { | self |
		~ohm.turnOff(self.play3);
		~restoreOhm.never.page.put(self.play3, \off);
		self.killPlay3MIDI;
		~restoreOhm.never.fifteenKPlay3 = 0;
		self;
	},

	makePlay3MIDI: { | self |
		MIDIdef.noteOn(\fifteenKPlay3, {
			~never.fifteenK.play3;
			~scLang.sendMsg(\neverControl, \fifteenKPlay3, 1);
		}, self.play3);
		self;
	},

	killPlay3MIDI: { | self |
		MIDIdef(\fifteenKPlay3).free;
		self;
	},

	play3Ohm: { | self, val |
		if( val == 1,
			{ ~ohm.turnWhite(self.play3); ~restoreOhm.never.page.put(self.play3, \white); },
			{ ~ohm.turnPurple(self.play3); ~restoreOhm.never.page.put(self.play3, \purple); },
		);
		self;
	},

	makeStopAll: { | self |
		~ohm.turnRed(self.stopAll);
		~restoreOhm.never.page.put(self.stopAll, \red);
		self.makeStopAllMIDI;
		~restoreOhm.never.fifteenKStopAll = 1;
		self;
	},

	killStopAll: { | self |
		~ohm.turnOff(self.stopAll);
		~restoreOhm.never.page.put(self.stopAll, \off);
		self.killStopAllMIDI;
		~restoreOhm.never.fifteenKStopAll = 0;
		self;
	},

	makeStopAllMIDI: { | self |
		MIDIdef.noteOn(\fifteenKStopAll, {
			~never.fifteenK.stopAll;
			~scLang.sendMsg(\neverControl, \fifteenKPlay1, 0);
			~scLang.sendMsg(\neverControl, \fifteenKPlay2, 0);
			~scLang.sendMsg(\neverControl, \fifteenKPlay3, 0);
		}, self.stopAll;);
		self;
	},

	killStopAllMIDI: { | self |
		MIDIdef(\fifteenKStopAll).free;
		self;
	},

	makeVol: { | self |
		MIDIdef.cc(\fifteenKVol, { | val |
			var amp = val.linlin(0, 127, 0, 1);
			~never.fifteenK.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.never.fifteenKVol = 1;
		self;

	},

	killVol: { | self |
		MIDIdef(\fifteenKVol).free;
		~restoreOhm.never.fifteenKVol = 0;
		self;
	},

	makeDials: { | self |
		self;
	},

	killDials: { | self |
		self;
	},

);