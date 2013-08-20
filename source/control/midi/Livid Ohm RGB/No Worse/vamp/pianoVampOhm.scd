/*
Monday, August 19th 2013
pianoVampOhm.scd
prm
*/


~worseOhm.pianoVamp = (

	main: 3,
	playVamp: 11,

	vol: 23,

	makeOSC: { | self |
		OSCdef(\worsePianoVampOhm, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \pianoVampTop } { self.spawn(val); }
			{ id == \pianoVampPlay } { self.playOhm(val); }
		}, \worseControl, ~scLang);

		OSCdef(\worsePianoVampOhmRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case

			{ id == \pianoVampVol } { if ( val == 1, { self.makeVol; }) }
			{ id == \pianoVampPlay } { if ( val == 1, { self.makePlayMIDI; } ) }

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
		self.makePlay;
		self;
	},

	killButtons: { | self |
		self.topOhm(0);
		self.killPlay;
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
				~ohm.turnCyan(self.main);
				~restoreOhm.worse.page.put(self.main, \cyan);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.worse.page.put(self.main, \red);
			}
		);
		self;
	},

	makePlay: { | self |
		~ohm.turnBlue(self.playVamp);
		~restoreOhm.worse.page.put(self.playVamp, \blue);
		self.makePlayMIDI;
		~restoreOhm.worse.pianoVampPlay = 1;
		self;
	},

	killPlay: { | self |
		~ohm.turnOff(self.playVamp);
		~restoreOhm.worse.page.put(self.playVamp, \off);
		self.killPlayMIDI;
		~restoreOhm.worse.pianoVampPlay = 0;
		self;
	},

	makePlayMIDI: { | self |
		MIDIdef.noteOn(\pianoVampPlay, {
			~worse.pianoVamp.toggleVamp;
			~scLang.sendMsg(\worseControl, \pianoVampPlay, ~worse.pianoVamp.playState);
		}, self.playVamp);

		self;
	},

	killPlayMIDI: { | self |
		MIDIdef(\pianoVampPlay).free;
		self;
	},


	playOhm: { | self, val |
		if ( val == 1,
			{
				~ohm.turnGreen(self.playVamp);
				~restoreOhm.worse.page.put(self.playVamp, \green);
			},
			{
				~ohm.turnRed(self.playVamp);
				~restoreOhm.worse.page.put(self.playVamp, \red);
			}
		);
		self;
	},

	makeVol: { | self |
		MIDIdef.cc(\pianoVampVol, { | val |
			var amp = val.linlin(0, 127, 0, 6.dbamp);
			~worse.pianoVamp.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.worse.pianoVampVol = 1;
		self;

	},

	killVol: { | self |
		MIDIdef(\pianoVampVol).free;
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