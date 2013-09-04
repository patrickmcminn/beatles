/*
Wednesday, September 4th 2013
beatlesGran.scd
prm
*/

~never.beatlesGran = (

	state: 0,
	playState: 0,

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
		self.playGroup = Group.new(self.fader, \addBefore);
		self;
	},

	killGroups: { | self |
		self.playGroup.free;
		self;
	},

	makeBuffers: { | self |
		var path = "/Users/patrickmcminn/Documents/Music/Current Work/Patrick McMinn/Great Noise Ensemble/Beatles Concert/Beatles/data/Never Could See Any Other Way/";
		self.buffer = Buffer.read(s, path ++ "granBeatles.aif");
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
		self.fader = Synth.tail(~never.router.inGroup, \stereoFader, [\in, self.faderBus, \out, ~never.router.in2, \amp, 1]);
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
		self.gran = Synth.tail(self.playGroup, \freezePlayerSus2, [
			\buffer, self.buffer, \out, self.faderBus, \trigRate, 2, \posLo, 0, \posHi, 1,
			\cutoff, 5000, \rel, 0.01, \grainDurLo, 1, \grainDurHi, 3]);
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