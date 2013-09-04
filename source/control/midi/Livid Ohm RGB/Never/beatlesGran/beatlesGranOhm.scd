/*
Wednesday, September 4th 2013
beatlesGranOhm.scd
prm
*/

~neverOhm.beatlesGran = (

	main: 1,
	blocks: 9,

	vol: 15,

	makeOSC: { | self |
		OSCdef(\lucyTaikoOhm, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \taikoTop } { self.spawn(val); }
			{ id == \taikoBlocks } { self.blocksOhm(val); }
		}, \lucyControl, ~scLang);

		OSCdef(\lucyTaikoOhmRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case

			{ id == \taikoVol } { if ( val == 1, { self.makeVol; }) }
			{ id == \taikoBlocks } { if ( val == 1, { self.makeBlocksMIDI; } ) }

		}, \restoreOhmLucy, ~scLang);

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
				~restoreOhm.lucy.page.put(self.main, \yellow);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.lucy.page.put(self.main, \red);
			}
		);
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