/*
Friday, August 30th 2013
noiseBed.scd
prm
*/

~boy.noiseBed = (

	state: 0,
	muteState: 0,
	output: ~mixer.s3,

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
		self.granGroup = Group.new(self.fader, \addBefore);
		self;
	},

	killGroups: { | self |
		self.granGroup.free;
		self;
	},

	makeBuffers: { | self |
		var path = "/Users/patrickmcminn/Documents/Music/Current Work/Patrick McMinn/Great Noise Ensemble/Beatles Concert/Beatles/data/Oh Boy/";
		self.buffer = [
			Buffer.read(s, path ++ "Radio Noise 1.aif"),
			Buffer.read(s, path ++ "Radio Noise 2.aif"),
			Buffer.read(s, path ++ "Tape Noise.aif")
		];
		self;
	},

	killBuffers: { | self |
		self.buffer.do({ | buf | buf.free; });
		self;
	},

	makeBusses: { | self |
		self.panBus = Bus.control;
		self.faderBus = Bus.audio(s, 2);
		self;
	},

	killBusses: { | self |
		self.faderBus.free;
		self;
	},

	makeSynths: { | self |
		self.panControl = Synth.tail(~group.control, \lfSin, [\out, self.panBus, \freq, 0.1, \rangeLo, -1, \rangeHi, 1]);
		self.fader = Synth.tail(~group.fx, \stereoFader, [\in, self.faderBus, \out, self.output, \amp, -6.dbamp]);
		self;
	},

	killSynths: { | self |
		self.fader.free;
		self;
	},

	playGran1: { | self |
		self.gran1 = Synth.tail(self.granGroup, \freezePlayerSus2, [ \out, self.faderBus, \buffer, self.buffer[0],
			\atk, 10, \rel, 6, \cutoff, 15000, \trigRate, 2.5, \grainDurLo, 1, \grainDurHi, 5, \amp, 0.6]);
		self;
	},

	stopGran1: { | self |
		self.gran1.set(\gate, 0);
		self;
	},

	playGran2: { | self |
		self.gran2 = Synth.tail(self.granGroup, \freezePlayerSus2, [ \out, self.faderBus, \buffer, self.buffer[1],
			\atk, 10, \rel, 6, \cutoff, 2000, \trigRate, 1.5, \grainDurLo, 3, \grainDurHi, 9]);
		self;
	},

	stopGran2: { | self |
		self.gran2.set(\gate, 0);
		self;
	},

	playGran3: { | self |
		self.gran3 = Synth.tail(self.granGroup, \freezePlayerSus2, [ \out, self.faderBus, \buffer, self.buffer[2],
			\atk, 4, \rel, 6, \cutoff, 15000, \trigRate, 7, \grainDurLo, 0.001, \grainDurHi, 0.03, \pan, self.panBus.asMap]);
		self;
	},

	stopGran3: { | self |
		self.gran3.set(\gate, 0);
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