/*
Tuesday, August 20th 2013
texture.scd
prm
*/

~lucy.texture = (

	state: 0,
	muteState: 0,
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
		self.granGroup = Group.new(self.phaser, \addBefore);
		self;
	},

	killGroups: { | self |
		self.granGroup.free;
		self;
	},

	makeBuffers: { | self |
		var path = "/Users/patrickmcminn/Documents/Music/Current Work/Patrick McMinn/Great Noise Ensemble/Beatles Concert/Beatles/data/Lucy/";
		self.buffer = Buffer.readChannel(s, path ++ "Opening.aif", 0, -1, 1);
		self;
	},

	killBuffers: { | self |
		self.buffer.free;
		self;
	},

	makeBusses: { | self |
		self.phaserBus = Bus.audio(s, 2);
		self.faderBus = Bus.audio(s, 2);
		self;
	},

	killBusses: { | self |
		self.phaserBus.free;
		self.faderBus.free;
		self;
	},

	makeSynths: { | self |
		self.phaser = Synth.tail(~group.fx, \variPhaserStereo, [\in, self.phaserBus, \out, self.faderBus, \amp, 1,
			\delTime1, 0.01, \delTime2Lo, -0.0095, \delTime2Hi, 0.0015, \del2RateLo, 0.1, \del2RateHi, 0.9,
			\del2RateFreq, 4]);
		self.fader = Synth.tail(~group.fx, \stereoFader, [\in, self.faderBus, \out, self.output, \amp, -6.dbamp]);
		self;
	},

	killSynths: { | self |
		self.phaser.free;
		self.fader.free;
		self;
	},

	toggleGran: { | self |
		if( self.playState == 0, { self.playGran; }, { self.stopGran; });
		self;
	},

	playGran: { | self |
		self.gran = Synth.tail(self.granGroup, \freezePlayerSus2,
			[
				\buffer, self.buffer, \amp, 1, \out, self.phaserBus, \rateLo, -0.6, \rateHi, -0.6,
				\cutoff, 1000, \tremRate, 0.1, \tremDepth, 0.3, \grainDurLo, 1.3, \grainDurhi, 1.6, \trigRate, 3.1
			]
		);
		self.playState = 1;
		self;
	},

	stopGran: { | self |
		self.gran.set(\gate, 0);
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