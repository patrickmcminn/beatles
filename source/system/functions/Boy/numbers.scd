/*
Friday, August 30th, 2013
numbers.scd
prm
*/

~boy.numbers = (

	state: 0,
	muteState: 0,
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
		self.killBuffers;
		self.killBusses;
		self.killSynths;
		self.killGroups;
		self.state = 0;
		self;
	},

	makeGroups: { | self |
		self.playGroup = Group.new(self.filter, \addBefore);
		self;
	},

	killGroups: { | self |
		self.playGroup.free;
		self;
	},

	makeBuffers: { | self |
		var path = "/Users/patrickmcminn/Documents/Music/Current Work/Patrick McMinn/Great Noise Ensemble/Beatles Concert/Beatles/data/Oh Boy/";
		self.buffer1 = [
			Buffer.read(s, path ++ "1-1.aif"),
			Buffer.read(s, path ++ "1-2.aif"),
			Buffer.read(s, path ++ "1-3.aif"),
			Buffer.read(s, path ++ "1-4.aif"),
			Buffer.read(s, path ++ "1-5.aif")
		];
		self.buffer2 = [
			Buffer.read(s, path ++ "2-1.aif"),
			Buffer.read(s, path ++ "2-2.aif"),
			Buffer.read(s, path ++ "2-3.aif")
		];
		self.buffer3 = [
			Buffer.read(s, path ++ "3-1.aif"),
			Buffer.read(s, path ++ "3-2.aif"),
			Buffer.read(s, path ++ "3-3.aif"),
			Buffer.read(s, path ++ "3-4.aif"),
			Buffer.read(s, path ++ "3-5.aif"),
		];
		self.buffer4 = [
			Buffer.read(s, path ++ "4-1.aif"),
			Buffer.read(s, path ++ "4-2.aif"),
			Buffer.read(s, path ++ "4-3.aif"),
			Buffer.read(s, path ++ "4-4.aif"),
			Buffer.read(s, path ++ "4-5.aif"),
			Buffer.read(s, path ++ "4-6.aif"),
		];
		self.buffer5 = [
			Buffer.read(s, path ++ "5-1.aif"),
			Buffer.read(s, path ++ "5-2.aif"),
			Buffer.read(s, path ++ "5-3.aif"),
			Buffer.read(s, path ++ "5-4.aif")
		];
		self.buffer6 = [
			Buffer.read(s, path ++ "6-1.aif"),
			Buffer.read(s, path ++ "6-2.aif"),
			Buffer.read(s, path ++ "6-3.aif")
		];
		self.buffer7 = [
			Buffer.read(s, path ++ "7-1.aif"),
			Buffer.read(s, path ++ "7-2.aif"),
			Buffer.read(s, path ++ "7-3.aif"),
			Buffer.read(s, path ++ "7-4.aif")
		];
		self.buffer8 = [
			Buffer.read(s, path ++ "8-1.aif"),
			Buffer.read(s, path ++ "8-2.aif"),
			Buffer.read(s, path ++ "8-3.aif"),
			Buffer.read(s, path ++ "8-4.aif"),
			Buffer.read(s, path ++ "8-5.aif"),
		];
		self.buffer9 = [
			Buffer.read(s, path ++ "9-1.aif"),
			Buffer.read(s, path ++ "9-2.aif"),
			Buffer.read(s, path ++ "9-3.aif"),
			Buffer.read(s, path ++ "9-4.aif"),
			Buffer.read(s, path ++ "9-5.aif"),
		];
		self.buffer10 = [
			Buffer.read(s, path ++ "10-1.aif"),
			Buffer.read(s, path ++ "10-2.aif"),
			Buffer.read(s, path ++ "10-3.aif"),
			Buffer.read(s, path ++ "10-4.aif"),
		];
		self.buffer11 = [
			Buffer.read(s, path ++ "11-1.aif"),
			Buffer.read(s, path ++ "11-2.aif"),
			Buffer.read(s, path ++ "11-3.aif"),
		];
		self.buffer12 = [
			Buffer.read(s, path ++ "12-1.aif"),
			Buffer.read(s, path ++ "12-2.aif"),
			Buffer.read(s, path ++ "12-3.aif"),
		];
		self.buffer13 = [
			Buffer.read(s, path ++ "13-1.aif"),
			Buffer.read(s, path ++ "13-2.aif"),
			Buffer.read(s, path ++ "13-3.aif"),
		];
		self.buffer14 = [
			Buffer.read(s, path ++ "14-1.aif"),
			Buffer.read(s, path ++ "14-2.aif"),
			Buffer.read(s, path ++ "14-3.aif"),
		];
		self.buffer15 = [
			Buffer.read(s, path ++ "15-1.aif");
			Buffer.read(s, path ++ "15-2.aif");
			Buffer.read(s, path ++ "15-3.aif");
		];
		self.buffer16 = [
			Buffer.read(s, path ++ "16-1.aif"),
			Buffer.read(s, path ++ "16-2.aif"),
			Buffer.read(s, path ++ "16-3.aif"),
		];
		self.buffer17 = [
			Buffer.read(s, path ++ "17-1.aif"),
			Buffer.read(s, path ++ "17-2.aif"),
			Buffer.read(s, path ++ "17-3.aif"),
		];
		self.buffer18 = [
			Buffer.read(s, path ++ "18-1.aif"),
			Buffer.read(s, path ++ "18-2.aif"),
			Buffer.read(s, path ++ "18-3.aif"),
		];
		self.buffer19 = [
			Buffer.read(s, path ++ "19-1.aif"),
			Buffer.read(s, path ++ "19-2.aif"),
			Buffer.read(s, path ++ "19-3.aif"),
		];
		self.buffer20 = [
			Buffer.read(s, path ++ "20-1.aif"),
			Buffer.read(s, path ++ "20-2.aif"),
			Buffer.read(s, path ++ "20-3.aif"),
		];
		self.buffer21 = [
			Buffer.read(s, path ++ "21-1.aif"),
			Buffer.read(s, path ++ "21-2.aif"),
		];
		self.buffer22 = [
			Buffer.read(s, path ++ "22-1.aif"),
			Buffer.read(s, path ++ "22-2.aif"),
		];
		self.buffer23 = [
			Buffer.read(s, path ++ "23-1.aif"),
			Buffer.read(s, path ++ "23-2.aif"),
		];
		self.buffer24 = [
			Buffer.read(s, path ++ "24-1.aif"),
			Buffer.read(s, path ++ "24-2.aif"),
		];
		self.buffer540 = Buffer.read(s, path ++ "540.aif");
		self.buffer6959 = Buffer.read(s, path ++ "6959.aif");

		self;
	},

	killBuffers: { | self |
		self.buffer1.do({ | buf | buf.free; });
		self.buffer2.do({ | buf | buf.free; });
		self.buffer3.do({ | buf | buf.free; });
		self.buffer4.do({ | buf | buf.free; });
		self.buffer5.do({ | buf | buf.free; });
		self.buffer6.do({ | buf | buf.free; });
		self.buffer7.do({ | buf | buf.free; });
		self.buffer8.do({ | buf | buf.free; });
		self.buffer9.do({ | buf | buf.free; });
		self.buffer10.do({ | buf | buf.free; });
		self.buffer11.do({ | buf | buf.free; });
		self.buffer12.do({ | buf | buf.free; });
		self.buffer13.do({ | buf | buf.free; });
		self.buffer14.do({ | buf | buf.free; });
		self.buffer15.do({ | buf | buf.free; });
		self.buffer16.do({ | buf | buf.free; });
		self.buffer17.do({ | buf | buf.free; });
		self.buffer18.do({ | buf | buf.free; });
		self.buffer19.do({ | buf | buf.free; });
		self.buffer20.do({ | buf | buf.free; });
		self.buffer21.do({ | buf | buf.free; });
		self.buffer22.do({ | buf | buf.free; });
		self.buffer23.do({ | buf | buf.free; });
		self.buffer24.do({ | buf | buf.free; });
		self.buffer540.free;
		self.buffer6959.free;
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
		self.filter = Synth.tail(~group.fx, \lowPassFilterS, [\in, self.faderBus, \out, self.faderBus, \cutoff, 1000]);
		self.fader = Synth.tail(~group.fx, \stereoFader, [\in, self.faderBus, \out, self.output, \amp, -12.dbamp]);
		self;
	},

	killSynths: { | self |
		self.fader.free;
		self;
	},

	play1: { | self |
		Synth.tail(self.playGroup, \playBufStereo, [\out, self.faderBus,
			\bufName, self.buffer1.choose, \rate, rrand(0.95, 1.05), \pan, rrand(-0.7, 0.7),
			\attack, 0.01, \sustain, 3, \release, 0.01]);
		self;
	},

	play2: { | self |
		Synth.tail(self.playGroup, \playBufStereo, [\out, self.faderBus,
			\bufName, self.buffer2.choose, \rate, rrand(0.95, 1.05), \pan, rrand(-0.7, 0.7),
			\attack, 0.01, \sustain, 3, \release, 0.01]);
		self;
	},

	play3: { | self |
		Synth.tail(self.playGroup, \playBufStereo, [\out, self.faderBus,
			\bufName, self.buffer3.choose, \rate, rrand(0.95, 1.05), \pan, rrand(-0.7, 0.7),
			\attack, 0.01, \sustain, 3, \release, 0.01]);
		self;
	},

	play4: { | self |
		Synth.tail(self.playGroup, \playBufStereo, [\out, self.faderBus,
			\bufName, self.buffer4.choose, \rate, rrand(0.95, 1.05), \pan, rrand(-0.7, 0.7),
			\attack, 0.01, \sustain, 3, \release, 0.01]);
		self;
	},

	play5: { | self |
		Synth.tail(self.playGroup, \playBufStereo, [\out, self.faderBus,
			\bufName, self.buffer5.choose, \rate, rrand(0.95, 1.05), \pan, rrand(-0.7, 0.7),
			\attack, 0.01, \sustain, 3, \release, 0.01]);
		self;
	},

	play6: { | self |
		Synth.tail(self.playGroup, \playBufStereo, [\out, self.faderBus,
			\bufName, self.buffer6.choose, \rate, rrand(0.95, 1.05), \pan, rrand(-0.7, 0.7),
			\attack, 0.01, \sustain, 3, \release, 0.01]);
		self;
	},

	play7: { | self |
		Synth.tail(self.playGroup, \playBufStereo, [\out, self.faderBus,
			\bufName, self.buffer7.choose, \rate, rrand(0.95, 1.05), \pan, rrand(-0.7, 0.7),
			\attack, 0.01, \sustain, 3, \release, 0.01]);
		self;
	},

	play8: { | self |
		Synth.tail(self.playGroup, \playBufStereo, [\out, self.faderBus,
			\bufName, self.buffer8.choose, \rate, rrand(0.95, 1.05), \pan, rrand(-0.7, 0.7),
			\attack, 0.01, \sustain, 3, \release, 0.01]);
		self;
	},

	play9: { | self |
		Synth.tail(self.playGroup, \playBufStereo, [\out, self.faderBus,
			\bufName, self.buffer9.choose, \rate, rrand(0.95, 1.05), \pan, rrand(-0.7, 0.7),
			\attack, 0.01, \sustain, 3, \release, 0.01]);
		self;
	},

	play10: { | self |
		Synth.tail(self.playGroup, \playBufStereo, [\out, self.faderBus,
			\bufName, self.buffer10.choose, \rate, rrand(0.95, 1.05), \pan, rrand(-0.7, 0.7),
			\attack, 0.01, \sustain, 3, \release, 0.01]);
		self;
	},

	play11: { | self |
		Synth.tail(self.playGroup, \playBufStereo, [\out, self.faderBus,
			\bufName, self.buffer11.choose, \rate, rrand(0.95, 1.05), \pan, rrand(-0.7, 0.7),
			\attack, 0.01, \sustain, 3, \release, 0.01]);
		self;
	},

	play12: { | self |
		Synth.tail(self.playGroup, \playBufStereo, [\out, self.faderBus,
			\bufName, self.buffer12.choose, \rate, rrand(0.95, 1.05), \pan, rrand(-0.7, 0.7),
			\attack, 0.01, \sustain, 3, \release, 0.01]);
		self;
	},

	play13: { | self |
		Synth.tail(self.playGroup, \playBufStereo, [\out, self.faderBus,
			\bufName, self.buffer13.choose, \rate, rrand(0.95, 1.05), \pan, rrand(-0.7, 0.7),
			\attack, 0.01, \sustain, 3, \release, 0.01]);
		self;
	},

	play14: { | self |
		Synth.tail(self.playGroup, \playBufStereo, [\out, self.faderBus,
			\bufName, self.buffer14.choose, \rate, rrand(0.95, 1.05), \pan, rrand(-0.7, 0.7),
			\attack, 0.01, \sustain, 3, \release, 0.01]);
		self;
	},

	play15: { | self |
		Synth.tail(self.playGroup, \playBufStereo, [\out, self.faderBus,
			\bufName, self.buffer15.choose, \rate, rrand(0.95, 1.05), \pan, rrand(-0.7, 0.7),
			\attack, 0.01, \sustain, 3, \release, 0.01]);
		self;
	},

	play16: { | self |
		Synth.tail(self.playGroup, \playBufStereo, [\out, self.faderBus,
			\bufName, self.buffer16.choose, \rate, rrand(0.95, 1.05), \pan, rrand(-0.7, 0.7),
			\attack, 0.01, \sustain, 3, \release, 0.01]);
		self;
	},

	play17: { | self |
		Synth.tail(self.playGroup, \playBufStereo, [\out, self.faderBus,
			\bufName, self.buffer17.choose, \rate, rrand(0.95, 1.05), \pan, rrand(-0.7, 0.7),
			\attack, 0.01, \sustain, 3, \release, 0.01]);
		self;
	},

	play18: { | self |
		Synth.tail(self.playGroup, \playBufStereo, [\out, self.faderBus,
			\bufName, self.buffer18.choose, \rate, rrand(0.95, 1.05), \pan, rrand(-0.7, 0.7),
			\attack, 0.01, \sustain, 3, \release, 0.01]);
		self;
	},

	play19: { | self |
		Synth.tail(self.playGroup, \playBufStereo, [\out, self.faderBus,
			\bufName, self.buffer19.choose, \rate, rrand(0.95, 1.05), \pan, rrand(-0.7, 0.7),
			\attack, 0.01, \sustain, 3, \release, 0.01]);
		self;
	},

	play20: { | self |
		Synth.tail(self.playGroup, \playBufStereo, [\out, self.faderBus,
			\bufName, self.buffer20.choose, \rate, rrand(0.95, 1.05), \pan, rrand(-0.7, 0.7),
			\attack, 0.01, \sustain, 3, \release, 0.01]);
		self;
	},

	play21: { | self |
		Synth.tail(self.playGroup, \playBufStereo, [\out, self.faderBus,
			\bufName, self.buffer21.choose, \rate, rrand(0.95, 1.05), \pan, rrand(-0.7, 0.7),
			\attack, 0.01, \sustain, 3, \release, 0.01]);
		self;
	},

	play22: { | self |
		Synth.tail(self.playGroup, \playBufStereo, [\out, self.faderBus,
			\bufName, self.buffer22.choose, \rate, rrand(0.95, 1.05), \pan, rrand(-0.7, 0.7),
			\attack, 0.01, \sustain, 3, \release, 0.01]);
		self;
	},

	play23: { | self |
		Synth.tail(self.playGroup, \playBufStereo, [\out, self.faderBus,
			\bufName, self.buffer23.choose, \rate, rrand(0.95, 1.05), \pan, rrand(-0.7, 0.7),
			\attack, 0.01, \sustain, 3, \release, 0.01]);
		self;
	},

	play24: { | self |
		Synth.tail(self.playGroup, \playBufStereo, [\out, self.faderBus,
			\bufName, self.buffer24.choose, \rate, rrand(0.95, 1.05), \pan, rrand(-0.7, 0.7),
			\attack, 0.01, \sustain, 3, \release, 0.01]);
		self;
	},

	play540: { | self |
		Synth.tail(self.playGroup, \playBufStereo, [\out, self.faderBus,
			\bufName, self.buffer540, \rate, rrand(0.95, 1.05), \pan, rrand(-0.7, 0.7),
			\attack, 0.01, \sustain, 3, \release, 0.01]);
		self;
	},

	play6959: { | self |
		Synth.tail(self.playGroup, \playBufStereo, [\out, self.faderBus,
			\bufName, self.buffer6959, \rate, rrand(0.9, 1.1), \pan, rrand(-0.7, 0.7),
			\attack, 0.01, \sustain, 7, \release, 0.01]);
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