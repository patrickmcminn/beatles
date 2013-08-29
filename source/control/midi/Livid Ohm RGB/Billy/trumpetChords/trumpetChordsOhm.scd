/*
Wednesday, August 28th 2013
trumpetChordsOhm.scd
prm
*/

~billyOhm.trumpetChords = (

	main: 3,
	toggle: 11,
	playChords: 19,

	record: [4, 12, 20, 5, 13, 21],

	vol: 15,

	makeOSC: { | self |
		OSCdef(\billyTrumpetChordsOhm, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \trumpetChordsTop } { self.spawn(val); }
			{ id == \trumpetChordsToggle } { self.toggleOhm(val); }
			{ id == \trumpetChordsPlay } { self.playOhm(val); }
		}, \billyControl, ~scLang);

		OSCdef(\billyTrumpetChordsOhmRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case

			{ id == \trumpetChordsVol } { if ( val == 1, { self.makeVol; }) }
			{ id == \trumpetChordsToggle } { if ( val == 1, { self.makeToggleMIDI; }) }
			{ id == \trumpetChordsPlay } { if( val == 1, { self.makePlayMIDI; }) }
			{ id == \trumpetChordsRecord } { if( val == 1, { self.makeRecordMIDI; }) }

		}, \restoreOhmBilly, ~scLang);

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
		//self.makeToggle;
		self.makePlay;
		self.makeRecord;
		self;
	},

	killButtons: { | self |
		self.topOhm(0);
		//self.killToggle;
		self.killPlay;
		self.killRecord;
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
				~restoreOhm.billy.page.put(self.main, \purple);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.billy.page.put(self.main, \red);
			}
		);
		self;
	},

	/*
	makeToggle: { | self |
		~ohm.turnGreen(self.toggle);
		~restoreOhm.billy.page.put(self.toggle, \green);
		self.makeToggleMIDI;
		~restoreOhm.billy.trumpetChordsToggle = 1;
		self;
	},

	killToggle: { | self |
		~ohm.turnOff(self.toggle);
		~restoreOhm.billy.page.put(self.toggle, \off);
		self.killToggleMIDI;
		~restoreOhm.billy.trumpetChordsToggle = 0;
		self;
	},

	makeToggleMIDI: { | self |
		MIDIdef.noteOn(\trumpetChordsToggle, {
			~billy.trumpetChords.toggleMute;
			~scLang.sendMsg(\billyControl, \trumpetChordsToggle,  ~billy.trumpetChords.muteState);
		}, self.toggle);
		self;
	},

	killToggleMIDI: { | self |
		MIDIdef(\trumpetChordsToggle).free;
		self;
	},

	toggleOhm: { | self, val |
		if( val == 1,
			{
				~ohm.turnGreen(self.toggle);
				~restoreOhm.billy.page.put(self.toggle, \green);
			},
			{
				~ohm.turnRed(self.toggle);
				~restoreOhm.billy.page.put(self.toggle, \red);
			}
		);
		self;
	},
	*/

	makeRecord: { | self |
		self.record.do({ | led |
			~ohm.turnCyan(led);
			~restoreOhm.billy.page.put(led, \cyan);
		});
		self.makeRecordMIDI;
		~restoreOhm.billy.trumpetChordsRecord = 1;
		self;
	},

	killRecord: { | self |
		self.record.do({ | led |
			~ohm.turnOff(led);
			~restoreOhm.billy.page.put(led, \off);
		});
		self.killRecordMIDI;
		~restoreOhm.billy.trumpetChordsRecord = 0;
		self;
	},

	makeRecordMIDI: { | self |
		self.record.do({ | led, i |
			MIDIdef.noteOn("record" ++ i, { ~billy.trumpetChords.recordTpt(i); }, led);
		});
		self;
	},

	killRecordMIDI: { | self |
		self.record.do({ | led, i |
			MIDIdef("record" ++ i).free;
		});
		self;
	},

	makePlay: { | self |
		~ohm.turnBlue(self.playChords);
		~restoreOhm.billy.page.put(self.playChords, \blue);
		self.makePlayMIDI;
		~restoreOhm.billy.trumpetChordsPlay = 1;
		self;
	},

	killPlay: { | self |
		~ohm.turnOff(self.playChords);
		~restoreOhm.billy.page.put(self.playChords, \off);
		self.killPlayMIDI;
		~restoreOhm.billy.trumpetChordsPlay = 0;
		self;
	},

	makePlayMIDI: { | self |
		MIDIdef.noteOn(\trumpetChordsPlay, {
			~billy.trumpetChords.togglePattern;
			~scLang.sendMsg(\billyControl, \trumpetChordsPlay, ~billy.trumpetChords.playState);
		}, self.playChords);
		self;
	},

	killPlayMIDI: { | self |
		MIDIdef(\trumpetChordsPlay).free;
		self;
	},

	playOhm: { | self, val |
		if( val == 1,
			{
				~ohm.turnGreen(self.playChords);
				~restoreOhm.billy.page.put(self.playChords, \green);
			},
			{
				~ohm.turnRed(self.playChords);
				~restoreOhm.billy.page.put(self.playChords, \red);
			}
		);
		self;
	},

	makeVol: { | self |
		MIDIdef.cc(\trumpetChordsVol, { | val |
			var amp = val.linlin(0, 127, 0, 1);
			~billy.trumpetChords.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.billy.trumpetChordsVol = 1;
		self;
	},

	killVol: { | self |
		MIDIdef(\trumpetChordsVol).free;
		~restoreOhm.billy.trumpetChordsVol = 0;
		self;
	},

	makeDials: { | self |
		self;
	},

	killDials: { | self |
		self;
	},

);
