/*
Friday August 30th 2013
noiseBedOhm.scd
prm
*/

~boyOhm.noiseBed = (

	main: 0,
	gran1: 8,
	gran2: 16,
	gran3: 24,

	vol: 14,

	makeOSC: { | self |
		OSCdef(\boyNoiseBed, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \noiseBedTop } { self.spawn(val); }
			{ id == \noiseBedGran1 } { self.gran1Ohm(val); }
			{ id == \noiseBedGran2 } { self.gran2Ohm(val); }
			{ id == \noiseBedGran3 } { self.gran3Ohm(val); }
		}, \boyControl, ~scLang);

		OSCdef(\boyNoiseBedOhmRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \noiseBedVol } { if ( val == 1, { self.makeVol; }) }
			{ id == \noiseBedGran1 } { if( val == 1, { self.makeGran1MIDI; }) }
			{ id == \noiseBedGran2 } { if( val == 1, { self.makeGran2MIDI; }) }
			{ id == \noiseBedGran3 } { if( val == 1, { self.makeGran3MIDI; }) }
		}, \restoreOhmBoy, ~scLang);
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
		self.makeGran1;
		self.makeGran2;
		self.makeGran3;
		self;
	},

	killButtons: { | self |
		self.topOhm(0);
		self.killGran1;
		self.killGran2;
		self.killGran3;
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
				~restoreOhm.boy.page.put(self.main, \yellow);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.boy.page.put(self.main, \red);
			}
		);
		self;
	},

	makeGran1: { | self |
		~ohm.turnBlue(self.gran1);
		~restoreOhm.boy.page.put(self.gran1, \blue);
		self.makeGran1MIDI;
		~restoreOhm.boy.noiseBedGran1 = 1;
		self;
	},

	killGran1: { | self |
		~ohm.turnOff(self.gran1);
		~restoreOhm.boy.page.put(self.gran1, \off);
		self.killGran1MIDI;
		~restoreOhm.boy.noiseBedGran1 = 0;
		self;
	},

	makeGran1MIDI: { | self |
		MIDIdef.noteOn(\noiseBedGran1, {
			~boy.noiseBed.toggleGran1;
			~scLang.sendMsg(\boyControl, \noiseBedGran1, ~boy.noiseBed.gran1State);
		}, self.gran1);
		self;
	},

	killGran1MIDI: { | self |
		MIDIdef(\noiseBedGran1).free;
		self;
	},

	gran1Ohm: { | self, val |
		if( val == 1,
			{
				~ohm.turnGreen(self.gran1);
				~restoreOhm.boy.page.put(self.gran1, \green);
			},
			{
				~ohm.turnRed(self.gran1);
				~restoreOhm.boy.page.put(self.gran1, \red);
			}
		);
		self;
	},

	makeGran2: { | self |
		~ohm.turnPurple(self.gran2);
		~restoreOhm.boy.page.put(self.gran2, \purple);
		self.makeGran2MIDI;
		~restoreOhm.boy.noiseBedGran2 = 1;
		self;
	},

	killGran2: { | self |
		~ohm.turnOff(self.gran2);
		~restoreOhm.boy.page.put(self.gran2, \off);
		self.killGran2MIDI;
		~restoreOhm.boy.noiseBedGran2 = 0;
		self;
	},

	makeGran2MIDI: { | self |
		MIDIdef.noteOn(\noiseBedGran2, {
			~boy.noiseBed.toggleGran2;
			~scLang.sendMsg(\boyControl, \noiseBedGran2, ~boy.noiseBed.gran2State);
		}, self.gran2);
		self;
	},

	killGran2MIDI: { | self |
		MIDIdef(\noiseBedGran2).free;
		self;
	},

	gran2Ohm: { | self, val |
		if( val == 1,
			{
				~ohm.turnGreen(self.gran2);
				~restoreOhm.boy.page.put(self.gran2, \green);
			},
			{
				~ohm.turnRed(self.gran2);
				~restoreOhm.boy.page.put(self.gran2, \red);
			}
		);
		self;
	},

	makeGran3: { | self |
		~ohm.turnCyan(self.gran3);
		~restoreOhm.boy.page.put(self.gran3, \cyan);
		self.makeGran3MIDI;
		~restoreOhm.boy.noiseBedGran3 = 1;
		self;
	},

	killGran3: { | self |
		~ohm.turnOff(self.gran3);
		~restoreOhm.boy.page.put(self.gran3, \off);
		self.killGran3MIDI;
		~restoreOhm.boy.noiseBedGran3 = 0;
		self;
	},

	makeGran3MIDI: { | self |
		MIDIdef.noteOn(\noiseBedGran3, {
			~boy.noiseBed.toggleGran3;
			~scLang.sendMsg(\boyControl, \noiseBedGran3, ~boy.noiseBed.gran3State);
		}, self.gran3);
		self;
	},

	killGran3MIDI: { | self |
		MIDIdef(\noiseBedGran3).free;
		self;
	},

	gran3Ohm: { | self, val |
		if( val == 1,
			{
				~ohm.turnGreen(self.gran3);
				~restoreOhm.boy.page.put(self.gran3, \green);
			},
			{
				~ohm.turnRed(self.gran3);
				~restoreOhm.boy.page.put(self.gran3, \red);
			}
		);
		self;
	},


	makeVol: { | self |
		MIDIdef.cc(\noiseBedVol, { | val |
			var amp = val.linlin(0, 127, 0, 10.dbamp);
			~boy.noiseBed.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.boy.noiseBedVol = 1;
		self;
	},

	killVol: { | self |
		MIDIdef(\noiseBedVol).free;
		~restoreOhm.boy.noiseBedVol = 0;
		self;
	},

	makeDials: { | self |
		self;
	},

	killDials: { | self |
		self;
	},

);
