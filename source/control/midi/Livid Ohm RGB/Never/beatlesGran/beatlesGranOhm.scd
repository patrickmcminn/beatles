/*
Wednesday, September 4th 2013
beatlesGranOhm.scd
prm
*/

~neverOhm.beatlesGran = (

	main: 7,
	playGran: 15,

	vol: 13,

	makeOSC: { | self |
		OSCdef(\neverBeatlesGranOhm, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \beatlesGranTop } { self.spawn(val); }
			{ id == \beatlesGranPlay } { self.playOhm(val); }
		}, \neverControl, ~scLang);

		OSCdef(\neverBeatlesGranOhmRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case

			{ id == \beatlesGranVol } { if ( val == 1, { self.makeVol; }) }
			{ id == \beatlesGranPlay } { if( val == 1, { self.makePlayMIDI; }) }

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

	makePlay: { | self |
		~ohm.turnBlue(self.playGran);
		~restoreOhm.never.page.put(self.playGran, \blue);
		self.makePlayMIDI;
		~restoreOhm.never.beatlesGranPlay = 1;
		self;
	},

	killPlay: { | self |
		~ohm.turnOff(self.playGran);
		~restoreOhm.never.page.put(self.playGran, \off);
		self.killPlayMIDI;
		~resotreOhm.never.beatlesGranPlay = 0;
		self;
	},

	makePlayMIDI: { | self |
		MIDIdef.noteOn(\neverBeatlesGran, {
			~never.beatlesGran.toggleGran;
			~scLang.sendMsg(\neverControl, \beatlesGranPlay, ~never.beatlesGran.playState);
		}, self.playGran);
		self;
	},

	killPlayMIDI: { | self |
		MIDIdef(\neverBeatlesGran).free;
		self;
	},

	playOhm: { | self, val |
		if( val == 1,
			{ ~ohm.turnGreen(self.playGran); ~restoreOhm.never.page.put(self.playGran, \green); },
			{ ~ohm.turnRed(self.playGran); ~retoreOhm.never.page.put(self.playGran, \red); }
		);
		self;
	},

	makeVol: { | self |
		MIDIdef.cc(\beatlesGranVol, { | val |
			var amp = val.linlin(0, 127, 0, 1);
			~never.beatlesGran.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.never.beatlesGranVol = 1;
		self;

	},

	killVol: { | self |
		MIDIdef(\beatlesGranVol).free;
		~restoreOhm.never.beatlesGranVol = 0;
		self;
	},

	makeDials: { | self |
		self;
	},

	killDials: { | self |
		self;
	},

);