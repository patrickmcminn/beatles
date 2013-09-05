/*
Wednesday, September 4th 2013
fifteenKOhmscd
prm
*/

~neverOhm.rewind = (

	main: 23,
	playRewind: 31,

	vol: 12,

	makeOSC: { | self |
		OSCdef(\neverRewindOhm, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \rewindTop } { self.spawn(val); }
			{ id == \rewindPlay } { self.playOhm(val); }
		}, \neverControl, ~scLang);

		OSCdef(\neverRewindOhmRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case

			{ id == \rewindVol } { if ( val == 1, { self.makeVol; }) }
			{ id == \rewindPlay} { if ( val == 1, { self.makePlayMIDI; }) }
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
				~ohm.turnPurple(self.main);
				~restoreOhm.never.page.put(self.main, \purple);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.never.page.put(self.main, \red);
			}
		);
		self;
	},

	makePlay: { | self |
		~ohm.turnCyan(self.playRewind);
		~restoreOhm.never.page.put(self.playRewind, \cyan);
		self.makePlayMIDI;
		~restoreOhm.never.rewindPlay = 1;
		self;
	},

	killPlay: { | self |
		~ohm.turnOff(self.playRewind);
		~restoreOhm.never.page.put(self.playRewind, \off);
		self.killPlayMIDI;
		~resotreOhm.never.rewindPlay = 0;
		self;
	},

	makePlayMIDI: { | self |
		MIDIdef.noteOn(\neverRewindPlay, {
			~never.rewind.toggleRewind;
			~scLang.sendMsg(\neverControl, \rewindPlay, ~never.rewind.playState);
		}, self.playRewind);
		self;
	},

	killPlayMIDI: { | self |
		MIDIdef(\neverRewindPlay).free;
		self;
	},

	playOhm: { | self, val |
		if( val == 1,
			{ ~ohm.turnGreen(self.playRewind); ~restoreOhm.never.page.put(self.playRewind, \green); },
			{ ~ohm.turnRed(self.playRewind); ~retoreOhm.never.page.put(self.playRewind, \red); }
		);
		self;
	},

	makeVol: { | self |
		MIDIdef.cc(\rewindVol, { | val |
			var amp = val.linlin(0, 127, 0, 1);
			~never.rewind.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.never.rewindVol = 1;
		self;

	},

	killVol: { | self |
		MIDIdef(\rewindVol).free;
		~restoreOhm.never.rewindVol = 0;
		self;
	},

	makeDials: { | self |
		self;
	},

	killDials: { | self |
		self;
	},
);