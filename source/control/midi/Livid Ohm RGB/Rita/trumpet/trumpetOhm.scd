/*
Wednesday, August 28th 2013
trumpetOhm.scd
prm
*/

~ritaOhm.trumpet = (

	main: 0,
	toggle: 8,

	vol: 14,
	cutoff: 17,

	makeOSC: { | self |
		OSCdef(\ritaTrumpetOhm, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \trumpetTop } { self.spawn(val); }
			{ id == \trumpetToggle } { self.toggleOhm(val); }
		}, \ritaControl, ~scLang);

		OSCdef(\ritaTrumpetOhmRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \trumpetVol } { if ( val == 1, { self.makeVol; }) }
			{ id == \trumpetToggle } { if ( val == 1, { self.makeToggleMIDI; }) }
			{ id == \trumpetCutoff } { if ( val == 1, { self.makeCutoff; }) }
		}, \restoreOhmRita, ~scLang);
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
		self.makeToggle;
		self;
	},

	killButtons: { | self |
		self.topOhm(0);
		self.killToggle;
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

	makeDials: { | self |
		self.makeCutoff;
		self;
	},

	killDials: { | self |
		self.killCutoff;
		self;
	},

	topOhm: { | self, val |
		if( val == 1,
			{
				~ohm.turnPurple(self.main);
				~restoreOhm.rita.page.put(self.main, \purple);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.rita.page.put(self.main, \red);
			}
		);
		self;
	},

	makeToggle: { | self |
		~ohm.turnGreen(self.toggle);
		~restoreOhm.rita.page.put(self.toggle, \green);
		self.makeToggleMIDI;
		~restoreOhm.rita.trumpetToggle = 1;
		self;
	},

	killToggle: { | self |
		~ohm.turnOff(self.toggle);
		~restoreOhm.rita.page.put(self.toggle, \off);
		self.killToggleMIDI;
		~restoreOhm.rita.trumpetToggle = 0;
		self;
	},

	makeToggleMIDI: { | self |
		MIDIdef.noteOn(\trumpetToggle, {
			~rita.trumpet.toggleMute;
			~scLang.sendMsg(\ritaControl, \trumpetToggle,  ~rita.trumpet.muteState);
		}, self.toggle);
		self;
	},

	killToggleMIDI: { | self |
		MIDIdef(\trumpetToggle).free;
		self;
	},

	toggleOhm: { | self, val |
		if( val == 1,
			{
				~ohm.turnGreen(self.toggle);
				~restoreOhm.rita.page.put(self.toggle, \green);
			},
			{
				~ohm.turnRed(self.toggle);
				~restoreOhm.rita.page.put(self.toggle, \red);
			}
		);
		self;
	},

	makeVol: { | self |
		MIDIdef.cc(\trumpetVol, { | val |
			var amp = val.linlin(0, 127, 0, 4.dbamp);
			~rita.trumpet.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.rita.trumpetVol = 1;
		self;
	},

	killVol: { | self |
		MIDIdef(\trumpetVol).free;
		~restoreOhm.rita.trumpetVol = 0;
		self;
	},

	makeDials: { | self |
		self.makeCutoff;
		self;
	},

	killDials: { | self |
		self.killCutoff;
		self;
	},

	makeCutoff: { | self |
		MIDIdef.cc(\trumpetCutoff, { | val |
			var cutoff = val.linlin(0, 127, 50, 3500);
			~rita.trumpet.huge.set(\cutoff, cutoff);
		}, self.cutoff);
		~restoreOhm.rita.trumpetCutoff = 1;
	},

	killCutoff: { | self |
		MIDIdef(\trumpetCutoff).free;
		~restoreOhm.rita.trumpetCutoff = 0;
	},

);
