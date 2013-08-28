/*
Sunday, August 25th 2013
triangle.scd
prm
*/

~henry.triangle = (

	state: 0,
	muteState: 0,
	input: ~inst.mic,
	output: ~mixer.s3,

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

		self;
	},

	killBuffers: { | self |

		self;
	},

	makeBusses: { | self |
		self.granBus = Bus.audio;
		self.faderBus = Bus.audio(s, 2);
		self;
	},

	killBusses: { | self |
		self.granBus.free;
		self.faderBus.free;
		self;
	},

	makeSynths: { | self |
		self.inFader = Synth.tail(~group.fx, \fader, [\in, self.input, \out, self.granBus, \amp, 1]);
		self.gran = Synth.tail(~group.fx, \granulator, [\in, self.granBus, \out, self.faderBus, \amp, 1,
			\env, ~grainBufs.percRev, \mix, 0.3, \bufLength, 1.5, \panOffset, 0.1,
			\rate, 1, \rateOffset, 0.1, \grainDur, 0.1, \grainDurOffset, 0.05, \trigRate, 65, \amp, 2]);
		self.fader = Synth.tail(~group.fx, \stereoFader, [\in, self.faderBus, \out, self.output, \amp, 1]);
		self;
	},

	killSynths: { | self |
		self.inFader.free;
		self.gran.free;
		self.fader.free;
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