/*
Sunday, September 15th 2013
textureOhm.scd
prm
*/

~spaceOhm.drone = (

	main: 1,
  recordArray: [2, 10, 18, 26],
  playArray: [3, 11, 19, 27],
  fake: 63,

	vol: 15,

	makeOSC: { | self |
		OSCdef(\spaceDrone, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \droneTop } { self.spawn(val); }
			{ id == \playDrone } { self.playOhm(val); }
      { id == \fakeBuffer } { self.fakeOhm(val); }
		}, \spaceControl, ~scLang);

		OSCdef(\spaceDroneRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \droneVol } { if ( val == 1, { self.makeVol; }) }
      { id == \recordDrone } { if ( val == 1, { self.makeRecordMIDI; }) }
			{ id == \playDrone } { if( val == 1, { self.makePlayMIDI; }) }
      { id == \fakeBuffer } { if ( val == 1, { self.makeFakeMIDI; }) }
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
		self.makeRecord;
    self.makePlay;
    self.makeFake;
		self;
	},

	killButtons: { | self |
		self.topOhm(0);
		self.killRecord;
    self.killPlay;
    self.killFake;
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
				~restoreOhm.space.page.put(self.main, \cyan);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.space.page.put(self.main, \red);
			}
		);
		self;
	},

  makeRecord: { | self |
    self.recordArray.do({ | led, i |
      ~ohm.turnRed(led);
      ~restoreOhm.space.page.put(led, \red);
    });
    self.makeRecordMIDI;
    ~restoreOhm.space.recordDrone = 1;
    self;
  },

  killRecord: { | self |
    self.recordArray.do({ | led, i |
      ~ohm.turnOff(led);
      ~restoreOhm.space.page.put(led, \off);
    });
    self.killRecordMIDI;
    ~restoreOhm.space.recordDrone = 0;
    self;
  },

  makeRecordMIDI: { | self |
    self.recordArray.do({ | led, i |
      MIDIdef.noteOn(("spaceRecordDrone" ++ (i + 1)).asSymbol, {
        ~space.drone.recordBuf(i);
      }, led);
    });
    self;
  },

  killRecordMIDI: { | self |
    self.recordArray.do({ | led, i |
      MIDIdef(("spaceRecordDrone" ++ (i + 1)).asSymbol).free;
      self;
    });
    self;
  },

  makePlay: { | self |
    self.playArray.do({ | led, i |
      ~ohm.turnBlue(led);
      ~restoreOhm.space.page.put(led, \blue);
    });
    self.makePlayMIDI;
    ~restoreOhm.space.playDrone = 1;
    self;
  },

  killPlay: { | self |
    self.playArray.do({ | led, i |
      ~ohm.turnOff(led);
      ~restoreOhm.space.page.put(led, \off);
    });
    self.killPlayMIDI;
    ~restoreOhm.space.playDrone = 0;
    self;
  },

  makePlayMIDI: { | self |
    self.playArray.do({ | led, i |
      MIDIdef.noteOn(("spacePlayDrone" ++ (i + 1)).asSymbol, {
        ("~space.drone.toggleGran" ++ (i + 1)).interpret;
        ~scLang.sendMsg(\spaceControl, \playDrone, i);
      }, led);
    });
    self;
  },

  killPlayMIDI: { | self |
    self.playArray.do({ | led, i |
      MIDIdef(("spacePlayDrone" ++ (i + 1)).asSymbol).free;
    });
    self;
  },

  playOhm: { | self, val |
    if( ~space.drone.granState[val] == 1,
      { ~ohm.turnGreen(self.playArray[val]); ~restoreOhm.space.page.put(self.playArray[val], \green); },
      { ~ohm.turnBlue(self.playArray[val]); ~restoreOhm.space.page.put(self.playArray[val], \blue); }
    );
    self;
  },

  makeFake: { | self |
    ~ohm.turnRed(self.fake);
    ~restoreOhm.space.page.put(self.fake, \red);
    self.makeFakeMIDI;
    ~restoreOhm.space.fakeBuffer = 1;
    self;
  },

  killFake: { | self |
    ~ohm.turnOff(self.fake);
    ~restoreOhm.space.page.put(self.fake, \off);
    self.killFakeMIDI;
    ~restoreOhm.space.fakeBuffer = 0;
    self;
  },

  makeFakeMIDI: { | self |
    MIDIdef.noteOn(\spaceDroneFake, {
      ~space.drone.toggleFakeBuffers;
      ~scLang.sendMsg(\spaceControl, \fakeBuffer, ~space.drone.bufferState);
    }, self.fake);
    self;
  },

  killFakeMIDI: { | self |
    MIDIdef(\spaceDroneFake).free;
    self;
  },

  fakeOhm: { | self, val |
    if ( val == 1,
      { ~ohm.turnRed(self.fake); ~restoreOhm.space.page.put(self.fake, \red); },
      { ~ohm.turnGreen(self.fake); ~restoreOhm.space.page.put(self.fake, \green); }
    );
    self;
  },


	makeVol: { | self |
		MIDIdef.cc(\spaceDroneVol, { | val |
			var amp = val.linlin(0, 127, 0, 3.dbamp);
      ~space.drone.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.space.droneVol = 1;
		self;
	},

	killVol: { | self |
		MIDIdef(\spaceDroneVol).free;
		~restoreOhm.space.droneVol = 0;
		self;
	},

	makeDials: { | self |
		self;
	},

	killDials: { | self |
		self;
	},

);
