/*
Thursday, August 29th 2013
pianoChordsOhm.scd
prm
*/

~whereOhm.pianoChords = (

	main: 0,
	record: [8, 16],
	fake: 63,

	playChords: [1, 10, 19, 27, 34, 41],

	vol: 15,

	makeOSC: { | self |
		OSCdef(\wherePianoChordsOhm, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \pianoChordsTop } { self.spawn(val); }

			{ id == \pianoChord11 } { self.chord11Ohm(val); }
			{ id == \pianoChord12 } { self.chord12Ohm(val); }
			{ id == \pianoChord13 } { self.chord13Ohm(val); }

			{ id == \pianoChord21 } { self.chord21Ohm(val); }
			{ id == \pianoChord22 } { self.chord22Ohm(val); }
			{ id == \pianoChord23 } { self.chord23Ohm(val); }

			{ id == \pianoChordsFakeBuffers } { self.fakeBuffersOhm(val) }

		}, \whereControl, ~scLang);

		OSCdef(\wherePianoChordsOhmRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case

			{ id == \pianoChordsVol } { if ( val == 1, { self.makeVol; }) }

			{ id == \pianoChordsRecord } { if ( val == 1, { self.makeRecordMIDI; }) }

			{ id == \pianoChordsFakeBuffers } { if ( val == 1, { self.makeFakeBuffersMIDI; }) }

			{ id == \pianoChord11 } { if( val == 1, { self.makeChord11MIDI; }) }
			{ id == \pianoChord12 } { if( val == 1, { self.makeChord12MIDI; }) }
			{ id == \pianoChord13 } { if( val == 1, { self.makeChord13MIDI; }) }

			{ id == \pianoChord21 } { if( val == 1, { self.makeChord21MIDI; }) }
			{ id == \pianoChord22 } { if( val == 1, { self.makeChord22MIDI; }) }
			{ id == \pianoChord23 } { if( val == 1, { self.makeChord23MIDI; }) }


		}, \restoreOhmWhere, ~scLang);

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
		self.makeRecord;
		self.makeFakeBuffers;
		self;
	},

	killButtons: { | self |
		self.topOhm(0);
		self.killPlay;
		self.killRecord;
		self.killFakeBuffers;
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
				~restoreOhm.where.page.put(self.main, \purple);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.where.page.put(self.main, \red);
			}
		);
		self;
	},

	makeRecord: { | self |
		self.record.do({ | led |
			~ohm.turnRed(led);
			~restoreOhm.where.page.put(led, \red);
		});
		self.makeRecordMIDI;
		~restoreOhm.where.pianoChordsRecord = 1;
		self;
	},

	killRecord: { | self |
		self.record.do({ | led |
			~ohm.turnOff(led);
			~restoreOhm.where.page.put(led, \off);
		});
		self.killRecordMIDI;
		~restoreOhm.where.pianoChordsRecord = 0;
		self;
	},

	makeRecordMIDI: { | self |
		self.record.do({ | led, i |
			MIDIdef.noteOn("record" ++ i, { ~where.pianoChords.recordPiano(i); }, led);
		});
		self;
	},

	killRecordMIDI: { | self |
		self.record.do({ | led, i |
			MIDIdef("record" ++ i).free;
		});
		self;
	},

	makeFakeBuffers: { | self |
		~ohm.turnRed(self.fake);
		~restoreOhm.where.page.put(self.fake, \red);
		self.makeFakeBuffersMIDI;
		~restoreOhm.where.pianoChordsFakeBuffer = 1;
		self;
	},

	killFakeBuffers: { | self |
		~ohm.turnOff(self.fake);
		~restoreOhm.where.page.put(self.fake, \off);
		self.killFakeBuffersMIDI;
		~restoreOhm.where.pianoChordsfakeBuffer = 0;
		self;
	},

	makeFakeBuffersMIDI: { | self |
		MIDIdef.noteOn(\pianoChordsFakeBuffers, {
			~where.pianoChords.toggleFakeBuffers;
			~scLang.sendMsg(\whereControl, \pianoChordsFakeBuffers, ~where.pianoChords.bufferState);
		}, self.fake);
		self;
	},

	killFakeBuffersMIDI: { | self |
		MIDIdef(\pianoChordsFakeBuffers).free;
		self;
	},

	fakeBuffersOhm: { | self, val |
		if ( val == 1,
			{
				~ohm.turnRed(self.fake);
				~restoreOhm.where.page.put(self.fake, \red);
			},
			{
				~ohm.turnGreen(self.fake);
				~restoreOhm.where.page.put(self.fake, \green);
			}
		);
		self;
	},



	makePlay: { | self |
		self.makeChord11;
		self.makeChord12;
		self.makeChord13;
		self.makeChord21;
		self.makeChord22;
		self.makeChord23;
		self;
	},

	killPlay: { | self |
		self.killChord11;
		self.killChord12;
		self.killChord13;
		self.killChord21;
		self.killChord22;
		self.killChord23;
		self;
	},

	makeChord11: { | self |
		~ohm.turnBlue(self.playChords[0]);
		~restoreOhm.where.page.put(self.playChords[0], \blue);
		self.makeChord11MIDI;
		~restoreOhm.where.pianoChord11 = 1;
		self;
	},

	killChord11: { | self |
		~ohm.turnOff(self.playChords[0]);
		~restoreOhm.where.page.put(self.playChords[0], \off);
		self.killChord11MIDI;
		~restoreOhm.where.pianoChord11 = 0;
		self;
	},

	makeChord11MIDI: { | self |
		MIDIdef.noteOn(\pianoChord11Play, {
			~where.pianoChords.playChord11;
			~scLang.sendMsg(\whereControl, \pianoChord11, ~where.pianoChords.chord11State);
		}, self.playChords[0]);
		MIDIdef.noteOff(\pianoChord11Stop, {
			~where.pianoChords.stopChord11;
			~scLang.sendMsg(\whereControl, \pianoChord11, ~where.pianoChords.chord11State);
		}, self.playChords[0]);
		self;
	},

	killChord11MIDI: { | self |
		MIDIdef(\pianoChord11Play).free;
		MIDIdef(\pianoChord11Stop).free;
		self;
	},

	chord11Ohm: { | self, val |
		if( val == 1, { ~ohm.turnGreen(self.playChords[0]) }, { ~ohm.turnBlue(self.playChords[0]) });
		self;
	},

	makeChord12: { | self |
		~ohm.turnCyan(self.playChords[1]);
		~restoreOhm.where.page.put(self.playChords[1], \cyan);
		self.makeChord12MIDI;
		~restoreOhm.where.pianoChord12 = 1;
		self;
	},

	killChord12: { | self |
		~ohm.turnOff(self.playChords[1]);
		~restoreOhm.where.page.put(self.playChords[1], \off);
		self.killChord12MIDI;
		~restoreOhm.where.pianoChord12 = 0;
		self;
	},

	makeChord12MIDI: { | self |
		MIDIdef.noteOn(\pianoChord12Play, {
			~where.pianoChords.playChord12;
			~scLang.sendMsg(\whereControl, \pianoChord12, ~where.pianoChords.chord12State);
		}, self.playChords[1]);
		MIDIdef.noteOff(\pianoChord12Stop, {
			~where.pianoChords.stopChord12;
			~scLang.sendMsg(\whereControl, \pianoChord12, ~where.pianoChords.chord12State);
		}, self.playChords[1]);
		self;
	},

	killChord12MIDI: { | self |
		MIDIdef(\pianoChord12Play).free;
		MIDIdef(\pianoChord12Stop).free;
		self;
	},

	chord12Ohm: { | self, val |
		if( val == 1, { ~ohm.turnGreen(self.playChords[1]) }, { ~ohm.turnCyan(self.playChords[1]) });
		self;
	},

	makeChord13: { | self |
		~ohm.turnYellow(self.playChords[2]);
		~restoreOhm.where.page.put(self.playChords[2], \yellow);
		self.makeChord13MIDI;
		~restoreOhm.where.pianoChord13 = 1;
		self;
	},

	killChord13: { | self |
		~ohm.turnOff(self.playChords[2]);
		~restoreOhm.where.page.put(self.playChords[2], \off);
		self.killChord13MIDI;
		~restoreOhm.where.pianoChord13 = 0;
		self;
	},

	makeChord13MIDI: { | self |
		MIDIdef.noteOn(\pianoChord13Play, {
			~where.pianoChords.playChord13;
			~scLang.sendMsg(\whereControl, \pianoChord13, ~where.pianoChords.chord13State);
		}, self.playChords[2]);
		MIDIdef.noteOff(\pianoChord13Stop, {
			~where.pianoChords.stopChord13;
			~scLang.sendMsg(\whereControl, \pianoChord13, ~where.pianoChords.chord13State);
		}, self.playChords[2]);
		self;
	},

	killChord13MIDI: { | self |
		MIDIdef(\pianoChord13Play).free;
		MIDIdef(\pianoChord13Stop).free;
		self;
	},

	chord13Ohm: { | self, val |
		if( val == 1, { ~ohm.turnGreen(self.playChords[2]) }, { ~ohm.turnYellow(self.playChords[2]) });
		self;
	},

	makeChord21: { | self |
		~ohm.turnWhite(self.playChords[3]);
		~restoreOhm.where.page.put(self.playChords[3], \white);
		self.makeChord21MIDI;
		~restoreOhm.where.pianoChord21 = 1;
		self;
	},

	killChord21: { | self |
		~ohm.turnOff(self.playChords[3]);
		~restoreOhm.where.page.put(self.playChords[3], \off);
		self.killChord21MIDI;
		~restoreOhm.where.pianoChord21 = 0;
		self;
	},

	makeChord21MIDI: { | self |
		MIDIdef.noteOn(\pianoChord21Play, {
			~where.pianoChords.playChord21;
			~scLang.sendMsg(\whereControl, \pianoChord21, ~where.pianoChords.chord21State);
		}, self.playChords[3]);
		MIDIdef.noteOff(\pianoChord21Stop, {
			~where.pianoChords.stopChord21;
			~scLang.sendMsg(\whereControl, \pianoChord21, ~where.pianoChords.chord21State);
		}, self.playChords[3]);
		self;
	},

	killChord21MIDI: { | self |
		MIDIdef(\pianoChord21Play).free;
		MIDIdef(\pianoChord21Stop).free;
		self;
	},

	chord21Ohm: { | self, val |
		if( val == 1, { ~ohm.turnGreen(self.playChords[3]) }, { ~ohm.turnWhite(self.playChords[3]) });
		self;
	},

	makeChord22: { | self |
		~ohm.turnPurple(self.playChords[4]);
		~restoreOhm.where.page.put(self.playChords[4], \purple);
		self.makeChord22MIDI;
		~restoreOhm.where.pianoChord22 = 1;
		self;
	},

	killChord22: { | self |
		~ohm.turnOff(self.playChords[4]);
		~restoreOhm.where.page.put(self.playChords[4], \off);
		self.killChord22MIDI;
		~restoreOhm.where.pianoChord22 = 0;
		self;
	},

	makeChord22MIDI: { | self |
		MIDIdef.noteOn(\pianoChord22Play, {
			~where.pianoChords.playChord22;
			~scLang.sendMsg(\whereControl, \pianoChord22, ~where.pianoChords.chord22State);
		}, self.playChords[4]);
		MIDIdef.noteOff(\pianoChord22Stop, {
			~where.pianoChords.stopChord22;
			~scLang.sendMsg(\whereControl, \pianoChord22, ~where.pianoChords.chord22State);
		}, self.playChords[4]);
		self;
	},

	killChord22MIDI: { | self |
		MIDIdef(\pianoChord22Play).free;
		MIDIdef(\pianoChord22Stop).free;
		self;
	},

	chord22Ohm: { | self, val |
		if( val == 1, { ~ohm.turnGreen(self.playChords[4]) }, { ~ohm.turnPurple(self.playChords[4]) });
		self;
	},

	makeChord23: { | self |
		~ohm.turnBlue(self.playChords[5]);
		~restoreOhm.where.page.put(self.playChords[5], \blue);
		self.makeChord23MIDI;
		~restoreOhm.where.pianoChord23 = 1;
		self;
	},

	killChord23: { | self |
		~ohm.turnOff(self.playChords[5]);
		~restoreOhm.where.page.put(self.playChords[5], \off);
		self.killChord23MIDI;
		~restoreOhm.where.pianoChord23 = 0;
		self;
	},

	makeChord23MIDI: { | self |
		MIDIdef.noteOn(\pianoChord23Play, {
			~where.pianoChords.playChord23;
			~scLang.sendMsg(\whereControl, \pianoChord23, ~where.pianoChords.chord23State);
		}, self.playChords[5]);
		MIDIdef.noteOff(\pianoChord23Stop, {
			~where.pianoChords.stopChord23;
			~scLang.sendMsg(\whereControl, \pianoChord23, ~where.pianoChords.chord23State);
		}, self.playChords[5]);
		self;
	},

	killChord23MIDI: { | self |
		MIDIdef(\pianoChord23Play).free;
		MIDIdef(\pianoChord23Stop).free;
		self;
	},

	chord23Ohm: { | self, val |
		if( val == 1, { ~ohm.turnGreen(self.playChords[5]) }, { ~ohm.turnBlue(self.playChords[5]) });
		self;
	},

	makeVol: { | self |
		MIDIdef.cc(\pianoChordsVol, { | val |
			var amp = val.linlin(0, 127, 0, 1);
			~where.pianoChords.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.where.pianoChordsVol = 1;
		self;
	},

	killVol: { | self |
		MIDIdef(\pianoChordsVol).free;
		~restoreOhm.where.pianoChordsVol = 0;
		self;
	},

	makeDials: { | self |
		self;
	},

	killDials: { | self |
		self;
	},

);
