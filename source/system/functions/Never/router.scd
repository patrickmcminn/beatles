/*
Wednesday, September 4th 2013
router.scd
prm
*/

~never.router = (

	state: 0,
	output: ~mixer.s1,
	currentIn: 1,

  distState: 0,

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
		self.inGroup = Group.new(self.fader, \addBefore);
		self;
	},

	killGroups: { | self |
		self.inGroup.free;
		self;
	},

	makeBuffers: { | self |

		self;
	},

	killBuffers: { | self |

		self;
	},

	makeBusses: { | self |
		self.in1 = Bus.audio(s, 2);
		self.in2 = Bus.audio(s, 2);
		self.in3 = Bus.audio(s, 2);
		self.in4 = Bus.audio(s, 2);
		self;
	},

	killBusses: { | self |
		self.in1.free;
		self.in2.free;
		self.in3.free;
		self.in4.free;
		self;
	},

	makeSynths: { | self |
		self.fader = Synth.tail(~group.fx, \audioRouter, [\in1, self.in1, \in2, self.in2, \in3, self.in3, \in4, self.in4, \out, self.output,
			\amp, -4.dbamp]);
		self;
	},

	killSynths: { | self |
		self.fader.free;
		self;
	},

	setIn1: { | self |
		self.fader.set(\inSel, 0);
		self.currentIn = 1;
		self;
	},

	setIn2: { | self |
		self.fader.set(\inSel, 1);
		self.currentIn = 2;
		self;
	},

	setIn3: { | self |
		self.fader.set(\inSel, 2);
		self.currentIn = 3;
		self;
	},

	setIn4: { | self |
		self.fader.set(\inSel, 3);
		self.currentIn = 4;
		self;
	},

  distToggle: { | self |
    if( self.distState == 0, { self.distOn; }, { self.distOff });
    self;
  },

  distOn: { | self |
    self.fader.set(\dist, 1000, \cutoff, 6000, \amp, -20.dbamp);
    self.distState = 1;
    self;
  },

  distOff: { | self |
    self.fader.set(\dist, 1, \cutoff, 20000, \amp, 1);
    self.distState = 0;
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