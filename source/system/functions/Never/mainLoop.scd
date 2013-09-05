/*
Wednesday, September 4th 2013
mainLoop.scd
prm
*/

~never.mainLoop = (

	state: 0,
	panArray: [-0.9, -0.7, -0.5, -0.3, -0.1, 0.1, 0.3, 0.5, 0.7, 0.9],
	rateLo: 0.95,
	rateHi: 1.05,

	spawn: { | self |
		if( self.state == 0, { if( ~never.router.state == 1) { self.init; } }, { self.kill; });
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
		var path = "/Users/patrickmcminn/Documents/Music/Current Work/Patrick McMinn/Great Noise Ensemble/Beatles Concert/Beatles/data/Never Could See Any Other Way/";
		self.buffer = Array.newClear(10);
		10.do({ | i |
			self.buffer.put(i, Buffer.read(s, path ++ "loop" ++ (i + 1) ++".aif"));
			});
		self;
	},

	killBuffers: { | self |
		self.buffer.do({ | buf | buf.free; });
		self;
	},

	makeBusses: { | self |
		self.fadeLoBus = Bus.control;
		self.fadeHiBus = Bus.control;
		self.faderBus = Bus.audio(s, 2);
		self;
	},

	killBusses: { | self |
		self.fadeHiBus.free;
		self.fadeLoBus.free;
		self.faderBus.free;
		self;
	},

	makeSynths: { | self |
		self.fader = Synth.tail(~never.router.inGroup, \stereoFader, [\in, self.faderBus, \out, ~never.router.in1, \amp, 1]);
		self;
	},

	killSynths: { | self |
		self.fader.free;
		self;
	},

	playLoop: { | self, buf |
		self.put(("loop" ++ (buf + 1)).asSymbol,
			Synth.tail(self.playGroup, \playBufStereoSus, [\buffer, self.buffer[buf], \out, self.faderBus,
				\rate, rrand(self.rateLo, self.rateHi), \pan, self.panArray[buf]]);
		);
		self;
	},

	stopLoop: { | self, buf |
		self[("loop" ++ (buf+1)).asSymbol].set(\gate, 0);
		self;
	},

	fade: { | self |
		self.


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