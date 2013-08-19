/*
Saturday, August 17th 2013
stringHaze.scd
prm
*/

~worse.stringHaze = (

	state: 0,
	playState: 0,
	muteState: 0,
	output: ~mixer.s3,
	atk: 3.0,
	rel: 15.0,
	trigRate: 1,
	durLo: 0.0001,
	durHi: 0.3,
	cutoff: 2500,


	spawn: { | self |
		if( self.state == 0, { self.init; }, { self.kill; });
		self;
	},

	init: { | self |
		self.makeGroups;
		self.makeBuffers;
		self.makeBusses;
		self.makeSynths;
		self.state = 1;
		self;
	},

	kill: { | self |
		self.killGroups;
		self.killBuffers;
		self.killBusses;
		self.killSynths;
		self.state = 0;
		self;
	},

	makeGroups: { | self |

		self;
	},

	killGroups: { | self |

		self;
	},

	makeBuffers: { | self |
		var path = "/Users/patrickmcminn/Documents/Music/Current Work/Patrick McMinn/Great Noise Ensemble/Beatles Concert/Beatles/data/No Worse/";
		self.buffer = Buffer.readChannel(s, path ++ "allStrings.aif", 0, -1, 1);
		self;
	},

	killBuffers: { | self |
		self.buffer.free;
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
		self.fader = Synth.tail(~group.fx, \stereoFader, [\in, self.faderBus, \out, self.output, \amp, -16.dbamp]);
		self;
	},

	killSynths: { | self |
		self.fader.free;
		self;
	},

	toggleGran: { | self |
		if( self.playState == 0, { self.playGran; }, { self.stopGran; });
		self;
	},

	playGran: { | self |
		self.gran = Synth.before(self.fader, \freezePlayerSus2, [\buffer, self.buffer, \out, self.faderBus, \amp, 1,
			\atk, self.atk, \rel, self.rel,
			\trigRate, self.trigRate, \grainDurLo, self.durLo, \grainDurHi, self.durHi,
			\rateLo, 0.95, \rateHi, 1.05, \cutoff, self.cutoff]);
		self.playState = 1;
		self;
	},

	stopGran: { | self |
		self.gran.set(\gate, 0);
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

);