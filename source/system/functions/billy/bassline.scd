/*
Wednesday, August 28th 2013
bassline.scd
prm
*/

~billy.bassline = (

	state: 0,
	playState: 0,
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

		self;
	},

	killBuffers: { | self |

		self;
	},

	makeBusses: { | self |
		self.faderBus = Bus.audio;
		self;
	},

	killBusses: { | self |
		self.faderBus.free;
		self;
	},

	makeSynths: { | self |
		self.fader = Synth.tail(~group.fx, \pan, [\in, self.faderBus, \out, self.output, \amp, -6.dbamp]);
		self;
	},

	killSynths: { | self |
		self.fader.free;
		self;
	},

	makePatterns: { | self |
		Pbindef(\billyBassline,
			\instrument, \ratioSawSus,
			\group, self.playGroup,
			\addAction, \addToTail,
			\out, self.faderBus,
			\amp, 0.3,
			\filterMul, 3,
			\rel, 0.05,
			\legato, 1,
			\freq, Pseq([24, 26, 28], inf).midicps,
			\dur, Pseq([4, (4 * (8/9)), (8 * (4/5))], inf)
		);
		self;
	},

	togglePattern: { | self |
		if ( self.playState == 0, { self.playPattern; }, { self.stopPattern; });
		self;
	},

	playPattern: { | self |
		if( ~billy.transport.state == 1, {
			Pbindef(\billyBassline).play(~billy.transport.tempoClock);
			self.playState = 1;
		});
		self;
	},

	stopPattern: { | self |
		Pbindef(\billyBassline).stop;
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

