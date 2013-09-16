/*
Sunday, September 15th 2013
warmUpOhm.scd
prm
*/

~repriseOhm.warmUp = (

	main: 0,
  playTexture: 8,

	vol: 15,

	makeOSC: { | self |
		OSCdef(\repriseWarmUp, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \warmUpTop } { self.spawn(val); }
			{ id == \playTexture } { self.playOhm(val); }
		}, \repriseControl, ~scLang);

		OSCdef(\repriseWarmUpRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \warmUpVol } { if ( val == 1, { self.makeVol; }) }
      { id == \playTexture } { if ( val == 1, { self.makePlayMIDI; }) }
		}, \restoreOhmReprise, ~scLang);
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
				~ohm.turnCyan(self.main);
				~restoreOhm.reprise.page.put(self.main, \cyan);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.reprise.page.put(self.main, \red);
			}
		);
		self;
	},

  makePlay: { | self |
    ~ohm.turnWhite(self.playTexture);
    ~restoreOhm.reprise.page.put(self.playTexture, \white);
    self.makePlayMIDI;
    ~restoreOhm.reprise.playTexture = 1;
    self;
  },

  killPlay: { | self |
    ~ohm.turnOff(self.playTexture);
    ~restoreOhm.reprise.page.put(self.playTexture, \off);
    self.killPlayMIDI;
    ~restoreOhm.reprise.playTexture = 0;
    self;
  },

  makePlayMIDI: { | self |
    MIDIdef.noteOn(\repriseWarmUpPlay, {
      ~reprise.warmUp.togglePattern;
      ~scLang.sendMsg(\repriseControl, \playTexture, ~reprise.warmUp.playState);
    }, self.playTexture);
    self;
  },

  killPlayMIDI: { | self |
    MIDIdef(\repriseWarmUpPlay).free;
    self;
  },

  playOhm: { | self, val |
    if( val == 1,
      { ~ohm.turnGreen(self.playTexture); ~restoreOhm.reprise.page.put(self.playTexture, \green); },
      { ~ohm.turnWhite(self.playTexture); ~restoreOhm.reprise.page.put(self.playTexture, \white); }
    );
    self;
  },

	makeVol: { | self |
		MIDIdef.cc(\repriseWarmUpVol, { | val |
			var amp = val.linlin(0, 127, 0, 3.dbamp);
      ~reprise.warmUp.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.reprise.warmUpVol = 1;
		self;
	},

	killVol: { | self |
    MIDIdef(\repriseWarmUpVol).free;
		~restoreOhm.reprise.warmUpVol = 0;
		self;
	},

	makeDials: { | self |
		self;
	},

	killDials: { | self |
		self;
	},

);
