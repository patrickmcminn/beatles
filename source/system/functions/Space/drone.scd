/*
Sunday, September 1st 2013
drone.scd
prm
*/

~space.drone = (

	state: 0,
	bufferState: 0,

	gran1State: 0,
	gran2State: 0,
	gran3State: 0,
	gran4State: 0,

	input: ~inst.mic,
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
		self.playGroup = Group.new(self.fader, \addBefore);
		self;
	},

	killGroups: { | self |
		self.playGroup.free;
		self;
	},

	makeBuffers: { | self |
		self.buffer = Buffer.allocConsecutive(4, s, s.sampleRate * 0.5);
		self.bufferState = 1;
		self;
	},

	killBuffers: { | self |
		self.buffer.do({ | buf | buf.free; });
		self;
	},

	toggleFakeBuffers: { | self |
		if ( self.bufferState == 0, { self.killFakeBuffers; }, { self.makeFakeBuffers; });
		self;
	},

	makeFakeBuffers: { | self |
		var path = "/Users/patrickmcminn/Documents/Music/Current Work/Patrick McMinn/Great Noise Ensemble/Beatles Concert/Beatles/data/Space/";
		self.buffer = [
			Buffer.read(s, path ++ "drone 1.aif"),
			Buffer.read(s, path ++ "drone 2.aif"),
			Buffer.read(s, path ++ "drone 3.aif"),
			Buffer.read(s, path ++ "drone 4.aif")
				];
		self.bufferState = 0;
		self;
	},

	killFakeBuffers: { | self |
		self.makeBuffers;
		self.bufferState = 1;
		self;
	},

	makeBusses: { | self |
		self.cutoffBus = Bus.control;
		self.faderBus = Bus.audio(s, 2);
		self;
	},

	killBusses: { | self |
		self.cutoffBus.free;
		self.faderBus.free;
		self;
	},

	makeSynths: { | self |
		self.cutoff = Synth.tail(~group.control, \noiseControl2, [\out, self.cutoffBus, \freq, 1, \rangeLo, 300, \rangeHi, 2500]);
		self.fader = Synth.tail(~group.fx, \stereoFader, [\in, self.faderBus, \out, self.output, \amp, -4.dbamp]);
		self;
	},

	killSynths: { | self |
		self.cutoff.free;
		self.fader.free;
		self;
	},

	recordBuf: { | self, buf |
		Synth.tail(~group.fx, \recordBuf, [\in, self.input, \bufName, self.buffer[buf]]);
		self;
	},

	toggleGran1: { | self |
		if( self.gran1State == 0, { self.playGran1; }, { self.stopGran1; });
		self;
	},

	playGran1: { | self |
		self.gran1 = Synth.tail(self.playGroup, \freezePlayerSus2, [\buffer, self.buffer[0], \out, self.faderBus,
			\posLo, 0.1, \posHi, 0.8, \trigRate, 7, \grainDurLo, 0.1, \grainDurHi, 0.3, \cutoff, 5000]);
		self.gran1State = 1;
		self;
	},

	stopGran1: {  | self |
		self.gran1.set(\gate, 0);
		self.gran1State = 0;
		self;
	},

	toggleGran2: { | self |
		if( self.gran2State == 0, { self.playGran2; }, { self.stopGran2; });
		self;
	},

	playGran2: { | self |
		self.gran2 = Synth.tail(self.playGroup, \freezePlayerSus2, [\buffer, self.buffer[1], \out, self.faderBus,
			\trigRate, 7, \grainDurLo, 0.1, \grainDurHi, 0.3, \cutoff, 2500, \amp, 0.5]);
		self.gran2State = 1;
		self;
	},

	stopGran2: {  | self |
		self.gran2.set(\gate, 0);
		self.gran2State = 0;
		self;
	},

	toggleGran3: { | self |
		if( self.gran3State == 0, { self.playGran3; }, { self.stopGran3; });
		self;
	},

	playGran3: { | self |
		self.gran3 = Synth.tail(self.playGroup, \freezePlayerSus2, [\buffer, self.buffer[2], \out, self.faderBus,
			\trigRate, 7, \grainDurLo, 0.1, \grainDurHi, 0.3, \cutoff, 5000]);
		self.gran3State = 1;
		self;
	},

	stopGran3: {  | self |
		self.gran3.set(\gate, 0);
		self.gran3State = 0;
		self;
	},

	toggleGran4: { | self |
		if( self.gran4State == 0, { self.playGran4; }, { self.stopGran4; });
		self;
	},

	playGran4: { | self |
		self.gran4 = Synth.tail(self.playGroup, \freezePlayerSus2, [\buffer, self.buffer[3], \out, self.faderBus,
			\trigRate, 100, \grainDurLo, 0.1, \grainDurHi, 0.3, \cutoff, self.cutoffBus.asMap]);
		self.gran4State = 1;
		self;
	},

	stopGran4: {  | self |
		self.gran4.set(\gate, 0);
		self.gran4State = 0;
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