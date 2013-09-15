/*
Sunday, September 15th 2013
textureOhm.scd
prm
*/

~introOhm.texture = (

	main: 0,
	playTexture: 8,

	vol: 14,

	makeOSC: { | self |
		OSCdef(\introTexture, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \textureTop } { self.spawn(val); }
			{ id == \playTexture} { self.playOhm(val); }
		}, \introControl, ~scLang);

		OSCdef(\introTextureRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \textureVol } { if ( val == 1, { self.makeVol; }) }
			{ id == \playTexture } { if( val == 1, { self.makePlayMIDI; }) }
		}, \restoreOhmIntro, ~scLang);
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
		self.makePlayTexture;
		self;
	},

	killButtons: { | self |
		self.topOhm(0);
		self.killPlayTexture;
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
				~restoreOhm.intro.page.put(self.main, \white);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.intro.page.put(self.main, \red);
			}
		);
		self;
	},

  makePlayTexture: { | self |
    ~ohm.turnBlue(self.playTexture);
    ~restoreOhm.intro.page.put(self.playTexture, \blue);
    self.makePlayMIDI;
    ~restoreOhm.intro.playTexture = 1;
    self;
  },

  killPlayTexture: { | self |
    ~ohm.turnOff(self.playTexture);
    ~restoreOhm.intro.page.put(self.playTexture, \off);
    self.killPlayMIDI;
    ~restoreOhm.intro.playTexture = 0;
    self;
  },

  makePlayMIDI: { | self |
    MIDIdef.noteOn(\introTexturePlay, {
      ~intro.texture.toggleTexture;
      ~scLang.sendMsg(\introControl, \playTexture, ~intro.texture.playState);
    }, self.playTexture);
    self;
  },

  killPlayMIDI: { | self |
    MIDIdef(\introTexturePlay).free;
    self;
  },

  playOhm: { | self, val |
    if( val == 1,
      { ~ohm.turnGreen(self.playTexture); ~restoreOhm.intro.page.put(self.playTexture, \green); },
      { ~ohm.turnBlue(self.playTexture); ~restoreOhm.intro.page.put(self.playTexture, \blue); }
    );
    self;
  },

	makeVol: { | self |
		MIDIdef.cc(\introTextureVol, { | val |
			var amp = val.linlin(0, 127, 0, 3.dbamp);
      ~intro.texture.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.intro.textureVol = 1;
		self;
	},

	killVol: { | self |
		MIDIdef(\introTextureVol).free;
		~restoreOhm.intro.textureVol = 0;
		self;
	},

	makeDials: { | self |
		self;
	},

	killDials: { | self |
		self;
	},

);
