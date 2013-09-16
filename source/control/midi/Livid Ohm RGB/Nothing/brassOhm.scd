/*
Sunday, September 15th 2013
birdSongOhm.scd
prm
*/

~nothingOhm.brass = (

	main: 1,
  brass1: 2,
  brass2: 10,

	vol: 14,

	makeOSC: { | self |
		OSCdef(\nothingBrass, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \brassTop } { self.spawn(val); }
			{ id == \brass1 } { self.brass1Ohm(val); }
      { id == \brass2 } { self.brass2Ohm(val); }
		}, \nothingControl, ~scLang);

		OSCdef(\nothingBrassRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \brassVol } { if ( val == 1, { self.makeVol; }) }
      { id == \brass1 } { if ( val == 1, { self.makeBrass1MIDI; }) }
      { id == \brass2 } { if ( val == 1, { self.makeBrass2MIDI; }) }
		}, \restoreOhmNothing, ~scLang);
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
    self.makeBrass1;
    self.makeBrass2;
	},

	killButtons: { | self |
		self.topOhm(0);
    self.killBrass1;
    self.killBrass2;
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
				~ohm.turnBlue(self.main);
				~restoreOhm.nothing.page.put(self.main, \blue);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.nothing.page.put(self.main, \red);
			}
		);
		self;
	},

  makeBrass1: { | self |
    ~ohm.turnCyan(self.brass1);
    ~restoreOhm.nothing.page.put(self.brass1, \cyan);
    self.makeBrass1MIDI;
    ~restoreOhm.nothing.brass1 = 1;
    self;
  },

  killBrass1: { | self |
    ~ohm.turnOff(self.brass1);
    ~restoreOhm.nothing.page.put(self.brass1, \off);
    self.killBrass1MIDI;
    ~restoreOhm.nothing.brass1 = 0;
    self;
  },

  makeBrass1MIDI: { | self |
    MIDIdef.noteOn(\nothingBrass1On, {
      ~nothing.brass.playBrass1;
      ~scLang.sendMsg(\nothingControl, \brass1, ~nothing.brass.play1State);
    }, self.brass1);
    MIDIdef.noteOff(\nothingBrass1Off, {
      ~nothing.brass.stopBrass1;
      ~scLang.sendMsg(\nothingControl, \brass1, ~nothing.brass.play1State);
    }, self.brass1);
    self;
  },

  killBrass1MIDI: { | self |
    MIDIdef(\nothingBrass1On).free;
    MIDIdef(\nothingBrass1Off).free;
    self;
  },

  brass1Ohm: { | self, val |
    if( val == 1,
      { ~ohm.turnGreen(self.brass1); ~restoreOhm.nothing.page.put(self.brass1, \green) },
      { ~ohm.turnCyan(self.brass1); ~restoreOhm.nothing.page.put(self.brass1, \cyan) }
    );
    self;
  },

  makeBrass2: { | self |
    ~ohm.turnPurple(self.brass2);
    ~restoreOhm.nothing.page.put(self.brass2, \purple);
    self.makeBrass2MIDI;
    ~restoreOhm.nothing.brass2 = 1;
    self;
  },

  killBrass2: { | self |
    ~ohm.turnOff(self.brass2);
    ~restoreOhm.nothing.page.put(self.brass2, \off);
    self.killBrass2MIDI;
    ~restoreOhm.nothing.brass2 = 0;
    self;
  },

  makeBrass2MIDI: { | self |
    MIDIdef.noteOn(\nothingBrass2On, {
      ~nothing.brass.playBrass2;
      ~scLang.sendMsg(\nothingControl, \brass2, ~nothing.brass.play2State);
    }, self.brass2);
    MIDIdef.noteOff(\nothingBrass2Off, {
      ~nothing.brass.stopBrass2;
      ~scLang.sendMsg(\nothingControl, \brass2, ~nothing.brass.play2State);
    }, self.brass2);
    self;
  },

  killBrass2MIDI: { | self |
    MIDIdef(\nothingBrass2On).free;
    MIDIdef(\nothingBrass2Off).free;
    self;
  },

  brass2Ohm: { | self, val |
    if( val == 1,
      { ~ohm.turnGreen(self.brass2); ~restoreOhm.nothing.page.put(self.brass2, \green) },
      { ~ohm.turnPurple(self.brass2); ~restoreOhm.nothing.page.put(self.brass2, \cyan) }
    );
    self;
  },

	makeVol: { | self |
		MIDIdef.cc(\nothingBrassVol, { | val |
			var amp = val.linlin(0, 127, 0, 3.dbamp);
      ~nothing.brass.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.nothing.brassVol = 1;
		self;
	},

	killVol: { | self |
		MIDIdef(\nothingBrassVol).free;
		~restoreOhm.nothing.brassVol = 0;
		self;
	},

	makeDials: { | self |
		self;
	},

	killDials: { | self |
		self;
	},

);
