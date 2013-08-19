/*
Monday, August 19th 2013
droneOhm.scd
prm
*/

~worseOhm.drone = (

	main: 1,
	playGran: 8,

	vol: 15,

	makeOSC: { | self |
		OSCdef(\worseDroneOhm, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \droneTop } { self.spawn(val); }
			{ id == \droneToggleGran } { self.playGranOhm(val); }
		}, \worseControl, ~scLang);

		OSCdef(\worseDroneOhmRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case

			{ id == \droneVol } { if ( val == 1, { self.makeVol; }) }
			{ id == \dronePlayGran } { if ( val == 1, { self.makePlayGranMIDI; } ) }

		}, \restoreOhmWorse, ~scLang);

		self;
	}

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
				~ohm.turnGreen(self.main);
				~restoreOhm.worse.page.put(self.main, \green);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.worse.page.put(self.main, \red);
			}
		);
		self;
	},

	makePlayGran: { | self |
		~ohm.turnWhite(self.playGran);
		~restoreOhm.worse.page.put(self.playGran, \white);
		self.makePlayGranMIDI;
		~restoreOhm.worse.dronePlayGran = 1;
		self;
	},

	killPlayGran: { | self |
		~ohm.turnOff(self.playGran);
		~restoreOhm.worse.page.put(self.playGran, \off);
		self.killPlayGranMIDI;
		~restoreOhm.worse.dronePlayGran = 0;
		self;
	},

	makePlayGranMIDI: { | self |
		MIDIdef.noteOn(\dronePlayGran, {
			~worse.drone.toggleGran;
			~scLang.sendMsg(\worseControl, \droneToggleGran, ~worse.drone.playState);
		}, self.playGran);
		self;
	},

	killPlayGranMIDI: { | self |
		MIDIdef(\playGran).free;
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
		MIDIdef.cc(\droneVol, { | val |
			var amp = val.linlin(0, 127, 0, -12.dbamp);
			~worse.drone.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.worse.droneVol = 1;
		self;

	},

	killVol: { | self |
		MIDIdef(\droneVol).free;
		~restoreOhm.worse.droneVol = 0;
		self;
	},

	makeDials: { | self |

		self;
	},

	killDials: { | self |

		self;
	}
);