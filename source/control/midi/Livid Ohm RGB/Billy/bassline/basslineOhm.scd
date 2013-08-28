/*
Wednesday, August 28th 2013
basslineOhm.scd
prm
*/

~billyOhm.bassline = (

	main: 6,
	play: 14,

	vol: 14,

	makeOSC: { | self |
		OSCdef(\billyBasslineOhm, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \basslineTop } { self.spawn(val); }
			{ id == \basslinePlay } { self.playOhm(val); }
		}, \billyControl, ~scLang);

		OSCdef(\billyBasslineOhmRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \basslineVol } { if ( val == 1, { self.makeVol; }) }
			{ id == \basslinePlay } { if( val == 1, { self.makePlayMIDI; }) }
		}, \restoreOhmBilly, ~scLang);
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
		self.makePlay;
		self;
	},

	killButtons: { | self |
		self.topOhm(0);
		self.killPlay;
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

	topOhm: { | self, val |
		if( val == 1,
			{
				~ohm.turnWhite(self.main);
				~restoreOhm.billy.page.put(self.purple, \white);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.billy.page.put(self.main, \red);
			}
		);
		self;
	},

	makePlay: { | self |
		~ohm.turnYellow(self.play);
		~restoreOhm.billy.page.put(self.play, \yellow);
		self.makePlayMIDI;
		~restoreOhm.billy.basslinePlay = 1;
		self;
	},

	killPlay: { | self |
		~ohm.turnOff(self.play);
		~restoreOhm.billy.page.put(self.play, \off);
		self.killPlayMIDI;
		~restoreOhm.billy.basslinePlay = 0;
		self;
	},

	makePlayMIDI: { | self |
		MIDIdef.noteOn(\basslinePlay, {
			~billy.bassline.togglePattern;
			~scLang.sendMsg(\billyControl, \basslineplay, ~billy.bassline.playState);
		}, self.play);
		self;
	},

	killPlayMIDI: { | self |
		MIDIdef(\basslinePlay).free;
		self;
	},

	playOhm: { | self, val |
		if( val == 1,
			{
				~ohm.turnGreen(self.play);
				~restoreOhm.billy.page.put(self.play, \green);
			},
			{
				~ohm.turnRed(self.play);
				~restoreOhm.billy.page.put(self.play, \red);
			}
		);
		self;
	},

	makeVol: { | self |
		MIDIdef.cc(\basslineVol, { | val |
			var amp = val.linlin(0, 127, 0, -12.dbamp);
			~billy.bassline.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.billy.basslineVol = 1;
		self;
	},

	killVol: { | self |
		MIDIdef(\basslineVol).free;
		~restoreOhm.billy.basslineVol = 0;
		self;
	},

	makeDials: { | self |
		self;
	},

	killDials: { | self |
		self;
	},

);
