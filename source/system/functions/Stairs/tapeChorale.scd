/*
Sunday, September 1st 2013
tapeChorale.scd
prm
*/

~stairs.tapeChorale = (

	state: 0,

	playState: 0,
	erodeState: 0,

	tapeNoiseState: 0,
	radioNoise1State: 0,
	radioNoise2State: 0,

	radioNoise1Vol: 1,
	radioNoise2Vol: 1,
	tapeNoiseVol: 1,

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
		self.playGroup = Group.new(self.erosion, \addBefore);
		self;
	},

	killGroups: { | self |
		self.playGroup.free;
		self;
	},

	makeBuffers: { | self |
		var path = "/Users/patrickmcminn/Documents/Music/Current Work/Patrick McMinn/Great Noise Ensemble/Beatles Concert/Beatles/data/Stairs/";
		self.buffer = [
			Buffer.read(s, path ++ "tape chorale.aif"),
			Buffer.read(s, path ++ "Tape Noise.aif"),
			Buffer.read(s, path ++ "Radio Noise 1.aif"),
			Buffer.read(s, path ++ "Radio Noise 2.aif")
		];
		self;
	},

	killBuffers: { | self |
		self.buffer.do({ | buf | buf.free; });
		self;
	},

	makeBusses: { | self |
		self.erosionBus = Bus.audio(s, 2);
		self.faderBus = Bus.audio(s, 2);
		self;
	},

	killBusses: { | self |
		self.erosionBus.free;
		self.faderBus.free;
		self;
	},

	makeSynths: { | self |
		self.erosion = Synth.tail(~group.fx, \erosionStereo, [\in, self.erosionBus, \out, self.faderBus, \mix, 0,
			\cutoff, 1500, \decayTime, 3, \freq, 1000, \rangeLo, 0.001, \rangeHi, 0.2
		]);
		self.fader = Synth.tail(~group.fx, \stereoFader, [\in, self.faderBus, \out, self.output, \amp, 1]);
		self;
	},

	killSynths: { | self |
		self.erosion.free;
		self.fader.free;
		self;
	},

	toggleChorale: { | self |
		if( self.playState == 0, { self.playChorale; }, { self.stopChorale; });
		self;
	},

	playChorale: { | self |
		self.playState = 1;
		self.chorale = Synth.tail(self.playGroup, \playBufStereo, [\bufName, self.buffer[0], \out, self.erosionBus,
			\sustain, self.buffer[0].numFrames/s.sampleRate]);
		{
			self.playState = 0;
			~scLang.sendMsg(\stairsControl, \tapeChoralePlay, self.playState);
		}.defer(self.buffer[0].numFrames/s.sampleRate);
		self;
	},

	stopChorale: { | self |
		self.playState = 0;
		self.chorale.free;
		self;
	},

	toggleErosion: { | self |
		if( self.erodeState == 0, { self.erodeChorale; }, { self.stopErosion; });
		self;
	},

	erodeChorale: { | self |
		self.erosion.set(\mix, 1);
		self.erodeState = 1;
		self;
	},

	stopErosion: { | self |
		self.erosion.set(\mix, 0);
		self.erodeState = 0;
		self;
	},

	toggleTapeNoise: { | self |
		if( self.tapeNoiseState == 0, { self.playTapeNoise; }, { self.stopTapeNoise; });
		self;
	},

	playTapeNoise: { | self |
		self.tapeNoise = Synth.tail(self.playGroup, \playBufStereoSus, [\buffer, self.buffer[1], \out, self.erosionBus,
			\amp, self.tapeNoiseVol]);
		self.tapeNoiseState = 1;
		self;
	},

	stopTapeNoise: { | self |
		self.tapeNoise.set(\gate, 0);
		self.tapeNoiseState = 0;
		self;
	},

	toggleRadioNoise1: { | self |
		if( self.radioNoise1State == 0, { self.playRadioNoise1; }, { self.stopRadioNoise1; });
		self;
	},

	playRadioNoise1: { | self |
		self.radioNoise1 = Synth.tail(self.playGroup, \playBufStereoSus, [\buffer, self.buffer[2], \out, self.erosionBus,
			\amp, self.radioNoise1Vol ]);
		self.radioNoise1State = 1;
		self;
	},

	stopRadioNoise1: { | self |
		self.radioNoise1.set(\gate, 0);
		self.radioNoise1State = 0;
		self;
	},

	toggleRadioNoise2: { | self |
		if( self.radioNoise2State == 0, { self.playRadioNoise2; }, { self.stopRadioNoise2; });
		self;
	},

	playRadioNoise2: { | self |
		self.radioNoise2 = Synth.tail(self.playGroup, \playBufStereoSus, [\buffer, self.buffer[3], \out, self.erosionBus,
			\amp, self.radioNoise2Vol]);
		self.radioNoise2State = 1;
		self;
	},

	stopRadioNoise2: { | self |
		self.radioNoise2.set(\gate, 0);
		self.radioNoise2State = 0;
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