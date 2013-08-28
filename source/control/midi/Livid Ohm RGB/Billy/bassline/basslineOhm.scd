/*
Tuesday, August 27th 2013
triangleOhm.scd
prm
*/

~henryOhm.triangle = (

	main: 6,
	toggle: 14,

	vol: 14,

	makeOSC: { | self |
		OSCdef(\henryTriangleOhm, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \triangleTop } { self.spawn(val); }
			{ id == \triangleToggle } { self.toggleOhm(val); }
		}, \henryControl, ~scLang);

		OSCdef(\henryTriangleOhmRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case

			{ id == \triangleVol } { if ( val == 1, { self.makeVol; }) }
			{ id == \triangleToggle} { if ( val == 1, { self.makeToggleMIDI; } ) }

		}, \restoreOhmHenry, ~scLang);

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

	topOhm: { | self, val |
		if( val == 1,
			{
				~ohm.turnYellow(self.main);
				~restoreOhm.henry.page.put(self.main, \yellow);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.henry.page.put(self.main, \red);
			}
		);
		self;
	},

	makeToggle: { | self |
		~ohm.turnCyan(self.toggle);
		~restoreOhm.henry.page.put(self.toggle, \cyan);
		self.makeToggleMIDI;
		~restoreOhm.henry.triangleToggle = 1;
		self;
	},

	killToggle: { | self |
		~ohm.turnOff(self.toggle);
		~restoreOhm.henry.page.put(self.toggle, \off);
		self.killToggleMIDI;
		~restoreOhm.henry.triangleToggle = 0;
		self;
	},

	makeToggleMIDI: { | self |
		MIDIdef.noteOn(\triangleToggle, {
			~henry.triangle.muteToggle;
			~scLang.sendMsg(\henryControl, \triangleToggle, ~henry.triangle.muteState);
		}, self.toggle);
		self;
	},

	killToggleMIDI: { | self |
		MIDIdef(\triangleToggle).free;
		self;
	},

	toggleOhm: { | self, val |
		if ( val == 1,
			{
				~ohm.turnPurple(self.toggle);
				~restoreOhm.henry.page.put(self.toggle, \purple);
			},
			{
				~ohm.turnRed(self.toggle);
				~restoreOhm.henry.page.put(self.toggle, \red);
			}
		);
		self;
	},


	makeVol: { | self |
		MIDIdef.cc(\triangleVol, { | val |
			var amp = val.linlin(0, 127, 0, 6.dbamp);
			~henry.triangle.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.henry.triangleVol = 1;
		self;

	},

	killVol: { | self |
		MIDIdef(\triangleVol).free;
		~restoreOhm.henry.triangleVol = 0;
		self;
	},

	makeDials: { | self |
		self;
	},

	killDials: { | self |
		self;
	},

);

);