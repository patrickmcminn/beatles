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
		self.playGroup = Group.new(self.shift1, \addBefore);
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
		self.shiftBus1 = Bus.audio(s, 2);
		self.shiftBus2 = Bus.audio(s, 2);
		self.shiftBus3 = Bus.audio(s, 2);
		self.shiftBus4 = Bus.audio(s, 2);
		self.shiftBus5 = Bus.audio(s, 2);
		self.shiftBus6 = Bus.audio(s, 2);
		self.shiftBus7 = Bus.audio(s, 2);
		self.shiftBus8 = Bus.audio(s, 2);
		self.faderBus = Bus.audio(s, 2);
		self;
	},

	killBusses: { | self |
		self.shiftBus1.free;
		self.shiftBus2.free;
		self.shiftBus3.free;
		self.shiftBus4.free;
		self.shiftBus5.free;
		self.shiftBus6.free;
		self.shiftBus7.free;
		self.shiftBus8.free;
		self.faderBus.free;
		self;
	},

	makeSynths: { | self |
		self.shift1 = Synth.tail(~group.fx, \multiShift, [\in, self.shiftBus1, \out, self.faderBus,
			\shiftFreq, 8, \shiftKind, 1,
			\shiftArray1, #[0, -9, -7, -5], \shiftArray2, #[0, 2, -2, 4], \shiftArray3, #[0, -9, -7, -5],
			\shiftArray4, #[-2, 2, 4, 5]]);
		self.shift2 = Synth.tail(~group.fx, \multiShift, [\in, self.shiftBus2, \out, self.faderBus,
			\shiftFreq, 2, \shiftKind, 1,
			\shiftArray1, #[0, 0, 0, 7], \shiftArray2, #[0, 0, 0, 5], \shiftArray3, #[0, 0, 0, 4],
			\shiftArray4, #[0, 0, 0, 2]]);
		self.shift3 = Synth.tail(~group.fx, \multiShift, [\in, self.shiftBus3, \out, self.faderBus,
			\shiftFreq, 8, \shiftKind, 1,
			\shiftArray1, #[0, 0, -1, -2], \shiftArray2, #[0, 0, -2, -4], \shiftArray3, #[0, 0, 1, 2],
			\shiftArray4, #[0, 0, 2, 4]]);
		self.shift4 = Synth.tail(~group.fx, \multiShift, [\in, self.shiftBus4, \out, self.faderBus,
			\shiftFreq, 15, \shiftKind, 0,
			\shiftArray1, #[0, 0, 7, 9], \shiftArray2, #[0, 0, 7, 9], \shiftArray3, #[0, 0, -2, -3],
			\shiftArray4, #[0, 0, -4, -5]]);
		self.shift5 = Synth.tail(~group.fx, \multiShift, [\in, self.shiftBus5, \out, self.faderBus,
			\shiftFreq, 8, \shiftKind, 1,
			\shiftArray1, #[0, -9, -7, -5], \shiftArray2, #[0, 2, -2, 4], \shiftArray3, #[0, -9, -7, -5],
			\shiftArray4, #[-2, 2, 4, 5]]);
		self.shift6 = Synth.tail(~group.fx, \multiShift, [\in, self.shiftBus6, \out, self.faderBus,
			\shiftFreq, 8, \shiftKind, 1,
			\shiftArray1, #[0, 0, 0, 7], \shiftArray2, #[0, 0, 0, 5], \shiftArray3, #[0, 0, 0, 4],
			\shiftArray4, #[0, 0, 0, 2]]);
		self.shift7 = Synth.tail(~group.fx, \multiShift, [\in, self.shiftBus7, \out, self.faderBus,
			\shiftFreq, 8, \shiftKind, 1,
			\shiftArray1, #[0, 0, -1, -2], \shiftArray2, #[0, 0, -2, -4], \shiftArray3, #[0, 0, 1, 2],
			\shiftArray4, #[0, 0, 2, 4]]);
		self.shift8 = Synth.tail(~group.fx, \multiShift, [\in, self.shiftBus8, \out, self.faderBus,
			\shiftFreq, 8, \shiftKind, 1,
			\shiftArray1, #[0, 0, 7, 9], \shiftArray2, #[0, 0, 7, 9], \shiftArray3, #[0, 0, -2, -3],
			\shiftArray4, #[0, 0, -4, -5]]);
		self.fader = Synth.tail(~group.fx, \stereoFader, [\in, self.faderBus, \out, self.output, \amp, -6.dbamp]);
		self;
	},

	killSynths: { | self |
		self.shift1.free;
		self.shift2.free;
		self.shift3.free;
		self.shift4.free;
		self.shift5.free;
		self.shift6.free;
		self.shift7.free;
		self.shift8.free;
		self.fader.free;
		self;
	},

	recordBells: { | self |
		Synth.tail(~group.fx, \recordBuf, [\in, self.input, \bufName, self.buffer]);
		self;
	},

	play1: { | self |
		self.bells1 = Synth.tail(self.playGroup, \playBufStereoSus,
			[
				\buffer, self.buffer, \out, self.shiftBus1, \startPos, 0, \rate, 0.75,
				\atk, 0.5, \dec, 0, \susLvl, 1, \rel, 4
			]
		);
		self;
	},

	stop1: { | self |
		self.bells1.set(\gate, 0);
		self;
	},

	play2: { | self |
		self.bells2 = Synth.tail(self.playGroup, \playBufStereoSus,
			[
				\buffer, self.buffer, \out, self.shiftBus2, \startPos, self.buffer.numFrames * 0.3, \rate, 1.5,
				\atk, 0.01, \dec, 0.5, \susLvl, 0.6, \rel, 0.2
			]
		);
		self;
	},

	stop2: { | self |
		self.bells2.set(\gate, 0);
		self;
	},

	play3: { | self |
		self.bells3 = Synth.tail(self.playGroup, \playBufStereoSus,
			[
				\buffer, self.buffer, \out, self.shiftBus3, \startPos, self.buffer.numFrames * 0.5, \rate, 0.5,
				\atk, 5, \dec, 0, \susLvl, 1, \rel, 7
			]
		);
		self;
	},

	stop3: { | self |
		self.bells3.set(\gate, 0);
		self;
	},

	play4: { | self |
		self.bells4 = Synth.tail(self.playGroup, \playBufStereoSus,
			[
				\buffer, self.buffer, \out, self.shiftBus4, \startPos, 0, \rate, 12,
				\atk, 0.05, \dec, 0.25, \susLvl, 0.5, \rel, 1
			]
		);
		self;
	},

	stop4: { | self |
		self.bells4.set(\gate, 0);
		self;
	},

	play5: { | self |
		self.bells5 = Synth.tail(self.playGroup, \freezePlayerSus2, [
			\out, self.shiftBus5, \buffer, self.buffer,
			\posLo, 0.2, \posHi, 0.3, \rateLo, 0.75, \rateHi, 0.85,
			\panLo, -0.1, \panHi, 0.1,
			\cutoff, 4000, \atk, 0.5, \rel, 2,
			]
		);
		self;
	},

	stop5: { | self |
		self.bells5.set(\gate, 0);
		self;
	},

	play6: { | self |
		self.bells6 = Synth.tail(self.playGroup, \freezePlayerSus2, [
			\out, self.shiftBus6, \buffer, self.buffer,
			\posLo, 0.6, \posHi, 0.65, \rateLo, 1.1, \rateHi, 1.5,
			\panLo, 0, \panHi, 0,
			\cutoff, 4000, \atk, 0.05, \dec, 1, \sus, 0.6, \rel, 2
			]
		);
		self;
	},

	stop6: { | self |
		self.bells6.set(\gate, 0);
		self;
	},

	play7: { | self |
		self.bells7 = Synth.tail(self.playGroup, \freezePlayerSus2, [
			\out, self.shiftBus7, \buffer, self.buffer,
			\posLo, 0, \posHi, 1, \rateLo, 0.5, \rateHi, 0.7,
			\trigRate, 7, \grainDurLo, 0.5, \grainDurHi, 1.5,
			\panLo, -0.5, \panHi, 0.5,
			\cutoff, 4000, \atk, 4, \rel, 6
			]
		);
		self;
	},

	stop7: { | self |
		self.bells7.set(\gate, 0);
		self;
	},

	play8: { | self |
		self.bells8 = Synth.tail(self.playGroup, \freezePlayerSus2, [
			\out, self.shiftBus8, \buffer, self.buffer,
			\posLo, 0.2, \posHi, 0.3, \rateLo, 12, \rateHi, 15,
			\panLo, 0, \panHi, 0,
			\cutoff, 2500, \atk, 0.05, \dec, 0.5, \sus, 0.5, \rel, 0.05,
			]
		);
		self;
	},

	stop8: { | self |
		self.bells8.set(\gate, 0);
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