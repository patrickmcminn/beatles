/*
Tuesday, August 27th 2013
harmonica.scd
prm
*/

~henry.harmonica = (
	state: 0,
	gestureState: 0,
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
		self.tempoClock = TempoClock.new(110/60);
		self;
	},

	killClock: { | self |
		self.tempoClock.clear;
		self;
	},

	makeGroups: { | self |
		self.melodyGroup = Group.new(self.fader1, \addBefore);
		self.gestureGroup = Group.new(self.verb, \addBefore);
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
		self.verbBus = Bus.audio(s, 2);
		self.fader1Bus = Bus.audio(s, 2);
		self.fader2Bus = Bus.audio(s, 2);
		self;
	},

	killBusses: { | self |
		self.verbBus.free;
		self.fader1Bus.free;
		self.fader2Bus.free;
		self;
	},

	makeSynths: { | self |
		self.fader1 = Synth.tail(~group.fx, \stereoFader, [\in, self.fader1Bus, \out, self.output, \amp, -6.dbamp]);
		self.verb = Synth.tail(~group.fx, \reverb2, [\in, self.verbBus, \out, self.fader2Bus,
			\mix, 0.6, \room, 0.8, \damp, 0.8]);
		self.fader2 = Synth.tail(~group.fx, \stereoFader, [\in, self.fader2Bus, \out, self.output, \amp, -2.dbamp]);
		self;
	},

	killSynths: { | self |
		self.fader1.free;
		self.fader2.free;
		self;
	},

	makePatterns: { | self |
		Pbindef(\harmonicaMelody,
			\instrument, \freezePlayer,
			\group, self.melodyGroup,
			\addAction, \addToTail,
			\out, self.fader1Bus,
			\buffer, Pfunc({ self.buffer[0] }),
			\atk, 0.05,
			\rel, 0.05,
			\rate, (Pseq([5/4, 9/8, 1, 9/8, 5/4, 1, 15/16, 1, 9/8, 15/16], 1))/2,
			\dur, Pseq([2, 2, 0.75, 0.25, 0.5, 0.5, 0.75, 0.25, 0.5, 0.5], 1),
			\sus, Pseq([2, 2, 0.75, 0.25, 0.5, 0.5, 0.75, 0.25, 0.5, 0.5], 1) - 0.1,
			//\note, Pseq([\r, 1], inf),
			\pan, Pbrown(-0.5, 0.5, 0.05, inf),
			\legato, 0,
			\amp, 1
		);
		Pbindef(\harmonicaGesture1,
			\instrument, \freezePlayer,
			\group, self.gestureGroup,
			\addAction, \addToTail,
			\out, self.verbBus,
			\buffer, Pfunc({ self.buffer[1] }),
			\atk, 0.05,
			\rel, 0.05,
			\rate, Pseq([2, 1.8751, 1.758, 1.648, 1.545, 1.448, 1.358, 1.273, 1.1934, 1.112, 1.045, 1, 1.045, 1.112,
				1.1934, 1.273, 1.5, 1.75], inf),
			\dur, Pseq([Pseq([1/3], 16), 1, 0.5], inf),
			\sus, Pseq([Pseq([0.23], 16), 0.9, 0.4], inf),
			\pan, Pbrown(-1, 1, 0.2, inf),
			\amp, Pwhite(-12.dbamp, -9.dbamp, inf)
		);
		Pbindef(\harmonicaGesture2,
			\instrument, \freezePlayer,
			\group, self.gestureGroup,
			\addAction, \addToTail,
			\out, self.verbBus,
			\buffer, Pfunc({ self.buffer[1] }),
			\atk, 0.05,
			\rel, 0.05,
			\rate, Pseq([1, 1.045, 1.112, 1.1934, 1.273, 1.358, 1.448, 1.545, 1.648, 1.758, 1.8751,  2, 1.112,
				1.1934, 1.273, 1.5, 1.75], inf),
			\dur, Pseq([Pseq([1/3], 16), 1, 0.5,], inf) + Pwhite(-0.05, 0.05),
			\sus, Pseq([Pseq([0.23], 16), 0.9, 0.4], inf),
			\pan, Pbrown(-1, 1, 0.2, inf),
			\amp, Pwhite(-12.dbamp, -9.dbamp, inf)
		);
		Pbindef(\harmonicaGesture3,
			\instrument, \freezePlayer,
			\group, self.gestureGroup,
			\addAction, \addToTail,
			\out, self.verbBus,
			\buffer, Pfunc({ self.buffer[1] }),
			\atk, 0.05,
			\rel, 0.05,
			\rate, Pseq([2, 1.8751, 1.758, 1.648, 1.545, 1.448, 1.358, 1.273, 1.1934, 1.112, 1.045, 1, 1.045, 1.112,
				1.1934, 1.273, 1.5, 1.75], inf),
			\dur, Pseq([Pseq([1/3], 16), 1, 0.5], inf) + Pwhite(-0.1, 0.1),
			\sus, Pseq([Pseq([0.23], 16), 0.9, 0.4], inf),
			\pan, Pbrown(-1, 1, 0.2, inf),
			\amp, Pwhite(-12.dbamp, -9.dbamp, inf)
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

	playMelody: { | self |
		Pbindef(\harmonicaMelody).play(self.tempoClock);
		self.melodyState = 1;
		self;
	},

	toggleGestures: { | self |
		if( self.gestureState == 0, { self.playGestures; }, { self.stopGestures; });
		self;
	},

	playGestures: { | self |
		Pbindef(\harmonicaGesture1).play(self.tempoClock);
		Pbindef(\harmonicaGesture2).play(self.tempoClock);
		Pbindef(\harmonicaGesture3).play(self.tempoClock);
		self.gestureState = 1;
		self;
	},

	stopGestures: { | self |
		Pbindef(\harmonicaGesture1).stop;
		Pbindef(\harmonicaGesture2).stop;
		Pbindef(\harmonicaGesture3).stop;
		self.gestureState = 0;
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
