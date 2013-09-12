/*
Wednesday, September 11th 2013
harmonicaOhm.scd
prm
*/

~henryOhm.harmonica = (

	main: 3,
  recordArray: [11, 19, 27, 35],
  playArray: [4, 12],

	vol: 22,

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

			{ id == \harmonicaVol } { if ( val == 1, { self.makeVol; }) }
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
    self.killMelody;
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
        ~henry.harmonica.recordHarmonica(i + 1);
      });
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
    self.playArray.do({ | led, i |
      ~ohm.turnCyan(led);
      ~restoreOhm.henry.page.put(led, \cyan);
    });
    self.makePlayMIDI;
    ~restoreOhm.henry.bellsPlay = 1;
    self;
  },

  killPlay: { | self |
    self.playArray.do({ | led, i |
      ~ohm.turnOff(led);
      ~restoreOhm.henry.page.put(led, \off);
    });
    self.killPlayMIDI;
    ~restoreOhm.henry.bellsPlay = 0;
    self;
  },

  makePlayMIDI: { | self |
    self.playArray.do({ | led, i |
      MIDIdef.noteOn(("bellsPlay" ++ (i + 1)).asSymbol, {
        ("henry.bells.toggle" ++ (i + 1)).interpret;
        ~scLang.sendMsg(\henryControl, \bellsPlay, i);
      }, led);
    });
    self;
  },

  killPlayMIDI: { | self |
    self.playArray.do({ | led, i |
      MIDIdef(("bellsPlay" ++ (i + 1)).asSymbol).free;
    });
    self;
  },

  playOhm: { | self, val |
    if( ~henry.bells.playState[val] == 1,
      { ~ohm.turnGreen(self.playArray[val]); ~restoreOhm.henry.page.put(self.playArray[val], \green); },
      { ~ohm.turnCyan(self.playArray[val]); ~restoreOhm.henry.page.put(self.playArray[val], \cyan); }
    );
    self;
  },

	makeVol: { | self |
		MIDIdef.cc(\bellsVol, { | val |
			var amp = val.linlin(0, 127, 0, 6.dbamp);
			~henry.bells.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.henry.bellsVol = 1;
		self;

	},

	killVol: { | self |
		MIDIdef(\bellsVol).free;
		~restoreOhm.henry.bellsVol = 0;
		self;
	},

	makeDials: { | self |
		self;
	},

	killDials: { | self |
		self;
	},

);