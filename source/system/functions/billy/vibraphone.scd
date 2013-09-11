/*
Wednesday, August 28th 2013
vibraphone.scd
prm
*/

~billy.vibraphone = (

	state: 0,
	input: ~inst.mic,
	output: ~mixer.s2,
	bufferState: 0,

	atk: 4,
	rel: 6,

	origState: 0,
	cState: 0,
	dState: 0,
	eState: 0,

	playState: 0,


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
		self.playGroup = Group.new(self.patternFader, \addBefore);
		self.granGroup = Group.new(self.granFader, \addBefore);
		self;
	},

	killGroups: { | self |
		self.playGroup.free;
		self.granGroup.free;
		self;
	},

	makeBuffers: { | self |
		self.buffer = Buffer.alloc(s, s.sampleRate * 1.7);
		self.bufferState = 1;
		self;
	},

	killBuffers: { | self |
		self.buffer.free;
		self;
	},

	recordVibraphone: { | self |
		Synth.tail(~group.fx, \recordBuf, [\in, self.input, \bufName, self.buffer]);
		self;
	},

	toggleFakeBuffer: { | self |
		if ( self.bufferState == 0, { self.killFakeBuffer; }, { self.makeFakeBuffer; });
		self;
	},

	makeFakeBuffer: { | self |
		var path = "/Users/patrickmcminn/Documents/Music/Current Work/Patrick McMinn/Great Noise Ensemble/Beatles Concert/Beatles/data/Billy Shears/";
		self.buffer = Buffer.read(s, path ++ "f#m9.aif");
		self.bufferState = 0;
		self.makePatterns;
		self;
	},

	killFakeBuffer: { | self |
		self.buffer = Buffer.alloc(s, s.sampleRate * 1.7);
		self.bufferState = 1;
		self.makePatterns;
		self;
	},

	makeBusses: { | self |
		self.patternFaderBus = Bus.audio(s, 2);
		self.granFaderBus = Bus.audio(s, 2);
		self.faderBus = Bus.audio(s, 2);
		self;
	},

	killBusses: { | self |
		self.patternFaderBus.free;
		self.granFaderBus.free;
		self.faderBus.free;
		self;
	},

	makeSynths: { | self |
		self.patternFader = Synth.tail(~group.fx, \stereoFader, [\in, self.patternFaderBus, \out, self.faderBus,
			\amp, -6.dbamp]);
		self.granFader = Synth.tail(~group.fx, \stereoFader, [\in, self.granFaderBus, \out, self.faderBus,
			\amp, -6.dbamp]);
		self.fader = Synth.tail(~group.fx, \stereoFader, [\in, self.faderBus, \out, self.output, \amp, 1]);
		self;
	},

	killSynths: { | self |
		self.patternFader.free;
		self.granFader.free;
		self.fader.free;
		self;
	},

	makePatterns: { | self |
		Pbindef(\billyVibraphone,
			\instrument, \freezePlayerSus2,
			\group, self.playGroup,
			\addAction, \addToTail,
			\out, self.patternFaderBus,
			\buffer, self.buffer,
			\dur, Pstutter(Pseq([12, 12, 48], inf), Pseq([1/3, ((1/3) * (8/9)), ((1/3) * (4/5))], inf)),
			\rateLo, Pstutter(Pseq([12, 12, 48], inf), Pseq([[1.2, 0.6], [1.35, 0.675], [1.5, 0.75]], inf)),
			\rateHi, Pkey(\rateLo),
			\grainDurLo, 0.7,
			\grainDurHi, 0.7,
			\posLo, 0.1,
			\posHi, 0.8,
			\rel, 0.01,
			\atk, 0.01,
			\legato, 1,
			\amp, 0.7,
			\cutoff, Pwhite(2000, 5000, inf),
			\env, ~grainBufs.gabWide
		);
		self;
	},

	killPatterns: { | self |
		Pbindef(\billyVibraphone).clear;
		self;
	},

	togglePattern: { | self |
		if ( self.playState == 0, { self.playPattern; }, { self.stopPattern; });
		self;
	},

	playPattern: { | self |
		if( ~billy.transport.state == 1, {
			Pbindef(\billyVibraphone).play(~billy.transport.tempoClock);
			self.playState = 1;
		});
		self;
	},

	stopPattern: { | self |
		Pbindef(\billyVibraphone).stop;
		self.playState = 0;
		self;
	},

	toggleOrig: { | self |
		if (self.origState == 0, { self.granulateOrig; }, { self.stopOrig; });
		self;
	},

	toggleC: { | self |
		if ( self.cState == 0, { self.granulateC; }, { self.stopC; });
		self;
	},

	toggleD: { | self |
		if ( self.dState == 0, { self.granulateD; }, { self.stopD; });
		self;
	},

	toggleE: { | self |
		if ( self.eState == 0, { self.granulateE; }, { self.stopE; });
		self
	},

	granulateOrig: { | self |
		self.granOrig1 = Synth.tail(self.granGroup, \freezePlayerSus2, [\buffer, self.buffer, \out, self.granFaderBus,
			\trigRate, 30, \grainDurLo, 0.3, \grainDurHi, 0.65, \rateLo, 1, \rateHi, 1,
			\atk, self.atk, \rel, self.rel, \amp, 0.2
		]);
		self.granOrig2 = Synth.tail(self.granGroup, \freezePlayerSus2, [\buffer, self.buffer, \out, self.granFaderBus,
			\trigRate, 30, \grainDurLo, 0.3, \grainDurHi, 0.65, \rateLo, 0.5, \rateHi, 0.5,
			\atk, self.atk, \rel, self.rel, \amp, 0.2
		]);
		self.origState = 1;
		self;
	},

	stopOrig: { | self |
		self.granOrig1.set(\gate, 0);
		self.granOrig2.set(\gate, 0);
		self.origState = 0;
		self;
	},

	granulateC: { | self |
		self.granC1 = Synth.tail(self.granGroup, \freezePlayerSus2, [\buffer, self.buffer, \out, self.granFaderBus,
			\trigRate, 30, \grainDurLo, 0.3, \grainDurHi, 0.65, \rateLo, 1.2, \rateHi, 1.2,
			\atk, self.atk, \rel, self.rel, \amp, 0.2
		]);
		self.granC2 = Synth.tail(self.granGroup, \freezePlayerSus2, [\buffer, self.buffer, \out, self.granFaderBus,
			\trigRate, 30, \grainDurLo, 0.3, \grainDurHi, 0.65, \rateLo, 0.6, \rateHi, 0.6,
			\atk, self.atk, \rel, self.rel, \amp, 0.2
		]);
		self.cState = 1;
		self;
	},

	stopC: { | self |
		self.granC1.set(\gate, 0);
		self.granC2.set(\gate, 0);
		self.cState = 0;
		self;
	},

	granulateD: { | self |
		self.granD1 = Synth.tail(self.granGroup, \freezePlayerSus2, [\buffer, self.buffer, \out, self.granFaderBus,
			\trigRate, 30, \grainDurLo, 0.3, \grainDurHi, 0.65, \rateLo, 1.35, \rateHi, 1.35,
			\atk, self.atk, \rel, self.rel, \amp, 0.2
		]);
		self.granD2 = Synth.tail(self.granGroup, \freezePlayerSus2, [\buffer, self.buffer, \out, self.granFaderBus,
			\trigRate, 30, \grainDurLo, 0.3, \grainDurHi, 0.65, \rateLo, 0.675, \rateHi, 0.675,
			\atk, self.atk, \rel, self.rel, \amp, 0.2
		]);
		self.dState = 1;
		self;
	},

	stopD: { | self |
		self.granD1.set(\gate, 0);
		self.granD2.set(\gate, 0);
		self.dState = 0;
		self;
	},

	granulateE: { | self |
		self.granE1 = Synth.tail(self.granGroup, \freezePlayerSus2, [\buffer, self.buffer, \out, self.granFaderBus,
			\trigRate, 30, \grainDurLo, 0.3, \grainDurHi, 0.65, \rateLo, 1.5, \rateHi, 1.5,
			\atk, self.atk, \rel, self.rel, \amp, 0.2
		]);
		self.granE2 = Synth.tail(self.granGroup, \freezePlayerSus2, [\buffer, self.buffer, \out, self.granFaderBus,
			\trigRate, 30, \grainDurLo, 0.3, \grainDurHi, 0.65, \rateLo, 0.75, \rateHi, 0.75,
			\atk, self.atk, \rel, self.rel, \amp, 0.2
		]);
		self.eState = 1;
		self;
	},

	stopE: { | self |
		self.granE1.set(\gate, 0);
		self.granE2.set(\gate, 0);
		self.eState = 0;
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