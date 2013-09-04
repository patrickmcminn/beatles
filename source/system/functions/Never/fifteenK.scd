/*
Wednesday, September 4th 2013
fifteenK.scd
prm
*/

~never.fifteenK = (

	state: 0,

	iter1: 1,
	iter2: 1,
	iter3: 1,

	output: ~mixer.s3,

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

		self;
	},

	killBuffers: { | self |

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

	play1: {  | self |
		Synth.tail(self.playGroup, \sine, [\out, self.faderBus, \amp, 0.01, \freq, 15000/self.iter1, \pan, rrand(-1, 1)]);
		self.iter1 = self.iter1 + 1;
		self;
	},

	play2: {  | self |
		Synth.tail(self.playGroup, \sine, [\out, self.faderBus, \amp, 0.01, \freq, 15000/self.iter2, \pan, rrand(-1, 1)]);
		self.iter2 = self.iter2 + 0.7;
		self;
	},

	play3: {  | self |
		Synth.tail(self.playGroup, \sine, [\out, self.faderBus, \amp, 0.01, \freq, 15000/self.iter3, \pan, rrand(-1, 1)]);
		self.iter3 = self.iter3 + 0.6;
		self;
	},

	stopAll: { | self |
		self.playGroup.set(\gate, 0);
		self.iter1 = 1;
		self.iter2 = 1;
		self.iter3 = 1;
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

