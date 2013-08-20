/*
Saturday, August 17th 2013
brokenPianoOhm.scd
prm
*/

~worseOhm.brokenPiano = (

	main: 2,
	blocks: 10,

	vol: 22,

	makeOSC: { | self |
		OSCdef(\worseBrokenPianoOhm, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \brokenPianoTop } { self.spawn(val); }
			{ id == \brokenPianoBlocks } { self.blocksOhm(val); }
		}, \worseControl, ~scLang);

		OSCdef(\worseBrokenPianoOhmRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case

			{ id == \brokenPianoVol } { if ( val == 1, { self.makeVol; }) }
			{ id == \brokenPianoBlocks } { if ( val == 1, { self.makeBlocksMIDI; } ) }

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
		self.makeBlocks;
		self;
	},

	killButtons: { | self |
		self.topOhm(0);
		self.killBlocks;
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
				~restoreOhm.worse.page.put(self.main, \yellow);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.worse.page.put(self.main, \red);
			}
		);
		self;
	},

	makeBlocks: { | self |
		~ohm.turnCyan(self.blocks);
		~restoreOhm.worse.page.put(self.blocks, \cyan);
		self.makeBlocksMIDI;
		~restoreOhm.worse.brokenPianoBlocks = 1;
		self;
	},

	killBlocks: { | self |
		~ohm.turnOff(self.blocks);
		~restoreOhm.worse.page.put(self.blocks, \off);
		self.killBlocksMIDI;
		~restoreOhm.worse.brokenPianoBlocks = 0;
		self;
	},

	makeBlocksMIDI: { | self |
		MIDIdef.noteOn(\brokenPianoBlocks, {
			~worse.brokenPiano.toggleBlocks;
			~scLang.sendMsg(\worseControl, \brokenPianoBlocks, ~worse.brokenPiano.blockState);
		}, self.blocks);
		self;
	},

	killBlocksMIDI: { | self |
		MIDIdef(\brokenPianoBlocks).free;
		self;
	},

	blocksOhm: { | self, val |
		if ( val == 1,
			{
				~ohm.turnPurple(self.blocks);
				~restoreOhm.worse.page.put(self.blocks, \purple);
			},
			{
				~ohm.turnRed(self.blocks);
				~restoreOhm.worse.page.put(self.blocks, \red);
			}
		);
		self;
	},


	makeVol: { | self |
		MIDIdef.cc(\brokenPianoVol, { | val |
			var amp = val.linlin(0, 127, 0, 6.dbamp);
			~worse.brokenPiano.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.worse.brokenPianoVol = 1;
		self;

	},

	killVol: { | self |
		MIDIdef(\stringsVol).free;
		~restoreOhm.worse.brokenPianoVol = 0;
		self;
	},

	makeDials: { | self |
		self;
	},

	killDials: { | self |
		self;
	},

);