/*
Wednesday, August 28th 2013
trumpet.scd
prm
*/

~rita.trumpet = (


	state: 0,
	muteState: 0,
	input: ~inst.mute,
	output: ~mixer.s1,

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
		self.hugeBus = Bus.audio;
		self.faderBus = Bus.audio(s, 2);
		self;
	},

	killBusses: { | self |
		self.hugeBus;
		self.faderBus.free;
		self;
	},

	makeSynths: { | self |
		self.inFader = Synth.tail(~group.fx, \fader, [\in, self.input, \out, self.hugeBus]);
		self.huge = Synth.tail(~group.fx, \huge2, [\in, self.hugeBus, \out, self.faderBus,
			\amp, 0.3, \shiftArray, #[1.25, 0.75, 0.625, 0.5, 0.25, 1.25, 0.75],
			\grainAmp, 0, \cutoffLo, 1000, \cutoffHi, 3000, \cutoffChangeRate, 12,
			\delayTime, 0, \subAmp, 0.6, \shiftAmp, 2, \cutoff, 50]);
		self.fader = Synth.tail(~group.fx, \stereoFader, [\in, self.faderBus, \out, self.output, \amp, 1]);
		self;
	},

	killSynths: { | self |
		self.inFader.free;
		self.huge.free;
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
