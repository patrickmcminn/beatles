/*
Monday, August 19th 2013
chord.scd
prm
*/

~never.chord = (

	state: 0,
	muteState: 0,
	output: ~mixer.s1,
	playState: 0,
	granAmp: -2.dbamp,

	spawn: { | self |
		if( self.state == 0, { if( ~never.router.state == 1) { self.init; } }, { self.kill; });
		self;
	},

	init: { | self |
		self.makeBuffers;
		self.makeBusses;
		self.makeSynths;
		self.makeGroups;
		self.state = 1;
		self;
	},

	kill: { | self |
		self.killBuffers;
		self.killBusses;
		self.killSynths;
		self.killGroups;
		self.state = 0;
		self;
	},

	makeGroups: { | self |
		self.pianoGroup = Group.new(self.granFader, \addBefore);
		self;
	},

	killGroups: { | self |
		self.pianoGroup.free;
		self;
	},

	makeBuffers: { | self |
		var path = "/Users/patrickmcminn/Documents/Music/Current Work/Patrick McMinn/Great Noise Ensemble/Beatles Concert/Beatles/data/Never Could See Any Other Way/";
		self.chordBuf = Array.fill(8,
			{ | i | Buffer.read(s, path ++ "Chord " ++ (i + 1) ++ "-1.aif"); });
		self.chordShiftBuf = Array.fill(8,
			{ | i | Buffer.read(s, path ++ "Chord " ++ (i + 1) ++ "-2.aif"); });
		self.fullChordBuf = Buffer.read(s, path ++ "Chord.aif");
		self;
	},

	killBuffers: { | self |
		self.chordBuf.do({ | i | i.free; });
		self.chordShiftBuf.do({ | i | i.free; });
		self.fullChordBuf.free;
		self;
	},

	makeBusses: { | self |
		self.granFaderBus = Bus.audio(s, 2);
		self.faderBus = Bus.audio;
		self;
	},

	killBusses: { | self |
		self.granFaderBus.free;
		self.faderBus.free;
		self;
	},

	makeSynths: { | self |
		self.granFader = Synth.tail(~never.router.inGroup, \stereoFader, [\in, self.granFaderBus, \out, ~never.router.in4, \amp, 1]);
		self.fader = Synth(\pan, [\in, self.faderBus, \out, self.ouput], ~group.fx, \addToTail);
		self;
	},

	killSynths: { | self |
		self.granFader.free;
		self.fader.free;
		self;
	},

	playChord: { | self |
		self.chord = Synth(\playBuf,
			[\out, self.faderBus, \bufName, self.fullChordBuf, \sustain, self.fullChordBuf.numFrames/s.sampleRate],
			self.pan, \addBefore);
		self;
	},

	toggleChordGranulation: { | self |
		if( self.playState == 0, { self.granulateChord; }, { self.stopGranulation; });
		self;
	},

	granulateChord: { | self |
		self.chordGran = Array.fill(8, { | i |
			Synth.tail(self.pianoGroup, \freezePlayerSus2,
				[\out, self.granFaderBus, \buffer, self.chordBuf[i], \amp, self.granAmp, \cutoff, 15000, \posLo, 0, \posHi, 0.7,
					\grainDurLo, 0.1, \grainDurHi, 0.5, \trigRate, 12]);
		});
		self.shiftChordGran = Array.fill(8, { | i |
			Synth.tail(self.pianoGroup, \freezePlayerSus2,
				[\out, self.granFaderBus, \buffer, self.chordShiftBuf[i], \amp, self.granAmp, \cutoff, 15000, \posLo, 0, \posHi, 0.7,
					\grainDurLo, 0.1, \grainDurHi, 0.5, \trigRate, 12]);
		});
		self.playState = 1;
		self;
	},

	stopGranulation: { | self |
		self.chordGran.do({ | i | i.set(\gate, 0); });
		self.shiftChordGran.do({ | i | i.set(\gate, 0); });
		self.playState = 0;
		self;
	},

	muteToggle: { | self |
		if( self.muteState == 1, { self.mute; }, { self.unmute; });
		self;
	},

	mute: { | self |
		self.inFader.set(\mute, 0);
		self.muteState = 0;
		self;
	},

	unmute: { | self |
		self.inFader.set(\mute, 1);
		self.muteState = 1;
		self;
	},

	setOutput: { | self, output |
		case
		{ output == 1 } { self.set1; }
		{ output == 2 } { self.set2; }
		{ output == 3 } { self.set3; }
	},

	set1: { | self |
		self.output = ~mixer.s1;
		self.fader.set(\out, self.output);
		self;
	},

	set2: { | self |
		self.output = ~mixer.s2;
		self.fader.set(\out, self.output);
		self;
	},

	set3: { | self |
		self.output = ~mixer.s3;
		self.fader.set(\out, self.output);
		self;
	},
)