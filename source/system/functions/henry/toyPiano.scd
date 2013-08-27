/*
Sunday, August 25th 2013
plane from Las Vegas to Baltimore
toyPiano.scd
prm
*/

~henry.toyPiano = (

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
		self.compressorBus = Bus.audio;
		self.shiftBus = Bus.audio;
		self.faderBus = Bus.audio(s, 2);
		self;
	},

	killBusses: { | self |
		self.compressorBus.free;
		self.shiftBus.free;
		self.faderbus.free;
		self;
	},

	makeSynths: { | self |
		self.inFader = Synth.tail(~group.fx, \fader, [\in, self.input, \out, self.compressorBus, \amp, 1]);
		self.compressor = Synth.tail(~group.fx, \compressor, [\in, self.compressorBus, \out, self.shiftBus,
			\atk, 0.1, \rel, 0.48, \thresh, -21.8.dbamp, \ratio, 3, \makeup, 6.dbamp, \amp, 1]);
		self.multiShift = Synth.tail(~group.fx, \multiShift, [\in, self.shiftBus, \out, self.faderBus, \amp, 1,
			\shiftArray1, #[0, -5, 7, 2], \shiftArray2, #[0, 12, -12, 7], \shiftArray3, #[0, 2, -2, 5],
			\shiftArray4, #[0, -0.9, 1.1, 1.5], \shiftFreq, 12, \shiftKind, 1]);
		self.fader = Synth.tail(~group.fx, \stereoFader, [\in, self.faderBus, \out, self.output, \amp, -6.dbamp]);
		self;
	},

	killSynths: { | self |
		self.inFader.free;
		self.compressor.free;
		self.multiShift.free;
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