/*
Sunday, September 15th 2013
warmUp.scd
prm
*/

~reprise.warmUp = (

  state: 0,

  playState: 0,
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
    var path = "/Users/patrickmcminn/Documents/Music/Current Work/Patrick McMinn/Great Noise Ensemble/Beatles Concert/Beatles/data/reprise/";
    self.buffer = Buffer.read(s, path ++ "tuneUp-PLACEHOLDER.aif");
    self.crowdBuf = Buffer.read(s, path ++ "crowdNoise-PLACEHOLDER.aif");
		self;
	},

	killBuffers: { | self |
    self.buffer.free;
    self.crowdBuf.free;
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

	makePatterns: { | self |
    Pbindef(\repriseWarmUp,
      \instrument, \playBufStereoSus,
      \group, self.playGroup,
      \addAction, \addToTail,
      \out, self.faderBus,
      \buffer, self.buffer,
      \atk, Pwhite(0.01, 0.09, inf),
      \rel, Pwhite(0.01, 0.09, inf),
      \rate, Pwhite(-0.7, -1.3),
      \frameConvert, Pfunc({ self.buffer.numFrames }),
      \startPos, Pwhite(0, 0.7 * Pkey(\frameConvert)),
      \dur, Pwhite(0.05, 0.3),
      \legato, 0.8,
      \pan, Pwhite(-1, 1, inf),
      \amp, Prand([0, 0, 0, 0.1, 0.15, 0.17], inf)
    );

    Pbindef(\repriseCrowd,
      \instrument, \playBufStereoSus,
      \group, self.playGroup,
      \addAction, \addToTail,
      \out, self.faderBus,
      \buffer, self.crowdBuf,
      \atk, Pwhite(0.05, 3, inf),
      \rel, Pwhite(0.05, 9),
      \rate, Pwhite(0.8, 1.2),
      \frameConvert, Pfunc({ self.crowdBuf.numFrames }),
      \startPos, Pwhite(0, 0.7 * Pkey(\frameConvert)),
      \dur, Pwhite(0.1, 4),
      \legato, 1,
      \pan, Pwhite(-1, 1, inf),
      \amp, Prand([0.1, 0.3, 0.2, 0.15, 0.125, 0.1], inf)
    );

    self;
  },

  killPatterns: { | self |
    Pbindef(\repriseWarmUp).remove;
    Pbindef(\repriseCrowd).remove;
    self;
  },

  togglePattern: { | self |
    if( self.playState == 0, { self.playPattern; }, { self.stopPattern; });
    self;
  },

  playPattern: { | self |
    Pbindef(\repriseWarmUp).play;
    Pbindef(\repriseCrowd).play;
    self.playState = 1;
    self;
  },

  stopPattern: { | self |
    Pbindef(\repriseWarmUp).stop;
    Pbindef(\repriseCrowd).stop;
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