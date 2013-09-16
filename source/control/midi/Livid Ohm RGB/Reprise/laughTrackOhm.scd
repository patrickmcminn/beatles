/*
Sunday, September 15th 2013
laughTrackOhm.scd
prm
*/

~repriseOhm.laughTrack = (

	main: 1,
  playArray: [2, 10, 18, 26],
  applause: 3,

	vol: 14,

	makeOSC: { | self |
		OSCdef(\repriseLaughTrack, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \laughTrackTop } { self.spawn(val); }
      { id == \playLaughTrack } { self.laughOhm(val); }
      { id == \playApplause } { self.appluaseOhm(val); }
		}, \repriseControl, ~scLang);

		OSCdef(\repriselaughTrackRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \laughTrackVol } { if ( val == 1, { self.makeVol; }) }
      { id == \playLaughTrack} { if ( val == 1, { self.makeLaughMIDI; }) }
      { id == \playApplause } { if ( val == 1, { self.makeApplauseMIDI; }) }
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
    self.makeLaugh;
    self.makeApplause;
	},

	killButtons: { | self |
		self.topOhm(0);
    self.killLaugh;
    self.killApplause;
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
				~ohm.turnPurple(self.main);
				~restoreOhm.reprise.page.put(self.main, \purple);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.reprise.page.put(self.main, \red);
			}
		);
		self;
	},

  makeLaugh: { | self |
    self.playArray.do({ | led, i |
      ~ohm.turnYellow(led);
      ~restoreOhm.reprise.page.put(led, \yellow);
    });
    self.makeLaughMIDI;
    ~restoreOhm.reprise.playLaughTrack = 1;
    self;
  },

  killLaugh: { | self |
    self.playArray.do({ | led, i |
      ~ohm.turnOff(led);
      ~restoreOhm.reprise.page.put(led, \off);
    });
    self.killLaughMIDI;
    ~restoreOhm.reprise.playLaughTrack = 0;
    self;
  },

  makeLaughMIDI: { | self |
    self.playArray.do({ | led, i |
      MIDIdef.noteOn(("playLaughTrack" ++ (i + 1)).asSymbol, {
        ("~reprise.laughTrack.playLaugh" ++ (i + 1)).interpret;
        ~scLang.sendMsg(\repriseControl, \playLaughTrack, i);
      }, led);
      MIDIdef.noteOff(("stopLaughTrack" ++ (i + 1)).asSymbol, {
        ("~reprise.laughTrack.stopLaugh" ++ (i + 1)).interpret;
        ~scLang.sendMsg(\repriseControl, \playLaughTrack, i);
      }, led);
    });
    self;
  },

  killLaughMIDI: { | self |
    self.playArray.do({ | led, i |
      MIDIdef(("playLaughTrack" ++ (i + 1)).asSymbol).free;
      MIDIdef(("stopLaughTrack" ++ (i + 1)).asSymbol).free;
    });
    self;
  },

  laughOhm: { | self, val |
    if( ~reprise.laughTrack.laughState[val] == 1,
      { ~ohm.turnGreen(self.playArray[val]); ~restoreOhm.reprise.page.put(self.playArray[val], \green); },
      { ~ohm.turnYellow(self.playArray[val]); ~restoreOhm.reprise.page.put(self.playArray[val], \yellow); }
    );
    self;
  },

  makeApplause: { | self |
    ~ohm.turnCyan(self.applause);
    ~restoreOhm.reprise.page.put(self.applause, \cyan);
    self.makeApplauseMIDI;
    ~restoreOhm.reprise.playApplause = 1;
    self;
  },

  killApplause: { | self |
    ~ohm.turnOff(self.applause);
    ~restoreOhm.reprise.page.put(self.applause, \off);
    self.killApplauseMIDI;
    ~restoreOhm.reprise.playApplause = 0;
    self;
  },

  makeApplauseMIDI: { | self |
    MIDIdef.noteOn(\repriseApplausePlay, {
      ~reprise.laughTrack.playApplause;
      ~scLang.sendMsg(\repriseControl, \playApplause, ~reprise.laughTrack.applauseState);
    }, self.applause);
    MIDIdef.noteOff(\repriseApplauseStop, {
      ~reprise.laughTrack.stopApplause;
      ~scLang.sendMsg(\repriseControl, \playApplause, ~reprise.laughTrack.applauseState);
    }, self.applause);
    self;
  },

  killApplauseMIDI: { | self |
    MIDIdef(\repriseApplausePlay).free;
    MIDIdef(\repriseApplauseStop).free;
    self;
  },

  applauseOhm: { | self, val |
    if( val == 1,
      { ~ohm.turnGreen(self.applause); ~restoreOhm.reprise.page.put(self.applause, \green); },
      { ~ohm.turnCyan(self.applause); ~restoreOhm.reprise.page.put(self.applause, \cyan); }
    );
    self;
  },

	makeVol: { | self |
		MIDIdef.cc(\repriseLaughTrackVol, { | val |
			var amp = val.linlin(0, 127, 0, 3.dbamp);
      ~reprise.laughTrack.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.reprise.laughTrackVol = 1;
		self;
	},

	killVol: { | self |
    MIDIdef(\repriseLaughTrackVol).free;
		~restoreOhm.reprise.laughTrackVol = 0;
		self;
	},

	makeDials: { | self |
		self;
	},

	killDials: { | self |
		self;
	},

);
