/*
Wednesday, August 28th 2013
melody.scd
prm
*/

~rita.melody = (

	state: 0,
	bufferState: 1,
	playState: 0,
	input: ~inst.extMic3,
	output: ~mixer.s2,

	spawn: { | self |
		if( self.state == 0, { self.init; }, { self.kill; });
		self;
	},

	init: { | self |
		self.makeBuffers;
		self.makeBusses;
		self.makeSynths;
		self.makeGroups;
		self.makePatterns;
		self.state = 1;
		self;
	},

	kill: { | self |
		self.killBuffers;
		self.killBusses;
		self.killSynths;
		self.killGroups;
		self.killPatterns;
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
		self.buffer = Buffer.allocConsecutive(4, s, s.sampleRate);
		self.bufferState = 1;
		self;
	},

	killBuffers: { | self |
		self.buffer.do({ | item | item.free; });
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
		self.fader = Synth.tail(~group.fx, \stereoFader, [\in, self.faderBus, \out, self.output, \amp, -6.dbamp]);
		self;
	},

	killSynths: { | self |
		self.fader.free;
		self;
	},

	toggleFakeBuffers: { | self |
		if ( self.bufferState == 0, { self.killFakeBuffers; }, { self.makeFakeBuffers; });
		self;
	},

	makeFakeBuffers: { | self |
		var path = "/Users/patrickmcminn/Documents/Music/Current Work/Patrick McMinn/Great Noise Ensemble/Beatles Concert/Beatles/data/Rita/";
		self.buffer[0] = Buffer.read(s, path ++ "ViolinG.aif");
		self.buffer[1] = Buffer.read(s, path ++ "ViolinA.aif");
		self.buffer[2] = Buffer.read(s, path ++ "ViolinB.aif");
		self.buffer[3] = Buffer.read(s, path ++ "ViolinC.aif");
		self.bufferState = 0;
		self.makePatterns;
		self;
	},

	killFakeBuffer: { | self |
		self.makeBuffers;
		self.makePatterns;
		self;
	},

	makePatterns: { | self |
		Pbindef(\ritaMelody,
			\instrument, \freezePlayerSus2,
			\group, self.playGroup,
			\addAction, \addToTail,
			\out, self.faderBus,
			\buffer, self.buffer[3],
			\rateLo, Pstutter(Pseq([4, 3], inf), Pseq([
				[15/16, 18/25, 5/12, 15/32],
				[15/16, 18/25, 5/12, 15/32]* 8/9,
				[15/16, 18/25, 5/12, 15/32]* 4/5,
				[15/16, 18/25, 5/12, 15/32]* 18/25
			], inf)),
			\rateHi, Pkey(\rateLo),
			\rel, 0.01,
			\atk, 0.01,
			\legato, 1.3,
			\dur, Pseq([1, 1, 1, 1, 0.5, 1, 2.5], inf),
			\cutoff, 1000
		);
	},

	toggleMelody: { | self |
		if( self.playState == 0, { self.playMelody; }, { self.stopMelody; });
		self;
	},

	playMelody: { | self |
		Pbindef(\ritaMelody).play;
		self.playState = 1;
		self;
	},

	stopMelody: { | self |
		Pbindef(\ritaMelody).stop;
		self.playState = 0;
		self;
	},

	recordViolin: { | self, buf |
		Synth.tail(~group.fx, \recordBuf, [\in, self.input, \bufName, self.buffer[buf]]);
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