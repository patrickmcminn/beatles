/*
Sunday, September 1st 2013
tanpura.scd
prm
*/

~space.tanpura = (

	state: 0,
	playState: 0,
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
		var path = "/Users/patrickmcminn/Documents/Music/Current Work/Patrick McMinn/Great Noise Ensemble/Beatles Concert/Beatles/data/Space/";
		self.buffer = Buffer.read(s, path ++ "tanpura loop.aif");
		self;
	},

	killBuffers: { | self |
		self.buffer.free;
		self;
	},

	makeBusses: { | self |
		self.posLoBus = Bus.control;
		self.posHiBus = Bus.control;
		self.durBus = Bus.control;
		self.rateBus = Bus.control;

		self.faderBus = Bus.audio(s, 2);
		self;
	},

	killBusses: { | self |
		self.posLoBus.free;
		self.posHiBus.free;
		self.durBus.free;
		self.rateBus.free;
		self.faderBus.free;
		self;
	},

	makeSynths: { | self |
		self.posLo = Synth.tail(~group.control, \lfSaw, [\out, self.posLoBus, \freq, 0.05, \rangeLo, 0.2, \rangeHi, 0.8]);
		self.posHi = Synth.tail(~group.control, \lfSaw, [\out, self.posHiBus, \freq, 0.05, \rangeLo, 0.25, \rangeHi, 0.85]);
		self.dur = Synth.tail(~group.control, \noiseControl0, [\out, self.durBus, \freq, 0.2, \rangeLo, 0.15, \rangeHi, 0.55]);
		self.fader = Synth.tail(~group.fx, \stereoFader, [\in, self.faderBus, \out, self.output, \amp, -4.dbamp]);
		self;
	},

	killSynths: { | self |
		self.posLo.free;
		self.posHi.free;
		self.dur.free;
		self.rate.free;
		self.fader.free;
		self;
	},

	toggleGran: { | self |
		if( self.playState == 0, { self.playGran; }, { self.stopGran; });
		self;
	},

	playGran: { | self |
		self.gran = Synth.tail(self.playGroup, \bufferGranEnv, [\buffer, self.buffer, \out, self.faderBus,
			\cutoffLo, 1500, \cutoffHi, 1700, \sync, 1, \resLo, 0.5, \resHi, 0.9, \trigRate, 12,
			\panLo, -0.1, \panHi, 0.1,
			\posLo, self.posLoBus.asMap, \posHi, self.posHiBus.asMap, \durLo, self.durBus.asMap, \durHi, self.durBus.asMap,
		]);
		self.playState = 1;
		self;
	},

	stopGran: { | self |
		self.gran.free;
		self.playState = 0;
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