/*
Sunday, September 15th 2013
birdSong.scd
prm
*/

~nothing.birdSong = (

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
    var path = "/Users/patrickmcminn/Documents/Music/Current Work/Patrick McMinn/Great Noise Ensemble/Beatles Concert/Beatles/data/Nothing/";
    self.buffer = Buffer.read(s, path ++ "bird song.aif");
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
    self.fader = Synth.tail(~group.fx, \stereoFader, [\in, self.faderBus, \out, self.output, \amp, 1]);
		self;
	},

	killSynths: { | self |
    self.fader.free;
		self;
	},

	makePatterns: { | self |
    Pbindef(\nothingBirdSong,
      \instrument, \playBufStereoSus,
      \group, self.playGroup,
      \addAction, \addToTail,
      \out, self.faderBus,
      \buffer, self.buffer,
      \amp, Pwhite(0, 0.7, inf),
      \atk, Pwhite(0.01, 0.2, inf),
      \rel, Pwhite(0.05, 0.3,  inf),
      \pan, Pbrown(-1, 1, 0.125, inf),
      \bufScale, Pfunc({ self.buffer.numFrames; }),
      \startPos, Pwhite(0, 0.9 * Pkey(\bufScale), inf),
      \dur, Pwhite(0.01, 0.05),
      \rate, Prand([0.001, 0.2, 0.4, 0.4, 0.4, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8, 0.8], inf),
      \legato, 1
    );
    self;
  },

  killPatterns: { | self |
    Pbindef(\nothingBirdSong).remove;
    self;
  },

  togglePattern: { | self |
    if( self.playState == 0, { self.playPattern; }, { self.stopPattern; });
    self;
  },

  playPattern: { | self |
    Pbindef(\nothingBirdSong).play;
    self.playState = 1;
    self;
  },

  stopPattern: { | self |
    Pbindef(\nothingBirdSong).stop;
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