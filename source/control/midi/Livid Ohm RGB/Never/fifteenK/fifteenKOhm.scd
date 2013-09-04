/*
Wednesday, September 4th 2013
fifteenKOhmscd
prm
*/

~neverOhm.fifteenK = (

	main: 0,
	play1: 8,
	play2: 16,
	play3: 24,
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
			{ id == \fifteenKStopAll } { self.stopAllOhm(val); }
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

	makeBlocks: { | self |
		~ohm.turnCyan(self.blocks);
		~restoreOhm.lucy.page.put(self.blocks, \cyan);
		self.makeBlocksMIDI;
		~restoreOhm.lucy.taikoBlocks = 1;
		self;
	},

	killBlocks: { | self |
		~ohm.turnOff(self.blocks);
		~restoreOhm.lucy.page.put(self.blocks, \off);
		self.killBlocksMIDI;
		~restoreOhm.lucy.taikoBlocks = 0;
		self;
	},

	makeBlocksMIDI: { | self |
		MIDIdef.noteOn(\taikoBlocks, {
			~lucy.taiko.toggleBlocks;
			~scLang.sendMsg(\lucyControl, \taikoBlocks, ~lucy.taiko.blockState);
		}, self.blocks);
		self;
	},

	killBlocksMIDI: { | self |
		MIDIdef(\taikoBlocks).free;
		self;
	},

	blocksOhm: { | self, val |
		if ( val == 1,
			{
				~ohm.turnPurple(self.blocks);
				~restoreOhm.lucy.page.put(self.blocks, \purple);
			},
			{
				~ohm.turnRed(self.blocks);
				~restoreOhm.lucy.page.put(self.blocks, \red);
			}
		);
		self;
	},


	makeVol: { | self |
		MIDIdef.cc(\taikoVol, { | val |
			var amp = val.linlin(0, 127, 0, 6.dbamp);
			~lucy.taiko.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.lucy.taikoVol = 1;
		self;

	},

	killVol: { | self |
		MIDIdef(\taikoVol).free;
		~restoreOhm.lucy.taikoVol = 0;
		self;
	},

	makeDials: { | self |
		self;
	},

	killDials: { | self |
		self;
	},

);