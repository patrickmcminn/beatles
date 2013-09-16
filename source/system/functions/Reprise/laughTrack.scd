/*
Sunday, September 15th 2013
laughTrack.scd
prm
*/

~reprise.laughTrack = (

  state: 0,
  laughState: [0, 0, 0, 0],
  applauseState: 0,
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
    var path = "/Users/patrickmcminn/Documents/Music/Current Work/Patrick McMinn/Great Noise Ensemble/Beatles Concert/Beatles/data/reprise/";
    self.buffer = [
      Buffer.read(s, path ++ "Laugh Track 1.aif"),
      Buffer.read(s, path ++ "Laugh Track 2.aif"),
      Buffer.read(s, path ++ "Laugh Track 3.aif"),
      Buffer.read(s, path ++ "Laugh Track 4.aif"),
      Buffer.read(s, path ++ "Applause.aif")
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
    self.fader = Synth.tail(~group.fx, \stereoFader, [\in, self.faderBus, \out, self.output, \amp, -6.dbamp]);
		self;
	},

	killSynths: { | self |
    self.fader.free;
		self;
	},

  toggleLaugh1: { | self |
    if( self.laughState[0] == 0, { self.playLaugh1 }, { self.stopLaugh1 });
    self;
  },

  playLaugh1: { | self |
    self.laugh1 = Synth.tail(self.playGroup, \playBufStereoSus, [\out, self.faderBus, \buffer, self.buffer[0],
      \rate, rrand(-0.6, -1), \amp, -6.dbamp, \startPos, self.buffer[0].numFrames.rand ]);
    self.laughState[0] = 1;
    self;
  },

  stopLaugh1: { | self |
    self.laugh1.set(\gate, 0);
    self.laughState[0] = 0;
    self;
  },

  toggleLaugh2: { | self |
    if( self.laughState[1] == 0, { self.playLaugh2 }, { self.stopLaugh2 });
    self;
  },

  playLaugh2: { | self |
    self.laugh2 = Synth.tail(self.playGroup, \playBufStereoSus, [\out, self.faderBus, \buffer, self.buffer[1],
      \rate, rrand(-0.6, -1), \amp, -6.dbamp, \startPos, self.buffer[1].numFrames.rand]);
    self.laughState[1] = 1;
    self;
  },

  stopLaugh2: { | self |
    self.laugh2.set(\gate, 0);
    self.laughState[1] = 0;
    self;
  },

  toggleLaugh3: { | self |
    if( self.laughState[2] == 0, { self.playLaugh3 }, { self.stopLaugh3 });
    self;
  },

  playLaugh3: { | self |
    self.laugh3 = Synth.tail(self.playGroup, \playBufStereoSus, [\out, self.faderBus, \buffer, self.buffer[2],
      \rate, rrand(-0.6, -1), \amp, -6.dbamp, \startPos, self.buffer[2].numFrames.rand]);
    self.laughState[2] = 1;
    self;
  },

  stopLaugh3: { | self |
    self.laugh3.set(\gate, 0);
    self.laughState[2] = 0;
    self;
  },

  toggleLaugh4: { | self |
    if( self.laughState[3] == 0, { self.playLaugh4 }, { self.stopLaugh4 });
    self;
  },

  playLaugh4: { | self |
    self.laugh4 = Synth.tail(self.playGroup, \playBufStereoSus, [\out, self.faderBus, \buffer, self.buffer[3],
      \rate, rrand(-0.6, -1), \amp, -6.dbamp, \startPos, self.buffer[3].numFrames.rand]);
    self.laughState[3] = 1;
    self;
  },

  stopLaugh4: { | self |
    self.laugh4.set(\gate, 0);
    self.laughState[3] = 0;
    self;
  },

  toggleApplause: { | self |
    if( self.applauseState == 0, { self.playApplause; }, { self.stopApplause; });
    self;
  },

  playApplause: { | self |
    self.applause = Synth.tail(self.playGroup, \playBufStereoSus, [\out, self.faderBus, \buffer, self.buffer[4],
      \rate, rrand(-0.4, 0.7), \amp, -12.dbamp, \startPos, self.buffer[4].numFrames.rand]);
    self.applauseState = 1;
    self;
  },

  stopApplause: { | self |
    self.applause.set(\gate, 0);
    self.applauseState = 0;
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