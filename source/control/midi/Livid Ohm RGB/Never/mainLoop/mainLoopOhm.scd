/*
Wednesday, September 4th 2013
fifteenKOhmscd
prm
*/

~neverOhm.mainLoop = (

	main: 4,
	fade: 12,
	loopArray: [5, 13, 21, 29, 37, 45, 53, 61, 38, 46],

	vol: 15,
	rateNum: 8,

	makeOSC: { | self |
		OSCdef(\neverMainLoopOhm, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \mainLoopTop } { self.spawn(val); }
			{ id == \mainLoopOn } { self.loopOnOhm(val); }
			{ id == \mainLoopOff } { self.loopOffOhm(val); }
			{ id == \mainLoopFade } { self.fadeOhm(val); }
		}, \neverControl, ~scLang);

		OSCdef(\neverMainLoopOhmRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case

			{ id == \mainLoopVol } { if ( val == 1, { self.makeVol; }) }
			{ id == \mainLoopPlay } { if ( val == 1, { self.makeLoopMIDI; }) }
			{ id == \mainLoopFade } { if ( val == 1, { self.makeFadeMIDI; }) }
			{ id == \mainLoopRate } { if ( val == 1, { self.makeRate; }) }

		}, \restoreOhmNever, ~scLang);

		self;
	},

	spawn: { | self, val |
		if( val == 1, { self.init; }, { self.kill; });
		self;
	},

	init: { | self |
		self.makeButtons;
		self.makeFaders;
		self.makeDials;
		self;
	},

	kill: { | self |
		self.killButtons;
		self.killFaders;
		self.killDials;
		self;
	},

	makeButtons: { | self |
		self.topOhm(1);
		//self.makeFade;
		self.makeLoop;
		self;
	},

	killButtons: { | self |
		self.topOhm(0);
		//self.killFade;
		self.killLoop;
		self;
	},

	makeFaders: { | self |
		self.makeVol;
		self;
	},

	killFaders: { | self |
		self.killVol;
		self;
	},

	makeDials: { | self |
		self.makeRate;
		self;
	},

	killDials: { | self |
		self.killRate;
		self;
	},

	topOhm: { | self, val |
		if( val == 1,
			{
				~ohm.turnPurple(self.main);
				~restoreOhm.never.page.put(self.main, \purple);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.never.page.put(self.main, \red);
			}
		);
		self;
	},

	makeFade: { | self |
		~ohm.turnCyan(self.fade);
		~restoreOhm.never.page.put(self.fade, \cyan);
		self.makeFadeMIDI;
		~restoreOhm.never.mainLoopFade = 1;
		self;
	},

	killFade: { | self |
		~ohm.turnOff(self.fade);
		~restoreOhm.never.page.put(self.fade, \off);
		self.killFadeMIDI;
		~restoreOhm.never.mainLoopFade = 0;
		self;
	},

	makeFadeMIDI: { | self |
		MIDIdef.noteOn(\mainLoopFade, {
			~never.mainLoop.fade;
			~scLang.sendMsg(\neverControl, \mainLoopFade, 1);
		}, self.fade);
		self;
	},

	killFadeMIDI: { | self |
		MIDIdef(\mainLoopFade).free;
		self;
	},

	fadeOhm: { | self, val |
		if( val == 1, { ~ohm.turnGreen(self.fade) });
		self;
	},

	makeLoop: { | self |
		self.loopArray.do({ | led, i |
			~ohm.turnWhite(led);
			~restoreOhm.never.page.put(led, \white);
		});
		self.makeLoopMIDI;
		~restoreOhm.never.mainLoopPlay = 1;
		self;
	},

	killLoop: { | self |
		self.loopArray.do({ | led, i |
			~ohm.turnOff(led);
			~restoreOhm.never.page.put(led, \off);
		});
		self.killLoopMIDI;
		~restoreOhm.never.mainLoopPlay = 0;
		self;
	},

	makeLoopMIDI: { | self |
		self.loopArray.do({ | led, i |
			MIDIdef.noteOn(("mainLoopOn" ++ (i + 1)).asSymbol, {
				~never.mainLoop.playLoop(i);
				~scLang.sendMsg(\neverControl, \mainLoopOn, i);
			}, led);
			MIDIdef.noteOff(("mainLoopOff" ++ ( i + 1)).asSymbol, {
				~never.mainLoop.stopLoop(i);
				~scLang.sendMsg(\neverControl, \mainLoopOff, i);
			}, led);
		});
		self;
	},

	killLoopMIDI: { | self |
		self.loopArray.do({ | led, i |
			MIDIdef((("mainLoopOn" ++ (i + 1))).asSymbol).free;
			MIDIdef((("mainLoopOff" ++ (i + 1))).asSymbol).free;
		});
		self;
	},

	loopOnOhm: { | self, val |
		~ohm.turnGreen(self.loopArray[val]);
		self;
	},

	loopOffOhm: { | self, val |
		~ohm.turnWhite(self.loopArray[val]);
		self;
	},

	makeVol: { | self |
		MIDIdef.cc(\mainLoopVol, { | val |
			var amp = val.linlin(0, 127, 0, 1.5);
			~never.mainLoop.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.never.mainLoopVol = 1;
		self;

	},

	killVol: { | self |
		MIDIdef(\mainLoopVol).free;
		~restoreOhm.never.mainLoopVol = 0;
		self;
	},

	makeRate: { | self |
		MIDIdef.cc(\mainLoopRate, { | val |
			var rateLo, rateHi;
			rateLo = val.linlin(0, 127, 0.95, 3);
			rateHi = val.linlin(0, 127, 1.05, 4);
			rateLo.postln;
			~never.mainLoop.rateLo = rateLo;
			~never.mainLoop.rateHi = rateHi;
		}, self.rateNum);
	},

	killRate: { | self |
		MIDIdef(\mainLoopRate).free;
		self;
	},
);