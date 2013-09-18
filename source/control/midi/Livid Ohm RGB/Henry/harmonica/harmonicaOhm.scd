/*
Wednesday, September 11th 2013
harmonicaOhm.scd
prm
*/

~henryOhm.harmonica = (

	main: 3,
  recordArray: [11, 19, 27, 35],
  playGestures: 4,
  playMelody: 12,

	melodyVol: 22,
  gestureVol: 23,

	makeOSC: { | self |
		OSCdef(\henryHarmonicaOhm, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \harmonicaTop } { self.spawn(val); }
			{ id == \harmonicaRecord } { self.recordOhm(val); }
      { id == \harmonicaPlay } { self.playOhm(val); }
      { id == \harmonicaMelody } { self.melodyOhm(val); }
		}, \henryControl, ~scLang);

		OSCdef(\henryHarmonicaOhmRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case

			{ id == \harmonicaMelodyVol } { if ( val == 1, { self.makeMelodyVol; }) }
      { id == \harmonicaMelodyVol } { if ( val == 1, { self.makeGestureVol; }) }
			{ id == \harmonicaRecord } { if ( val == 1, { self.makeRecordMIDI; } ) }
			{ id == \harmonicaPlay } { if ( val == 1, { self.makePlayMIDI; } ) }
      { id == \harmonicaMelody } { if (val == 1, { self.makeMelodyMIDI; } ) }

		}, \restoreOhmHenry, ~scLang);

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
		self.makeRecord;
		self.makePlay;
    self.makeMelody;
	},

	killButtons: { | self |
		self.topOhm(0);
		self.killRecord;
    self.killPlay;
    self.killMelody;
		self;
	},

	makeFaders: { | self |
		self.makeMelodyVol;
    self.makeGestureVol;
		self;
	},

	killFaders: { | self |
		self.killMelodyVol;
    self.killGestureVol;
		self;
	},

	topOhm: { | self, val |
		if( val == 1,
			{
				~ohm.turnPurple(self.main);
				~restoreOhm.henry.page.put(self.main, \purple);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.henry.page.put(self.main, \red);
			}
		);
		self;
	},

  makeRecord: { | self |
    self.recordArray.do({ | led, i |
      ~ohm.turnRed(led);
      ~restoreOhm.henry.page.put(led, \red);
    });
    self.makeRecordMIDI;
    ~restoreOhm.henry.harmonicaRecord = 1;
    self;
  },

  killRecord: { | self |
    self.recordArray.do({ | led, i |
      ~ohm.turnOff(led);
      ~restoreOhm.henry.page.put(led, \off);
    });
    self.killRecordMIDI;
    ~restoreOhm.henry.harmonicaRecord = 0;
    self;
  },

  makeRecordMIDI: { | self |
    self.recordArray.do({ | led, i |
      MIDIdef.noteOn(("harmonicaRecord" ++ (i + 1)).asSymbol, {
        ~henry.harmonica.recordHarmonica(i);
      }, led);
    });
    self;
  },

  killRecordMIDI: { | self |
    self.recordArray.do({ | led, i |
      MIDIdef(("harmonicaRecord" ++ (i + 1)).asSymbol).free;
      self;
    });
    self;
  },

  makePlay: { | self |
    ~ohm.turnPurple(self.playGestures);
    ~restoreOhm.henry.page.put(self.playGestures, \purple);
    self.makePlayMIDI;
    ~restoreOhm.henry.harmonicaPlay = 1;
    self;
  },

  killPlay: { | self |
    ~ohm.turnOff(self.playGestures);
    ~restoreOhm.henry.page.put(self.playGestures, \off);
    self.killPlayMIDI;
    ~restoreOhm.henry.harmonicaPlay = 0;
    self;
  },

  makePlayMIDI: { | self |
    MIDIdef.noteOn(\harmonicaGestures, {
      ~henry.harmonica.toggleGestures;
      ~scLang.sendMsg(\henryControl, \harmonicaPlay, ~henry.harmonica.gestureState);
    }, self.playGestures);
    self;
  },

  killPlayMIDI: { | self |
    MIDIdef(\harmonicaGestures).free;
    self;
  },

  playOhm: { | self, val |
    if( val == 1,
      { ~ohm.turnGreen(self.playGestures); ~restoreOhm.henry.page.put(self.playGestures, \green); },
      { ~ohm.turnPurple(self.playGestures); ~restoreOhm.henry.page.put(self.playGestures, \purple); }
    );
    self;
  },

  makeMelody: { | self |
    ~ohm.turnYellow(self.playMelody);
    ~restoreOhm.henry.page.put(self.playMelody, \yellow);
    self.makeMelodyMIDI;
    ~restoreOhm.henry.harmonicaMelody = 1;
    self;
  },

  killMelody: { | self |
    ~ohm.turnOff(self.playMelody);
    ~restoreOhm.henry.page.put(self.playMelody, \off);
    self.killMelodyMIDI;
    ~restoreOhm.henry.harmonicaMelody = 0;
    self;
  },

  makeMelodyMIDI: { | self |
    MIDIdef.noteOn(\harmonicaMelody, {
      ~henry.harmonica.playMelody;
      ~ohm.blink(self.playMelody, \green, 3);
      { ~ohm.turnYellow(self.playMelody) }.defer(3);
    }, self.playMelody);
    self;
  },

  killMelodyMIDI: { | self |
    MIDIdef(\harmonicaMelody).free;
    self;
  },

	makeMelodyVol: { | self |
		MIDIdef.cc(\harmonicaMelodyVol, { | val |
			var amp = val.linlin(0, 127, 0, 0.dbamp);
			~henry.harmonica.fader1.set(\amp, amp);
		}, self.melodyVol);
		~restoreOhm.henry.harmonicaMelodyVol = 1;
		self;

	},

	killMelodyVol: { | self |
		MIDIdef(\harmonicaMelodyVol).free;
		~restoreOhm.henry.harmonicaMelodyVol = 0;
		self;
	},

  makeGestureVol: { | self |
    MIDIdef.cc(\harmonicaGestureVol, { | val |
      var amp = val.linlin(0, 127, 0, 6.dbamp);
      ~henry.harmonica.fader2.set(\amp, amp);
    }, self.gestureVol);
    ~restoreOhm.henry.harmonicaGestureVol = 1;
    self;
  },

  killGestureVol: { | self |
    MIDIdef(\harmonicaGestureVol).free;
    ~restoreOhm.henry.harmonicaGestureVol = 0;
    self;
  },

	makeDials: { | self |
		self;
	},

	killDials: { | self |
		self;
	},

);