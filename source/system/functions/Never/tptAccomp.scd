/*
Monday, August 19th 2013
tptAccomp.scd
prm
*/

~never.tptAccomp = (

	state: 0,
	muteState: 0,
	playState: 0,
  input: ~inst.mute,

	spawn: { | self |
		if( self.state == 0, { if( ~never.router.state == 1) { self.init; } }, { self.kill; });
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
    self.recordBus = Bus.audio(s, 2);
		self.faderBus = Bus.audio(s, 2);
		self;
	},

	killBusses: { | self |
		self.faderBus.free;
		self;
	},

	makeSynths: { | self |
    self.nebular = Synth.tail(~never.router.inGroup, \nebular, [\in, self.input, \out, self.recordBus, \delTime, 0, \cutoff, 1000]);
		self.fader = Synth.tail(~never.router.inGroup, \pan, [\in, self.faderBus, \out, ~never.router.in1, \amp, -6.dbamp]);
		self;
	},

	killSynths: { | self |
    self.nebular.free;
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
			\atk, 0.05,
			\rel, 0.05,
			\cutoff, 2000,
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
		Synth.tail(~never.router.inGroup, \recordBuf, [\in, self.recordBus, \bufName, self.buffer[num]]);
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



);