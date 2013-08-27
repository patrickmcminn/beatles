/*
Tuesday, August 27th 2013
bells.scd
prm
*/

~henry.bells = (

	state: 0,
	muteState: 0,
	input: ~inst.mic,
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
		self.buffer = Buffer.alloc(s, s.sampleRate * 4.0, 1);
		self;
	},

	killBuffers: { | self |
		self.buffer.free;
		self;
	},

	makeBusses: { | self |
		self.shiftBus = Bus.audio(s, 2);
		self.faderBus = Bus.audio(s, 2);
		self;
	},

	killBusses: { | self |
		self.shiftBus.free;
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

	recordBells: { | self |
		Synth.tail(~group.fx, \recordBuf, [\in, self.input, \bufName, self.buffer]);
		self;
	},

	play1: { | self |

		self;
	},

	play2: { | self |

		self;
	},

	play3: { | self |

		self;
	},

	play4: { | self |

		self;
	},

	play5: { | self |

		self;
	},

	play6: { | self |

		self;
	},

	play7: { | self |

		self;
	},

	play8: { | self |

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