/*
Wednesday, August 28th 2013
vibraphone.scd
prm
*/

~billy.vibraphone = (

	state: 0,
	output: ~mixer.s2,
	bufferState: 0,

	spawn: { | self |
		if( self.state == 0, { self.init; }, { self.kill; });
		self;
	},

	init: { | self |
		self.makeGroups;
		self.makeBuffers;
		self.makeBusses;
		self.makeSynths;
		self.state = 1;
		self;
	},

	kill: { | self |
		self.killGroups;
		self.killBuffers;
		self.killBusses;
		self.killSynths;
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
		self.buffer = Buffer.alloc(s, s.sampleRate * 1.7);
		self.bufferState = 1;
		self;
	},

	killBuffers: { | self |
		self.buffer.free;
		self;
	},

	toggleFakeBuffer: { | self |
		if ( self.bufferState == 0, { self.killFakeBuffer; }, { self.makeFakeBuffer; });
		self;
	},

	makeFakeBuffer: { | self |
		var path = "/Users/patrickmcminn/Documents/Music/Current Work/Patrick McMinn/Great Noise Ensemble/Beatles Concert/Beatles/data/Billy Shears/";
		self.buffer = Buffer.read(s, path ++ "f#m9.aif");
		self.bufferState = 0;
		self;
	},

	killFakeBuffer: { | self |
		self.buffer = Buffer.alloc(s, s.sampleRate * 1.7);
		self.bufferState = 1;
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
		self.fader = Synth.tail(~group.fx, \stereoFader, [\in, self.faderBus, \out, self.output, \amp, -6.dbamp]);
		self;
	},

	killSynths: { | self |
		self.fader.free;
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