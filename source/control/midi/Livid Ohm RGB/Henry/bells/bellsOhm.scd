/*
Wednesday, September 11th 2013
bellsOhm.scd
prm
*/

~henryOhm.bells = (

	main: 0,
	record: 8,
	playArray: [1, 9, 17, 25, 2, 10, 18, 26],

	vol: 15,

	makeOSC: { | self |
		OSCdef(\henryBellsOhm, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \bellsTop } { self.spawn(val); }
			{ id == \bellsRecord } { self.recordOhm(val); }
      { id == \bellsPlay } { self.playOhm(val); }
		}, \henryControl, ~scLang);

		OSCdef(\henryBellsOhmRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case

			{ id == \bellsVol } { if ( val == 1, { self.makeVol; }) }
			{ id == \bellsRecord } { if ( val == 1, { self.makeRecordMIDI; } ) }
			{ id == \bellsPlay } { if ( val == 1, { self.makePlayMIDI; } ) }

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
	},

	killButtons: { | self |
		self.topOhm(0);
		self.killRecord;
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
				~restoreOhm.henry.page.put(self.main, \white);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.henry.page.put(self.main, \red);
			}
		);
		self;
	},

  makeRecord: { | self |
    ~ohm.turnRed(self.record);
    ~restoreOhm.henry.page.put(self.record, \red);
    self.makeRecordMIDI;
    ~restoreOhm.henry.bellsRecord = 1;
    self;
  },

  killRecord: { | self |
    ~ohm.turnOff(self.record);
    ~restoreOhm.henry.page.put(self.record, \off);
    self.killRecordMIDI;
    ~restoreOhm.henry.bellsRecord = 0;
    self;
  },

  makeRecordMIDI: { | self |
    MIDIdef.noteOn(\bellsRecord, {
      ~henry.bells.recordBells;
    }, self.record);
    self;
  },

  killRecordMIDI: { | self |
    MIDIdef(\bellsRecord).free;
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
        ("~henry.bells.toggle" ++ (i + 1)).interpret;
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
			var amp = val.linlin(0, 127, 0, 9.dbamp);
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