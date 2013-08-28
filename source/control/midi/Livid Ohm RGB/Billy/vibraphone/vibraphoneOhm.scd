/*
Wednesday, August 28th 2013
vibraphoneOhm.scd
prm
*/

~billyOhm.vibraphone = (

	main: 1,
	record: 9,
	recordFake: 63,
	playChords: 17,
	granOrig: 2,
	gran1: 10,
	gran2: 18,
	gran3: 26,

	granVol: 23,
	playVol: 22,

	makeOSC: { | self |
		OSCdef(\billyVibraphoneOhm, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \vibraphoneTop } { self.spawn(val); }
			{ id == \vibraphoneRecord } { self.recordOhm(val); }
			{ id == \vibraphoneRecordFake } { self.recordFakeOhm(val); }
			{ id == \vibraphonePlay } { self.playOhm(val); }
			{ id == \vibraphoneGranOrig } { self.granOrigOhm(val); }
			{ id == \vibraphoneGran1 } { self.gran1Ohm(val); }
			{ id == \vibraphoneGran2 } { self.gran2Ohm(val); }
			{ id == \vibraphoneGran3 } { self.gran3Ohm(val); }
		}, \billyControl, ~scLang);

		OSCdef(\billyVibraphoneOhmRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case

			{ id == \vibraphoneFaders } { if ( val == 1, { self.makeFaders; }) }
			{ id == \vibraphoneRecord } { if ( val == 1, { self.makeRecordMIDI; }) }
			{ id == \vibraphoneRecordFake } { if ( val == 1, { self.makeRecordFakeMIDI; }) }
			{ id == \vibraphonePlay } { if ( val == 1, { self.makePlayMIDI; }) }
			{ id == \vibraphoneGranOrig } { if ( val == 1, { self.makeGranOrigMIDI; }) }
			{ id == \vibraphoneGran1 } { if ( val == 1, { self.makeGran1MIDI; }) }
			{ id == \vibraphoneGran2 } { if ( val == 1, { self.makeGran2MIDI; }) }
			{ id == \vibraphoneGran3 } { if ( val == 1, { self.makeGran3MIDI; }) }

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
		self.makeRecord;
		self.makeRecordFake;
		self.makePlay;
		self.makeGranOrig;
		self.makeGran1;
		self.makeGran2;
		self.makeGran3;
		self;
	},

	killButtons: { | self |
		self.topOhm(0);
		self.killRecord;
		self.killRecordFake;
		self.killPlay;
		self.killGranOrig;
		self.killGran1;
		self.killGran2;
		self.killGran3;
		self;
	},

	makeFaders: { | self |
		self.makeGranVol;
		self.makePlayVol;
		~restoreOhm.billy.vibraphoneFaders = 1;
		self;
	},

	killFaders: { | self |
		self.killGranVol;
		self.killPlayVol;
		~restoreOhm.billy.vibraphoneFaders = 0;
		self;
	},

	topOhm: { | self, val |
		if( val == 1,
			{
				~ohm.turnCyan(self.main);
				~restoreOhm.billy.page.put(self.main, \cyan);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.billy.page.put(self.main, \red);
			}
		);
		self;
	},

	makeRecord: { | self |
		~ohm.turnRed(self.record);
		~restoreOhm.billy.page.put(self.record, \red);
		self.makeRecordMIDI;
		~restoreOhm.billy.vibraphoneRecord = 1;
		self;
	},

	killRecord: { | self |
		~ohm.turnOff(self.record);
		~restoreOhm.billy.page.put(self.record, \off);
		self.killRecordMIDI;
		~restoreOhm.billy.vibraphoneRecord = 0;
		self;
	},

	makeRecordMIDI: { | self |
		MIDIdef.noteOn(\vibraphoneRecord, { ~billy.vibraphone.recordVibraphone; }, self.record);
		self;
	},

	killRecordMIDI: { | self |
		MIDIdef(\vibraphoneRecord).free;
		self;
	},

	makeRecordFake: { | self |
		~ohm.turnRed(self.recordFake);
		~restoreOhm.billy.page.put(self.recordFake, \red);
		self.makeRecordFakeMIDI;
		~restoreOhm.billy.vibraphoneRecordFake = 1;
		self;
	},

	killRecordFake: { | self |
		~ohm.turnOff(self.recordFake);
		~restoreOhm.billy.page.put(self.recordFake, \off);
		self.killRecordFakeMIDI;
		~restoreOhm.billy.vibraphoneRecordFake = 0;
		self;
	},

	makeRecordFakeMIDI: { | self |
		MIDIdef.noteOn(\vibraphoneRecordFake, {
			~billy.vibraphone.toggleFakeBuffer;
			~scLang.sendMsg(\billyControl, \vibraphoneRecordFake, ~billy.vibraphone.bufferState);
		}, self.recordFake);
		self;
	},

	killRecordFakeMIDI: { | self |
		MIDIdef(\vibraphoneRecordFake).free;
		self;
	},

	recordFakeOhm: { | self, val |
		if( val == 0,
			{
				~ohm.turnGreen(self.recordFake);
				~restoreOhm.billy.page.put(self.recordFake, \green);
			},

			{
				~ohm.turnRed(self.recordFake);
				~restoreOhm.billy.page.put(self.recordFake, \red);
			}
		);
		self;
	},

	makePlay: { | self |
		~ohm.turnBlue(self.playChords);
		~restoreOhm.billy.page.put(self.playChords, \blue);
		self.makePlayMIDI;
		~restoreOhm.billy.vibraphonePlay = 1;
		self;
	},

	killPlay: { | self |
		~ohm.turnOff(self.playChords);
		~restoreOhm.billy.page.put(self.playChords, \off);
		self.killPlayMIDI;
		~restoreOhm.billy.vibraphonePlay = 0;
		self;
	},

	makePlayMIDI: { | self |
		MIDIdef.noteOn(\vibraphonePlay, {
			~billy.vibraphone.togglePattern;
			~scLang.sendMsg(\billyControl, \vibraphonePlay, ~billy.vibraphone.playState);
		}, self.playChords);
		self;
	},

	killPlayMIDI: { | self |
		MIDIdef(\vibraphonePlay).free;
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

	makeGranOrig: { | self |
		~ohm.turnWhite(self.granOrig);
		~restoreOhm.billy.page.put(self.granOrig, \white);
		self.makeGranOrigMIDI;
		~restoreOhm.billy.vibraphoneGranOrig = 1;
		self;
	},

	killGranOrig: { | self |
		~ohm.turnOff(self.granOrig);
		~restoreOhm.billy.page.put(self.granOrig, \off);
		self.killGranOrigMIDI;
		~restoreOhm.billy.vibraphoneGranOrig = 0;
		self;
	},

	makeGranOrigMIDI: { | self |
		MIDIdef.noteOn(\vibraphoneGranOrig, {
			~billy.vibraphone.toggleOrig;
			~scLang.sendMsg(\billyControl, \vibraphoneGranOrig, ~billy.vibraphone.origState);
		}, self.granOrig);
		self;
	},

	killGranOrigMIDI: { | self |
		MIDIdef(\vibraphoneGranOrig).free;
		self;
	},

	granOrigOhm: { | self, val |
		if( val == 1,
			{
				~ohm.turnGreen(self.granOrig);
				~restoreOhm.billy.page.put(self.granOrig, \green);
			},
			{
				~ohm.turnRed(self.granOrig);
				~restoreOhm.billy.page.put(self.granOrig, \red);
			}
		);
		self;
	},

	makeGran1: { | self |
		~ohm.turnBlue(self.gran1);
		~restoreOhm.billy.page.put(self.gran1, \blue);
		self.makeGran1MIDI;
		~restoreOhm.billy.vibraphoneGran1 = 1;
		self;
	},

	killGran1: { | self |
		~ohm.turnOff(self.gran1);
		~restoreOhm.billy.page.put(self.gran1, \off);
		self.killGran1MIDI;
		~restoreOhm.billy.vibraphoneGran1 = 0;
		self;
	},

	makeGran1MIDI: { | self |
		MIDIdef.noteOn(\vibraphoneGran1, {
			~billy.vibraphone.toggleC;
			~scLang.sendMsg(\billyControl, \vibraphoneGran1, ~billy.vibraphone.cState);
		}, self.gran1);
		self;
	},

	killGran1MIDI: { | self |
		MIDIdef(\vibraphoneGran1).free;
		self;
	},

	gran1Ohm: { | self, val |
		if( val == 1,
			{
				~ohm.turnGreen(self.gran1);
				~restoreOhm.billy.page.put(self.gran1, \green);
			},
			{
				~ohm.turnRed(self.gran1);
				~restoreOhm.billy.page.put(self.gran1, \red);
			}
		);
		self;
	},

	makeGran2: { | self |
		~ohm.turnCyan(self.gran2);
		~restoreOhm.billy.page.put(self.gran2, \cyan);
		self.makeGran2MIDI;
		~restoreOhm.billy.vibraphoneGran2 = 1;
		self;
	},

	killGran2: { | self |
		~ohm.turnOff(self.gran2);
		~restoreOhm.billy.page.put(self.gran2, \off);
		self.killGran2MIDI;
		~restoreOhm.billy.vibraphoneGran2 = 0;
		self;
	},

	makeGran2MIDI: { | self |
		MIDIdef.noteOn(\vibraphoneGran2, {
			~billy.vibraphone.toggleD;
			~scLang.sendMsg(\billyControl, \vibraphoneGran2, ~billy.vibraphone.dState);
		}, self.gran2);
		self;
	},

	killGran2MIDI: { | self |
		MIDIdef(\vibraphoneGran2).free;
		self;
	},

	gran2Ohm: { | self, val |
		if( val == 1,
			{
				~ohm.turnGreen(self.gran2);
				~restoreOhm.billy.page.put(self.gran2, \green);
			},
			{
				~ohm.turnRed(self.gran2);
				~restoreOhm.billy.page.put(self.gran2, \red);
			}
		);
		self;
	},

	makeGran3: { | self |
		~ohm.turnPurple(self.gran3);
		~restoreOhm.billy.page.put(self.gran3, \purple);
		self.makeGran3MIDI;
		~restoreOhm.billy.vibraphoneGran3 = 1;
		self;
	},

	killGran3: { | self |
		~ohm.turnOff(self.gran3);
		~restoreOhm.billy.page.put(self.gran3, \off);
		self.killGran3MIDI;
		~restoreOhm.billy.vibraphoneGran3 = 0;
		self;
	},

	makeGran3MIDI: { | self |
		MIDIdef.noteOn(\vibraphoneGran3, {
			~billy.vibraphone.toggleE;
			~scLang.sendMsg(\billyControl, \vibraphoneGran3, ~billy.vibraphone.eState);
		}, self.gran3);
		self;
	},

	killGran3MIDI: { | self |
		MIDIdef(\vibraphoneGran3).free;
		self;
	},

	gran3Ohm: { | self, val |
		if( val == 1,
			{
				~ohm.turnGreen(self.gran3);
				~restoreOhm.billy.page.put(self.gran3, \green);
			},
			{
				~ohm.turnRed(self.gran3);
				~restoreOhm.billy.page.put(self.gran3, \red);
			}
		);
		self;
	},

	makeGranVol: { | self |
		MIDIdef.cc(\vibraphoneGranVol, { | val |
			var amp = val.linlin(0, 127, 0, 1);
			~billy.vibraphone.granFader.set(\amp, amp);
		}, self.granVol);
		self;
	},

	killGranVol: { | self |
		MIDIdef(\vibraphoneGranVol).free;
		self;
	},

	makePlayVol: { | self |
		MIDIdef.cc(\vibraphonePlayVol, { | val |
			var amp = val.linlin(0, 127, 0, 1);
			~billy.vibraphone.patternFader.set(\amp, amp);
		}, self.playVol);
		self;
	},

	killPlayVol: { | self |
		MIDIdef(\vibraphonePlayVol).free;
		self;
	},

	makeDials: { | self |
		self;
	},

	killDials: { | self |
		self;
	},

);
