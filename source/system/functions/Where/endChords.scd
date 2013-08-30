/*
Thursday, August 29th 2013
endChords.scd
prm
*/

~where.endChords = (

	state: 0,
	playState: 0,
	output: ~mixer.s2,

	fadeTime: 10,

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
		self.playGroup = Group.new(self.broken, \addBefore);
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
		self.fadeBus = Bus.control;
		self.brokenBus = Bus.audio(s, 2);
		self.faderBus = Bus.audio(s, 2);
		self;
	},

	killBusses: { | self |
		self.fadeBus.free;
		self.brokenBus.free;
		self.faderBus.free;
		self;
	},

	makeSynths: { | self |
		self.broken = Synth.tail(~group.fx, \brokenAntenna, [\in, self.brokenBus, \out, self.faderBus,
			\lowOutputGain, 0.3,\lowInputGain, 0.6]);
		self.fader = Synth.tail(~group.fx, \stereoFader, [\in, self.faderBus, \out, self.output, \amp, 0.dbamp]);
		self;
	},

	killSynths: { | self |
		self.broken.free;
		self.fader.free;
		self;
	},

	makePatterns: { | self |
		Pbindef(\whereEnd,
			\instrument, \hammondSus,
			\group, self.playGroup,
			\addAction, \addToTail,
			\out, self.brokenBus,
			\subAmp, 0.7,
			\bassAmp, 0,
			\partial2Amp, Pwhite(0.07, 1.2, inf),
			\partial3Amp, Pwhite(0.005, 0.015, inf),
			\partial4Amp, Pwhite(0, 0.0005, inf),
			\partial5Amp, Pwhite(0, 0.0005, inf),
			\partial6Amp, Pwhite(0, 0.003, inf),
			\partial8Amp, Pwhite(0.003, 0.007, inf),
			\atk, 0.1,
			\legato, 1,
			\dur, Pwhite(0.13, 0.21),
			\dist, 0.65,
			\root, 5,
			\octave, 3,
			\note, Pstutter(16, Pseq([[0, 15, 22, 29], [0, 17, 21, 29], [0, 15, 22, 29], [5, 12, 21, 29]], inf)),
			\amp, [0.1, 0.1, 0.1, 0.07],
			\cutoff, Pwhite(900, 1400, inf),
			\pan, Pwhite(-0.3, 0.3, inf)
		);
		self;
	},

	killPatterns: { | self |
		Pbindef(\whereEnd).clear;
		self;
	},

	toggleChords: { | self |
		if( self.playState == 0, { self.playChords; }, { self.stopChords; });
		self;
	},

	playChords: { | self |
		Pbindef(\whereEnd).play;
		self.playState = 1;
		self;
	},

	stopChords: { | self |
		Pbindef(\whereEnd).stop;
		self.playState = 0;
		self;
	},

	fadeIn: { | self |
		Synth.tail(~group.control, \ctlLinLine, [\out, self.fadeBus, \start, 0, \end, 1, \dur, self.fadeTime]);
		self.fader.set(\amp, self.fadeBus.asMap);
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
