/*
Wednesday, September 4th 2013
rewind.scd
prm
*/

~never.rewind = (

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
		self.buffer = Buffer.read(s, path ++ "rewind.aif");
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
		self.fader = Synth.tail(~never.router.inGroup, \stereoFader, [\in, self.faderBus, \out, ~never.router.in3, \amp, 1]);
		self;
	},

	killSynths: { | self |
		self.fader.free;
		self;
	},

	toggleRewind: { | self |
		if( self.playState == 0, { self.playRewind; }, { self.stopRewind; });
		self;
	},

	playRewind: { | self |
		self.rewind = Synth.tail(self.playGroup, \playBufStereoSus, [\buffer, self.buffer, \out, self.faderBus]);
		self.playState = 1;
		self;
	},

	stopRewind: { | self |
		self.rewind.set(\gate, 0);
		self.playState = 0;
		self;
	}
);