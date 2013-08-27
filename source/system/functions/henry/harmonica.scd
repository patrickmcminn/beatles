/*
Tuesday, August 27th 2013
harmonica.scd
prm
*/

~henry.harmonica = (
	state: 0,
	playState: 0,
	muteState: 0,
	input: ~inst.mic,
	output: ~mixer.s1,

	spawn: { | self |
		if( self.state == 0, { self.init; }, { self.kill; });
		self;
	},

	init: { | self |
		self.makeClock;
		self.makeBuffers;
		self.makeBusses;
		self.makeSynths;
		self.makeGroups;
		self.makePatterns;
		self.state = 1;
		self;
	},

	kill: { | self |
		self.killClock;
		self.killBuffers;
		self.killBusses;
		self.killSynths;
		self.killGroups;
		self.killPatterns;
		self.state = 0;
		self;
	},

	makeClock: { | self |
		self.tempoClock = TempoClock.new(140/60);
		self;
	},

	killClock: { | self |
		self.tempoClock.clear;
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
		self.buffer = Buffer.allocConsecutive(4, s, s.sampleRate);
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
		self.fader = Synth.tail(~group.fx, \stereoFader, [\in, self.faderBus, \out, self.output, \amp, -4.dbamp]);
		self;
	},

	killSynths: { | self |
		self.fader.free;
		self;
	},

	makePatterns: { | self |
		Pbindef(\harmonica,
			\instrument, \freezePlayer,
			\group, self.playGroup,
			\addAction, \addToTail,
			\out, self.faderBus,
			\buffer, Prand([self.buffer[0], self.buffer[1], self.buffer[2], self.buffer[3]], inf),
			\atk, 0.05,
			\sus, Pseq([1/4, 1/4, 1/4, 1/4, 1/4, 1/4, 1/4, 1/4, 1/4, 2/3, 2/3, 2/3], inf),
			\rel, 0.05,
			\rate, Pbrown(0.5, 0.75, 0.1, inf),
			\dur, Pseq([1/3, 1/3, 1/3, 1/3, 1/3, 1/3, 1/3, 1/3, 1/3, 1, 1, 1], inf),
			\legato, 1,
		);
		self;
	},

	killPatterns: { | self |
		Pbindef(\harmonica).clear;
		self;
	},

	recordHarmonica: { | self, buf |
		Synth.tail(~group.fx, \recordBuf, [\bufName, self.buffer[buf], \in, self.input]);
		self;
	},

	toggleHarmonica: { | self |
		if( self.playState == 0, { self.playHarmonica; }, { self.stopHarmonica; });
		self;
	},

	playHarmonica: { | self |
		Pbindef(\harmonica).play(self.tempoClock);
		self.playState = 1;
		self;
	},

	stopHarmonica: { | self |
		Pbindef(\harmonica).stop;
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
