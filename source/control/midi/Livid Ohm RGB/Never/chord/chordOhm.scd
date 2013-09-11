/*
Wednesday, September 4th 2013
chordOhm.scd
prm
*/

~neverOhm.chord = (

	main: 47,
	gran: 55,
	chord: 63,

	vol: 14,

	makeOSC: { | self |
		OSCdef(\neverChordOhm, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \chordTop } { self.spawn(val); }
			{ id == \chordGran } { self.granOhm(val); }
			{ id == \chordPlay } { self.chordOhm(val); }
		}, \neverControl, ~scLang);

		OSCdef(\neverChordOhmRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case

			{ id == \chordVol } { if ( val == 1, { self.makeVol; }) }
			{ id == \chordGran} { if ( val == 1, { self.makeGranMIDI; }) }
			{ id == \chordPlay } { if ( val == 1, { self.makeChordMIDI; }) }

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
		self.makeGran;
		self.makeChord;
		self;
	},

	killButtons: { | self |
		self.topOhm(0);
		self.killGran;
		self.killChord;
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
				~restoreOhm.never.page.put(self.main, \green);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.never.page.put(self.main, \red);
			}
		);
		self;
	},

	makeGran: { | self |
		~ohm.turnYellow(self.gran);
		~restoreOhm.never.page.put(self.gran, \yellow);
		self.makeGranMIDI;
		~restoreOhm.never.chordGran = 1;
		self;
	},

	killGran: { | self |
		~ohm.turnOff(self.gran);
		~restoreOhm.never.page.put(self.gran, \off);
		self.killGranMIDI;
		~restoreOhm.never.chordGran = 0;
		self;
	},

	makeGranMIDI: { | self |
		MIDIdef.noteOn(\neverChordGran, {
			~never.chord.toggleChordGranulation;
			~scLang.sendMsg(\neverControl, \chordGran, ~never.chord.playState);
		}, self.gran);
		self;
	},

	killGranMIDI: { | self |
		MIDIdef(\neverChordGran).free;
		self;
	},

	granOhm: { | self, val |
		if( val == 1,
			{ ~ohm.turnGreen(self.gran); ~restoreOhm.never.page.put(self.gran, \green); },
			{ ~ohm.turnRed(self.gran); ~restoreOhm.never.page.put(self.gran, \red); }
		);
		self;
	},

	makeChord: { | self |
		~ohm.turnWhite(self.chord);
		~restoreOhm.never.page.put(self.chord, \white);
		self.makeChordMIDI;
		~restoreOhm.never.chordPlay = 1;
		self;
	},

	killChord: { | self |
		~ohm.turnOff(self.chord);
		~restoreOhm.never.page.put(self.chord, \off);
		self.killChordMIDI;
		~restoreOhm.never.chordPlay = 0;
		self;
	},

	makeChordMIDI: { | self |
		MIDIdef.noteOn(\neverPlayChord, {
			~never.chord.playChord;
			~scLang.sendMsg(\neverControl, \chordPlay, 1);
		}, self.chord);
		self;
	},

	killChordMIDI: { | self |
		MIDIdef(\neverPlayChord).free;
		self;
	},

	chordOhm: { | self, val |
		if( val == 1, { ~ohm.turnGreen(self.chord) });
		self;
	},

	makeVol: { | self |
		MIDIdef.cc(\chordVol, { | val |
			var amp = val.linlin(0, 127, 0, 1.5);
			~never.chord.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.never.chordVol = 1;
		self;

	},

	killVol: { | self |
		MIDIdef(\chordVol).free;
		~restoreOhm.never.chordVol = 0;
		self;
	},

	makeDials: { | self |
		self;
	},

	killDials: { | self |
		self;
	},

);