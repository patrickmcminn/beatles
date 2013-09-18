/*
Tuesday, August 20th 2013
taiko.scd
prm
*/

~lucy.taiko = (

	state: 0,
	muteState: 0,
	blockState: 0,
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
		self.state = 1;
		self;
	},

	kill: { | self |
		if( self.blockState == 1, { self.killBlocks; });
		self.killBuffers;
		self.killBusses;
		self.killSynths;
		self.killGroups;
		self.state = 0;
		self;
	},

	makeGroups: { | self |
		self.blockGroup = Group.new(self.phaser, \addBefore);
		self;
	},

	killGroups: { | self |
		self.blockGroup.free;
		self;
	},

	makeBuffers: { | self |
		var path = "/Users/patrickmcminn/Documents/Music/Current Work/Patrick McMinn/Great Noise Ensemble/Beatles Concert/Beatles/data/Lucy/";
		self.buffer = [
			Buffer.read(s, path ++ "Taiko Drum Hit 1-17.wav"),
			Buffer.read(s, path ++ "Taiko Drum Hit 1-23.wav"),
			Buffer.read(s, path ++ "Taiko Drum Hit 2-1.wav")
		];
		self;
	},

	killBuffers: { | self |
		self.buffer.do({ | i | i.free; });
		self;
	},

	makeBusses: { | self |
		self.phaserBus = Bus.audio(s, 2);
		self.faderBus = Bus.audio(s, 2);
		self;
	},

	killBusses: { | self |
		self.phaserBus.free;
		self.faderBus.free;
		self;
	},

	makeSynths: { | self |
		self.phaser = Synth.tail(~group.fx, \variPhaserStereo, [\in, self.phaserBus, \out, self.faderBus, \amp, 1,
			\delTime1, 0.01, \delTime2Lo, -0.00955, \delTime2Hi, 0.0005, \del2RateLo, 0.3, \del2RateHi, 1.3,
			\del2RateFreq, 3, \mix, 0.25]);
		self.fader = Synth.tail(~group.fx, \stereoFader, [\in, self.faderBus, \out, self.output, \amp, -2.dbamp]);
		self;
	},

	killSynths: { | self |
		self.phaser.free;
		self.fader.free;
		self;
	},

	toggleBlocks: { | self |
		if( self.blockState == 0, { self.makeBlocks; }, { self.killBlocks; });
		self;
	},

	makeBlocks: { | self |

		var ampMul = 2;

		OSCdef(\lucyBlock1, { | msg |
			var amp = msg.at(3);
			Synth.tail(self.blockGroup, \playBufStereo,
				[
					\out, self.phaserBus, \bufName, self.buffer[0],
					\amp, amp * ampMul,
					\pan, -0.5,
					\sustain, self.buffer[0].numFrames
				]
			);
		}, \block1);

		OSCdef(\lucyBlock2, { | msg |
			var amp = msg.at(3);
			Synth.tail(self.blockGroup, \playBufStereo,
				[
					\out, self.phaserBus, \bufName, self.buffer[1],
					\amp, amp * ampMul,
					\pan, 0,
					\sustain, self.buffer[1].numFrames
				]
			);
		}, \block2);

		OSCdef(\lucyBlock3, { | msg |
			var amp = msg.at(3);
			Synth.tail(self.blockGroup, \playBufStereo,
				[
					\out, self.phaserBus, \bufName, self.buffer[2],
					\amp, amp * ampMul,
					\pan, 0.5,
					\sustain, self.buffer[2].numFrames
				]
			);
		}, \block3);

		self.blockState = 1;
		self;
	},

	killBlocks: { | self |
		OSCdef(\lucyBlock1).free;
		OSCdef(\lucyBlock2).free;
		OSCdef(\lucyBlock3).free;
		self.blockState = 0;
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