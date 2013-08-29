/*
Wednesday, August 28th 2013
trumpetChords.scd
prm
*/

~billy.trumpetChords = (

	state: 0,
	muteState: 1,
	playState: 0,
	input: ~inst.mute,
	output: ~mixer.s1,

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
		self.playGroup = Group.new(self.verb, \addBefore);
		self;
	},

	killGroups: { | self |
		self.playGroup.free;
		self;
	},

	makeBuffers: { | self |
		self.buffer = Buffer.allocConsecutive(6, s, s.sampleRate * 0.5, 1);
		self;
	},

	killBuffers: { | self |
		self.buffer.do({ | i | i.free; });
		self;
	},

	makeBusses: { | self |
		self.verbBus = Bus.audio;
		self.faderBus = Bus.audio;
		self;
	},

	killBusses: { | self |
		self.verbBus.free;
		self.faderBus.free;
		self;
	},

	makeSynths: { | self |
		//self.inFader = Synth.tail(~group.fx, \fader, [\in, self.input, \out, self.verbBus, \amp, 1]);
		self.verb = Synth.tail(~group.fx, \convReverb, [\in, self.verbBus, \out, self.faderBus,
			\buffer, ~impulse[\cathedral1], \mix, 0.3]);
		self.fader = Synth.tail(~group.fx, \pan, [\in, self.faderBus, \out, self.output, \amp, -6.dbamp]);
		self;
	},

	killSynths: { | self |
		self.inFader.free;
		self.verb.free;
		self.fader.free;
		self;
	},

	makePatterns: { | self |
		Pbindef(\billyChords,
			\instrument, \freezePlayerSus2,
			\group, self.playGroup,
			\addAction, \addToTail,
			\out, self.verbBus,
			\buffer, [self.buffer[0], self.buffer[1], self.buffer[2], self.buffer[3], self.buffer[4], self.buffer[5]],
			\atk, 0.05,
			\rel, 0.05,
			\trigRate, 25,
			\legato, 1,
			\amp, 0.15,
			\dur, Pseq([4, 4*(8/9), 16*(4/5)], inf),
			\rateLo, Pseq([0.5, 9/16, 5/8], inf),
			\rateHi, Pkey(\rateLo),
			\cutoff, 1000,
			\env, ~grainBufs.gabWide
		);
		self;
	},

	togglePattern: { | self |
		if ( self.playState == 0, { self.playPattern; }, { self.stopPattern; });
		self;
	},

	playPattern: { | self |
		if( ~billy.transport.state == 1, {
			Pbindef(\billyChords).play(~billy.transport.tempoClock);
			self.playState = 1;
		});
		self;
	},

	stopPattern: { | self |
		Pbindef(\billyChords).stop;
		self.playState = 0;
		self;
	},

	recordTpt: { | self, buf |
		Synth.tail(~group.fx, \recordBuf, [\in, self.input, \bufName, self.buffer[buf]]);
		self;
	},

	toggleMute: { | self |
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