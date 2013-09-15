/*
Sunday, September 15th 2013
texture.scd
prm
*/

~intro.texture = (

  state: 0,
  playState: 0,
  vinylState: 0,
  warmUpState: 0,
  crowdState: 0,
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
    var path = "/Users/patrickmcminn/Documents/Music/Current Work/Patrick McMinn/Great Noise Ensemble/Beatles Concert/Beatles/data/Intro/";
    self.vinylBuf = Buffer.read(s, path ++ "vinyl.aif");
    self.warmUpBuf = Buffer.read(s, path ++ "tuneUp-PLACEHOLDER.aif");
    self.crowdBuf = Buffer.read(s, path ++ "crowdNoise-PLACEHOLDER.aif");
		self;
	},

	killBuffers: { | self |
    self.vinylBuf.free;
    self.warmUpBuf.free;
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
    Pbindef(\introVinyl,
      \instrument, \playBufStereoSus,
      \group, self.playGroup,
      \addAction, \addToTail,
      \out, self.faderBus,
      \buffer, self.vinylBuf,
      \atk, Pwhite(0.05, 3, inf),
      \rel, Pwhite(0.05, 9),
      \rate, Pwhite(0.8, 1.2),
      \frameConvert, Pfunc({ self.vinylBuf.numFrames }),
      \startPos, Pwhite(0, 0.7 * Pkey(\frameConvert)),
      \dur, Pwhite(0.1, 4),
      \legato, 1,
      \pan, Pwhite(-0.2, 0.2, inf),
      \amp, Pwhite(0.2, 0.4)
    );

    Pbindef(\introWarmUp,
      \instrument, \playBufStereoSus,
      \group, self.playGroup,
      \addAction, \addToTail,
      \out, self.faderBus,
      \buffer, self.warmUpBuf,
      \atk, Pwhite(0.05, 3, inf),
      \rel, Pwhite(0.05, 9),
      \rate, Pwhite(0.8, 1.2),
      \frameConvert, Pfunc({ self.warmUpBuf.numFrames }),
      \startPos, Pwhite(0, 0.7 * Pkey(\frameConvert)),
      \dur, Pwhite(0.1, 4),
      \legato, 1,
      \pan, Pwhite(-1, 1, inf),
      \amp, Prand([0, 0, 0, 0.1, 0.15, 0.17], inf)
    );

    Pbindef(\introCrowd,
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
      \amp, Prand([0.2, 0.6, 0.4, 0.3, 0.15, 0.17], inf)
    );
    self;
  },

  killPatterns: { | self |
    Pbindef(\introVinyl).clear;
    Pbindef(\introWarmUp).clear;
    Pbindef(\introCrowd).clear;
    self;
  },

  toggleTexture: { | self |
    if( self.playState == 0, { self.playTexture; }, { self.stopTexture; });
    self;
  },

  playTexture: { | self |
    self.toggleVinyl;
    self.toggleWarmUp;
    self.toggleCrowd;
    self.playState = 1;
    self;
  },

  stopTexture: { | self |
    self.toggleVinyl;
    self.toggleWarmUp;
    self.toggleCrowd;
    self.playState = 0;
    self;
  },

  toggleVinyl: { | self |
    if( self.vinylState == 0, { self.playVinyl; }, { self.stopVinyl; });
    self;
  },

  playVinyl: { | self |
    Pbindef(\introVinyl).play;
    self.vinylState = 1;
    self;
  },

  stopVinyl: { | self |
    Pbindef(\introVinyl).stop;
    self.vinylState = 0;
    self;
  },

  toggleWarmUp: { | self |
    if( self.warmUpState == 0, { self.playWarmUp }, { self.stopWarmUp; });
    self;
  },

  playWarmUp: { | self |
    Pbindef(\introWarmUp).play;
    self.warmUpState = 1;
    self;
  },

  stopWarmUp: { | self |
    Pbindef(\introWarmUp).stop;
    self.warmUpState = 0;
    self;
  },

  toggleCrowd: { | self |
    if ( self.crowdState == 0, { self.playCrowd; }, { self.stopCrowd; });
    self;
  },

  playCrowd: { | self |
    Pbindef(\introCrowd).play;
    self.crowdState = 1;
    self;
  },

  stopCrowd: { | self |
    Pbindef(\introCrowd).stop;
    self.crowdState = 0;
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