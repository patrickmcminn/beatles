/*
Saturday, August 17th 2013
brokenPiano.scd
prm
*/

~worse.brokenPiano = (

	state: 0,
	muteState: 0,
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
		self.blockGroup = Group.new(self.fader, \addBefore);
		self;
	},

	killGroups: { | self |
		self.blockGroup.free;
		self;
	},

	makeBuffers: { | self |
		var path = "/Users/patrickmcminn/Documents/Music/Current Work/Patrick McMinn/Great Noise Ensemble/Beatles Concert/Beatles/data/No Worse/";
		self.buffer = [
			Buffer.read(s, path ++ "Broken1.aif"),
			Buffer.read(s, path ++ "Broken2.aif"),
			Buffer.read(s, path ++ "Broken3.aif"),
			Buffer.read(s, path ++ "Broken7.aif"),
			Buffer.read(s, path ++ "Broken8.aif")
		];
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
		self.fader = Synth.tail(~group.fx, \stereoFader, [\in, self.faderBus, \out, self.output, \amp, -2.dbamp]);
		self;
	},

	killSynths: { | self |
		self.fader.free;
		self;
	},

	makeBlocks: { | self |

		OSCdef(\worseBlock1, { | msg |
			var amp = msg.at(3);
			Synth.tail(self.blockGroup, \playBufStereo,
				[
					\out, self.faderBus,
					\bufName, [~brokenBuf[0], ~brokenBuf[0], ~brokenBuf[0], ~brokenBuf[1], ~brokenBuf[2]].choose,
					\amp, amp * 1.5,
					\pan, rrand(-0.2, 0.2)
				]);
		}, \block1);

		OSCdef(\worseBlock2, { | msg |
			var amp = msg.at(3);
			Synth.tail(self.blockGroup,\playBufStereo,
				[
					\out, self.faderBus,
					\bufName, ~brokenBuf[6], \amp, amp* 2.2,
					\pan, rrand(-0.2, 0.2)
				]);
		}, \block2);

		OSCdef(\worseBlock3, { | msg |
			var amp = msg.at(3);
			Synth.tail(self.blockGroup, \playBufStereo,
					[
						\out, self.faderBus,
						\bufName, ~brokenBuf[7], \amp, amp* 2.2,
						\pan, rrand(-0.1, 0.1);
					]);
		}, \block3);

		self;
	},

	killBlocks: { | self |
		OSCdef(\worseBlock1).free;
		OSCdef(\worseBlock2).free;
		OSCdef(\worseBlock3).free;
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