/*
Monday, August 19th 2013
tptAccomp.scd
prm
*/

~never.tptAccomp = (

	state: 0,
	muteState: 0,
	playState: 0,
	output: ~mixer.s2,

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
		self.killPatterns;
		self.state = 0;
		self;
	},

	makeClock: { | self |
		self.tempoClock = TempoClock.new(145/60);
		self;
	},

	killClock: { | self |
		self.tempoClock.clear;
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
		self.buffer = Buffer.allocConsecutive(9, s, s.sampleRate * 0.5, 1);
		self;
	},

	killBuffers: { | self |
		self.buffer.do({ | i | i.free; });
		self;
	},

	makeBusses: { | self |
		self.faderBus = Bus.audio;
		self;
	},

	killBusses: { | self |
		self.faderBus.free;
		self;
	},

	makeSynths: { | self |
		self.fader = Synth.tail(~group.fx, \pan, [\in, self.faderBus, \out, self.output, \amp, -6.dbamp]);
		self;
	},

	killSynths: { | self |
		self.fader.free;
		self;
	},

	makePatterns: { | self |
		Pbindef(\neverTpt,
			\instrument, \playBufStereoSus,
			\group, self.playGroup,
			\addAction, \addToTail,
			\out, self.faderBus,
			\amp, 1,
			\atk, 0.01,
			\rel, 0.01,
			\cutoff, 4000,
			\buffer, Pseq([
				self.buffer[0], self.buffer[1], self.buffer[2], self.buffer[3],
				self.buffer[4], self.buffer[5], self.buffer[6], self.buffer[7],
				self.buffer[8]], inf),
			\dur, Pseq([0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1.2, 1.2], inf) + Pwhite(-0.001, 0.001),
			\legato, 1,
			\msg, Prout({
				var tempArray = #[0, 1, 2, 3, 4, 5, 6, 7, 8];
				loop {
					tempArray.do({ |item, index|
						~scLang.sendMsg(\neverControl, \tptAccompNum , item);
						"hi".yield;

					});
				}
			}),
		);
		self;
	},

	destroyPatterns: { | self |
		Pbindef(\neverTpt,
			\rateLo, Pwhite(0.05, 100),
			\rateHi, Pwhite(0.05, 100)
		);
		self;
	},

	resetPatterns: { | self |
		Pbindef(\neverTpt,
			\rateLo, 1,
			\rateHi, 1
		);
		self;
	},

	killPatterns: { | self |
			Pbindef(\neverTpt).clear;
		self;
	},

	recordTpt: { | self, num |
		Synth.tail(~group.fx, \recordBuf, [\in, ~inst.mute, \bufName, self.buffer[num]]);
		self;
	},

	toggleAccomp: { | self |
		if( self.playState == 0, { self.playAccomp; }, { self.stopAccomp; });
		self;
	},

	playAccomp: { | self |
		Pbindef(\neverTpt).play(self.tempoClock, quant: 0);
		self.playState = 1;
		self;
	},

	stopAccomp: { | self |
		Pbindef(\neverTpt).stop(self.tempoClock);
		self.playState = 0;
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