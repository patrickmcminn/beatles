/*
Sunday, September 15th 2013
birdSongOhm.scd
prm
*/

~nothingOhm.birdSong = (

	main: 0,
  playBird: 8,

	vol: 15,

	makeOSC: { | self |
		OSCdef(\nothingBirdSong, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \birdSongTop } { self.spawn(val); }
			{ id == \playBirdSong } { self.playOhm(val); }
		}, \nothingControl, ~scLang);

		OSCdef(\nothingBirdSongRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \birdSongVol } { if ( val == 1, { self.makeVol; }) }
      { id == \playBirdSong } { if ( val == 1, { self.makePlayMIDI; }) }
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
				~restoreOhm.nothing.page.put(self.main, \cyan);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.nothing.page.put(self.main, \red);
			}
		);
		self;
	},

  makePlay: { | self |
    ~ohm.turnWhite(self.playBird);
    ~restoreOhm.nothing.page.put(self.playBird, \white);
    self.makePlayMIDI;
    ~restoreOhm.nothing.playBirdSong = 1;
    self;
  },

  killPlay: { | self |
    ~ohm.turnOff(self.playBird);
    ~restoreOhm.nothing.page.put(self.playBird, \off);
    self.killPlayMIDI;
    ~restoreOhm.nothing.playBirdsong = 0;
    self;
  },

  makePlayMIDI: { | self |
    MIDIdef.noteOn(\nothingPlayBirdSong, {
      ~nothing.birdSong.togglePattern;
      ~scLang.sendMsg(\nothingControl, \playBirdSong, ~nothing.birdSong.playState);
    }, self.playBird);
    self;
  },

  killPlayMIDI: { | self |
    MIDIdef(\nothingPlayBirdSong).free;
    self;
  },

  playOhm: { | self, val |
    if( val == 1,
      { ~ohm.turnGreen(self.playBird); ~restoreOhm.nothing.page.put(self.playBird, \green); },
      { ~ohm.turnWhite(self.playBird); ~restoreOhm.nothing.page.put(self.playBird, \white); }
    );
    self;
  },

	makeVol: { | self |
		MIDIdef.cc(\nothingBirdSongVol, { | val |
			var amp = val.linlin(0, 127, 0, 3.dbamp);
      ~nothing.birdSong.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.nothing.birdSongVol = 1;
		self;
	},

	killVol: { | self |
		MIDIdef(\nothingBirdSongVol).free;
		~restoreOhm.nothing.birdSongVol = 0;
		self;
	},

	makeDials: { | self |
		self;
	},

	killDials: { | self |
		self;
	},

);
