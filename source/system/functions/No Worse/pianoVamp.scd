/*
Saturday, August 17th 2013
pianoVamp.scd
prm
*/


~worse.pianoVamp = (

	state: 0,
	muteState: 0,
	playState: 0,
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
		self.pianoGroup = Group.new(self.fader, \addBefore);
		self;
	},

	killGroups: { | self |
		self.pianoGroup.free;
		self;
	},

	makeBuffers: { | self |
		var path = "/Users/patrickmcminn/Documents/Music/Current Work/Patrick McMinn/Great Noise Ensemble/Beatles Concert/Beatles/data/No Worse/";
		self.g5Buf = Buffer.read(s, path ++ "G5.aif");
		self.g6Buf = Buffer.read(s, path ++ "G6.aif");
		self.c6Buf = Buffer.read(s, path ++ "C6.aif");
		self.e6Buf = Buffer.read(s, path ++ "E6.aif");
		self;
	},

	killBuffers: { | self |
		self.g5Buf.free;
		self.g6Buf.free;
		self.c6Buf.free;
		self.e6Buf.free;
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
		self.fader = Synth.tail(~group.fx, \stereoFader, [\in, self.faderBus, \out, self.output, \amp, 1]);
		self;
	},

	killSynths: { | self |
		self.fader.free;
		self;
	},

	makePatterns: { | self |
		Pbindef(\g5,
			\instrument, \playBufStereo,
			\group, self.pianoGroup,
			\addAction, \addToTail,
			\out, self.faderBus,
			\bufName, self.g5Buf,
			\sustain, 2,
			\dur, Pseq([0.5, 0.5, 0.5, 0.5, 1/3, 1/3, 1/3, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1/3, 1/3, 1/3], inf),
			\note, Pseq([1, \r, 1, \r, 1, \r, 1, 1, \r, 1, \r, 1, \r, 1, \r, 1], inf),
			\amp, Pwhite(0.9, 1.4),
			\rate, Pwhite(0.99, 1.01),
			\attack, Pwhite(0.05, 0.5),
			\pan, Pwhite(-1, 1)
		);
		Pbindef(\g6,
			\instrument, \playBufStereo,
			\group, self.pianoGroup,
			\addAction, \addToTail,
			\out, self.faderBus,
			\bufName, self.g6Buf,
			\sustain, 2,
			\dur, Pseq([0.5, 0.5, 0.5, 0.5, 1/3, 1/3, 1/3, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1/3, 1/3, 1/3], inf),
			\note, Pseq([1, \r, 1, \r, 1, \r, 1, 1, \r, 1, \r, 1, \r, 1, \r, 1], inf),
			\amp, Pwhite(0.9, 1.4),
			\rate, Pwhite(0.99, 1.01),
			\attack, Pwhite(0.05, 0.5),
			\pan, Pwhite(-1, 1)
		);
		Pbindef(\e6,
			\instrument, \playBufStereo,
			\group, self.pianoGroup,
			\addAction, \addToTail,
			\out, self.faderBus,
			\bufName, self.e6Buf,
			\sustain, 2,
			\dur, Pseq([0.5, 0.5, 0.5, 0.5, 1/3, 1/3, 1/3, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1/3, 1/3, 1/3], inf),
			\note, Pseq([1, \r, 1, \r, 1, \r, 1, 1, \r, 1, \r, 1, \r, 1, \r, 1], inf),
			\amp, Pwhite(0.9, 1.6),
			\rate, Pwhite(0.99, 1.01),
			\attack, Pwhite(0.05, 0.5),
			\pan, Pwhite(-1, 1)
		);
		Pbindef(\c6,
			\instrument, \playBufStereo,
			\group, self.pianoGroup,
			\addAction, \addToTail,
			\out, self.faderBus,
			\bufName, self.c6Buf,
			\sustain, 2,
			\dur, Pseq([0.5, 0.5, 0.5, 0.5, 1/3, 1/3, 1/3, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1/3, 1/3, 1/3], inf),
			\note, Pseq([1, \r, 1, \r, 1, \r, 1, 1, \r, 1, \r, 1, \r, 1, \r, 1], inf),
			\amp, Pwhite(0.9, 1.6),
			\rate, Pwhite(0.99, 1.01),
			\attack, Pwhite(0.05, 0.5),
			\pan, Pwhite(-1, 1)
		);
		self;
	},

	killPatterns: { | self |
		Pbindef(\g5).remove;
		Pbindef(\g6).remove;
		Pbindef(\c6).remove;
		Pbindef(\e6).remove;
		self;
	},

	toggleVamp: { | self |
		if( self.playState == 0, { self.playVamp; }, { self.stopVamp; });
		self;
	},

	playVamp: { | self |
		Pbindef(\g5).play(self.tempoClock);
		Pbindef(\g6).play(self.tempoClock);
		Pbindef(\e6).play(self.tempoClock);
		Pbindef(\c6).play(self.tempoClock);
		self.playState = 1;
		self;
	},

	stopVamp: { | self |
		Pbindef(\g5).stop;
		Pbindef(\g6).stop;
		Pbindef(\e6).stop;
		Pbindef(\c6).stop;
		self.playState = 0;
		self;
	},

	disruptTempo: { | self |
		self.tempoClock.tempo = (rrand(300, 500)/60);
		self;
	},

	resetTempo: { | self |
		self.tempoClock.tempo = 110/60;
		self;
	},

	playChord: { | self |
		Synth.tail(self.pianoGroup, \playBufStereo,
			[\bufName, self.g5Buf, \out, self.faderBus, \sustain, 2, \amp, rrand(0.9, 1.4),
				\rate, rrand(0.99, 1.01), \attack, rrand(0.05, 0.5), \pan, rrand(-1.0, 1.0)]);
		Synth.tail(self.pianoGroup, \playBufStereo,
			[\bufName, self.g6Buf, \out, self.faderBus, \sustain, 2, \amp, rrand(0.9, 1.4),
				\rate, rrand(0.99, 1.01), \attack, rrand(0.05, 0.5), \pan, rrand(-1.0, 1.0)]);
		Synth.tail(self.pianoGroup, \playBufStereo,
			[\bufName, self.c6Buf, \out, self.faderBus, \sustain, 2, \amp, rrand(0.9, 1.4),
				\rate, rrand(0.99, 1.01), \attack, rrand(0.05, 0.5), \pan, rrand(-1.0, 1.0)]);
		Synth.tail(self.pianoGroup, \playBufStereo,
			[\bufName, self.e6Buf, \out, self.faderBus, \sustain, 2, \amp, rrand(0.9, 1.4),
				\rate, rrand(0.99, 1.01), \attack, rrand(0.05, 0.5), \pan, rrand(-1.0, 1.0)]);
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