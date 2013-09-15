/*
Sunday, September 15th 2013
tanpuraOhm.scd
prm
*/

~spaceOhm.tanpura = (

	main: 0,
	playTanpura: 8,

	vol: 14,

	makeOSC: { | self |
		OSCdef(\spaceTanpura, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \tanpuraTop } { self.spawn(val); }
			{ id == \playTanpura} { self.playOhm(val); }
		}, \spaceControl, ~scLang);

		OSCdef(\spaceTanpuraRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \tanpuraVol } { if ( val == 1, { self.makeVol; }) }
			{ id == \playTanpura } { if( val == 1, { self.makePlayMIDI; }) }
		}, \restoreOhmSpace, ~scLang);
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
				~restoreOhm.space.page.put(self.main, \white);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.space.page.put(self.main, \red);
			}
		);
		self;
	},

  makePlay: { | self |
    ~ohm.turnBlue(self.playTanpura);
    ~restoreOhm.space.page.put(self.playTanpura, \blue);
    self.makePlayMIDI;
    ~restoreOhm.space.playTanpura = 1;
    self;
  },

  killPlay: { | self |
    ~ohm.turnOff(self.playTanpura);
    ~restoreOhm.space.page.put(self.playTanpura, \off);
    self.killPlayMIDI;
    ~restoreOhm.space.playTanpura = 0;
    self;
  },

  makePlayMIDI: { | self |
    MIDIdef.noteOn(\spaceTanpuraPlay, {
      ~space.tanpura.toggleGran;
      ~scLang.sendMsg(\spaceControl, \playTanpura, ~space.tanpura.playState);
    }, self.playTanpura);
    self;
  },

  killPlayMIDI: { | self |
    MIDIdef(\spaceTanpuraPlay).free;
    self;
  },

  playOhm: { | self, val |
    if( val == 1,
      { ~ohm.turnGreen(self.playTanpura); ~restoreOhm.space.page.put(self.playTanpura, \green); },
      { ~ohm.turnBlue(self.playTanpura); ~restoreOhm.space.page.put(self.playTanpura, \blue); }
    );
    self;
  },

	makeVol: { | self |
		MIDIdef.cc(\spaceTanpuraVol, { | val |
			var amp = val.linlin(0, 127, 0, 3.dbamp);
      ~space.tanpura.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.space.tanpuraVol = 1;
		self;
	},

	killVol: { | self |
		MIDIdef(\spaceTanpuraVol).free;
		~restoreOhm.space.tanpuraVol = 0;
		self;
	},

	makeDials: { | self |
		self;
	},

	killDials: { | self |
		self;
	},

);
