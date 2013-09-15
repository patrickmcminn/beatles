/*
Sunday, September 15th 2013
brass.scd
prm
*/

~nothing.brass = (

  state: 0,
	play1State: 0,
  play2State: 0,
	output: ~mixer.s1,

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
    var path = "/Users/patrickmcminn/Documents/Music/Current Work/Patrick McMinn/Great Noise Ensemble/Beatles Concert/Beatles/data/Nothing/";
    self.buffer = [
      Buffer.read(s, path ++ "brass1.aif"),
      Buffer.read(s, path ++ "brass2.aif")
    ];
		self;
	},

	killBuffers: { | self |
    self.buffer.do({ | i | i.free; });
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
    self.fader = Synth.tail(~group.fx, \stereoFader, [\in, self.faderBus, \out, self.output, \amp, 1]);
		self;
	},

	killSynths: { | self |
    self.fader.free;
		self;
	},

  toggleBrass1: { | self |
    if( self.play1State == 0, { self.playBrass1; }, { self.stopBrass1; });
    self;
  },

  playBrass1: { | self |
    self.brass1 = Synth.tail(self.playGroup, \playBufStereoSus, [\buffer, self.buffer[0], \out, self.faderBus,
      \pan, -0.7, \rel, 3]);
    self.play1State = 1;
    self;
  },

  stopBrass1: { | self |
    self.brass1.set(\gate, 0);
    self.play1State = 0;
    self;
  },

  toggleBrass2: { | self |
    if( self.play2State == 0, { self.playBrass2; }, { self.stopBrass2; });
    self;
  },

  playBrass2: { | self |
    self.brass2 = Synth.tail(self.playGroup, \playBufStereoSus, [\buffer, self.buffer[1], \out, self.faderBus,
      \pan, 0.7, \rel, 3]);
    self.play2State = 1;
    self;
  },

  stopBrass2: { | self |
    self.brass2.set(\gate, 0);
    self.play2State = 0;
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