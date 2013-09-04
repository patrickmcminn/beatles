/*
Wednesday, September 4th 2013
fifteenKOhmscd
prm
*/

~neverOhm.tptAccomp = (

	main: 1,
	playPattern: 9,
	destroy: 17,
	recordArray: [2, 10, 18, 26, 34, 42, 50, 58, 3],
	recordedArray: Array.fill(9, 0),


	vol: 22,

	makeOSC: { | self |
		OSCdef(\neverTptAccompOhm, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \tptAccompTop } { self.spawn(val); }
			{ id == \tptAccompNum } { self.sequencer(val); }
			{ id == \tptAccompPlay } { self.playOhm(val); }
			{ id == \tptAccompDestroy } { self.destroyOhm(val); }

		}, \neverControl, ~scLang);

		OSCdef(\neverTptAccompOhmRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \tptAccompVol } { if ( val == 1, { self.makeVol; }) }
			{ id == \tptAccompPlay } { if ( val == 1, { self.makePlayPatternMIDI; }) }
			{ id == \tptAccompDestroy } { if ( val == 1, { self.makeDestroyMIDI; }) }
			{ id == \tptAccompRecord } { if( val == 1, { self.makeRecordMIDI; }) }

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
		self.makePlayPattern;
		self.makeDestroy;
		self.makeRecord;
		self;
	},

	killButtons: { | self |
		self.topOhm(0);
		self.killPlayPattern;
		self.killDestroy;
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

	sequencer: { | self, val |
		self.recordArray.do({ | led, i |
			if( self.recordedArray[i] == 1,
				{ ~ohm.turnBlue(led); ~restoreOhm.never.page.put(led, \blue); },
				{ ~ohm.turnCyan(led); ~restoreOhm.never.page.put(led, \cyan); }
			)
		});
		~ohm.turnGreen(self.recordArray[val]);
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

	makePlayPattern: { | self |
		~ohm.turnPurple(self.playPattern);
		~restoreOhm.never.page.put(self.playPattern, \purple);
		self.makePlayPatternMIDI;
		~restoreOhm.never.tptAccompPlay = 1;
		self;
	},

	killPlayPattern: { | self |
		~ohm.turnOff(self.playPattern);
		~restoreOhm.never.page.put(self.playPattern, \off);
		self.killPlayPatternMIDI;
		~restoreOhm.never.tptAccompPlay = 0;
		self;
	},

	makePlayPatternMIDI: { | self |
		MIDIdef.noteOn(\neverTptAccompPlay, {
			~never.tptAccomp.toggleAccomp;
			~scLang.sendMsg(\neverControl, \tptAccompPlay, ~never.tptAccomp.playState);
		}, self.playPattern);
		self;
	},

	killPlayPatternMIDI: { | self |
		MIDIdef(\neverTptAccompPlay).free;
		self;
	},

	playOhm: { | self, val |
		if( val == 1,
			{ ~ohm.turnGreen(self.playPattern); ~restoreOhm.never.page.put(self.playPattern, \green); },
			{ ~ohm.turnRed(self.playPattern); ~restoreOhm.never.page.put(self.playPattern, \red); }
		);
		self;
	},

	makeDestroy: { | self |
		~ohm.turnCyan(self.destroy);
		~restoreOhm.never.page.put(self.destroy, \cyan);
		self.makeDestroyMIDI;
		~restoreOhm.never.tptAccompDestroy = 1;
		self;
	},

	killDestroy: { | self |
		~ohm.turnOff(self.destroy);
		~restoreOhm.never.page.put(self.destroy, \off);
		self.killDestroyMIDI;
		~restoreOhm.never.tptAccompDestroy = 0;
		self;
	},

	makeDestroyMIDI: { | self |
		MIDIdef.noteOn(\tptAccompDestroyOn, {
			~never.tptAccomp.destroyPatterns;
			~scLang.sendMsg(\neverControl, \tptAccompDestroy, 1);
		}, self.destroy);
		MIDIdef.noteOff(\tptAccompDestroyOff, {
			~never.tptAccomp.resetPatterns;
			~scLang.sendMsg(\neverControl, \tptAccompDestroy, 0);
		}, self.destroy);
		self;
	},

	killDestroyMIDI: { | self |
		MIDIdef(\tptAccompDestroyOn).free;
		MIDIdef(\tptAccompDestroyOff).free;
		self;
	},

	destroyOhm: { | self, val |
		if( val == 1,
			{ ~ohm.turnWhite(self.destroy); },
			{ ~ohm.turnCyan(self.destroy); });
		self;
	},

	makeRecord: { | self |
		self.recordArray.do({ | led, i |
			~ohm.turnCyan(led);
			~restoreOhm.never.page.put(led, \cyan);
		});
		self.makeRecordMIDI;
		~restoreOhm.never.tptAccompRecord = 1;
		self;
	},

	killRecord: { | self |
		self.recordArray.do({ | led |
			~ohm.turnOff(led);
			~restoreOhm.never.page.put(led, \off);
		});
		self.killRecordMIDI;
		self.recordedArray.fill(0);
		~restoreOhm.never.tptAccompRecord = 0;
		self;
	},

	makeRecordMIDI: { | self |
		self.recordArray.do({ | led, i |
			MIDIdef.noteOn(("tptAccompRecord" ++ (i + 1)).asSymbol, {
				~never.tptAccomp.recordTpt(i);
				~ohm.turnPurple(led);
				self.recordedArray[i] = 1;
			}, led);
		});
		self;
	},

	killRecordMIDI: { | self |
		self.recordArray.do({ | led, i |
			MIDIdef.noteOn(("tptAccompRecord" ++ (i + 1)).asSymbol).free;
		});
		self;
	},

	makeVol: { | self |
		MIDIdef.cc(\tptAccompVol, { | val |
			var amp = val.linlin(0, 127, 0, 1);
			~never.tptAccomp.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.never.tptAccompVol = 1;
		self;

	},

	killVol: { | self |
		MIDIdef(\ftptAccompVol).free;
		~restoreOhm.never.tptAccompVol = 0;
		self;
	},

	makeDials: { | self |
		self;
	},

	killDials: { | self |
		self;
	},

);