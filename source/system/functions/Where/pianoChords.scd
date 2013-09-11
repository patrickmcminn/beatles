/*
Thursday, August 29th 2013
pianoChords.scd
prm
*/

~where.pianoChords = (

	state: 0,
	output: ~mixer.s1,
	//input: ~inst.
	bufferState: 0,

	chord11State: 0,
	chord12State: 0,
	chord13State: 0,

	chord21State: 0,
	chord22State: 0,
	chord23State: 0,

	spawn: { | self |
		if( self.state == 0, { self.init; }, { self.kill; });
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
		self.playGroup = Group.new(self.fader, \addBefore);
		self;
	},

	killGroups: { | self |
		self.playGroup.free;
		self;
	},

	makeBuffers: { | self |
		self.buffer = [
			Buffer.alloc(s, s.sampleRate * 1),
			Buffer.alloc(s, s.sampleRate * 0.9)
		];
		self.bufferState = 1;
		self;
	},

	killBuffers: { | self |
		self.buffer.do({ | buf | buf.free; });
		self;
	},

	toggleFakeBuffers: { | self |
		if ( self.bufferState == 0, { self.killFakeBuffers; }, { self.makeFakeBuffers; });
		self;
	},

	makeFakeBuffers: { | self |
		var path = "/Users/patrickmcminn/Documents/Music/Current Work/Patrick McMinn/Great Noise Ensemble/Beatles Concert/Beatles/data/Where/";
		self.buffer = [
			Buffer.read(s, path ++ "chord 1.aif", 0, s.sampleRate * 1),
			Buffer.read(s, path ++ "chord 2.aif", 0, s.sampleRate * 0.9)
		];
		self.bufferState = 0;
		self;
	},

	killFakeBuffers: { |self |
		self.makeBuffers;
		self.bufferState = 1;
		self;
	},

	makeBusses: { | self |
		self.faderBus = Bus.audio(s, 2);
		self;
	},

	killBusses: { | self |
		self.faderBus.free;
		self;
	},

	makeSynths: { | self |
		self.fader = Synth.tail(~group.fx, \stereoFader, [\in, self.faderBus, \out, self.output, \amp, 0.dbamp]);
		self;
	},

	killSynths: { | self |
		self.fader.free;
		self;
	},

	recordPiano: { | self, buf |
		Synth.tail(~group.fx, \recordBuf, [\in, self.input, \bufName, self.buffer[buf]]);
		self;
	},

	playChord11: { | self |
		self.chord11 = Synth.tail(self.playGroup, \playBufStereoSus, [\out, self.faderBus, \buffer, self.buffer[0], \amp, 1,
			\rate, 1, \pan, rrand(-0.7, 0.1)]);
		self.chord11State = 1;
		self;
	},

	stopChord11: { | self |
		self.chord11.set(\gate, 0);
		self.chord11State = 0;
		self;
	},

	playChord12: { | self |
		self.chord12 = Synth.tail(self.playGroup, \playBufStereoSus, [\out, self.faderBus, \buffer, self.buffer[0], \amp, 1,
			\rate, 8/9,\pan, rrand(-0.7, 0.1)]);
		self.chord12State = 1;
		self;
	},

	stopChord12: { | self |
		self.chord12.set(\gate, 0);
		self.chord12State = 0;
		self;
	},

	playChord13: { | self |
		self.chord13 = Synth.tail(self.playGroup, \playBufStereoSus, [\out, self.faderBus, \buffer, self.buffer[0], \amp, 1,
			\rate, 6/5, \pan, rrand(-0.7, 0.1)]);
		self.chord13State = 1;
		self;
	},

	stopChord13: { | self |
		self.chord13.set(\gate, 0);
		self.chord13State = 0;
		self;
	},

	playChord21: { | self |
		self.chord21 =  Synth.tail(self.playGroup, \playBufStereoSus, [\out, self.faderBus, \buffer, self.buffer[1], \amp, 1,
			\rate, 1, \pan, rrand(-0.1, 0.7)]);
		self.chord21State = 1;
		self;
	},

	stopChord21: { | self |
		self.chord21.set(\gate, 0);
		self.chord21State = 0;
		self;
	},

	playChord22: { | self |
		self.chord22 =  Synth.tail(self.playGroup, \playBufStereoSus, [\out, self.faderBus, \buffer, self.buffer[1], \amp, 1,
			\rate, 2/3, \pan, rrand(-0.1, 0.7)]);
		self.chord22State = 1;
		self;
	},

	stopChord22: { | self |
		self.chord22.set(\gate, 0);
		self.chord22State = 0;
		self;
	},

	playChord23: { | self |
		self.chord23 =  Synth.tail(self.playGroup, \playBufStereoSus, [\out, self.faderBus, \buffer, self.buffer[1], \amp, 1,
			\rate, 9/8, \pan, rrand(-0.1, 0.7)]);
		self.chord23State = 1;
		self;
	},

	stopChord23: { | self |
		self.chord23.set(\gate, 0);
		self.chord23State = 0;
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
);
