/*
Wednesday, September 4th 2013
fifteenKOhmscd
prm
*/

~neverOhm.router = (

	main: 64,
	input1: 65,
	input2: 73,
	input3: 66,
	input4: 74,
  dist: 59,

	makeOSC: { | self |
		OSCdef(\neverRouterOhm, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \routerTop } { self.spawn(val); }
			{ id == \routerInput } { self.inputOhm(val) }
      { id == \routerDist } { self.distOhm(val) }

		}, \neverControl, ~scLang);

		OSCdef(\neverFifteenKOhmRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \routerInput1 } { if ( val == 1, { self.makeInput1MIDI; }); }
			{ id == \routerInput2 } { if ( val == 1, { self.makeInput2MIDI; }); }
			{ id == \routerInput3 } { if ( val == 1, { self.makeInput3MIDI; }); }
			{ id == \routerInput4 } { if ( val == 1, { self.makeInput4MIDI; }); }
      { id == \routerDist } { if( val == 1, { self.makeDistMIDI; }); }
		}, \restoreOhmNever, ~scLang);

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
		self.makeInput1;
		self.makeInput2;
		self.makeInput3;
		self.makeInput4;
    self.makeDist;
		self;
	},

	killButtons: { | self |
		self.topOhm(0);
		self.killInput1;
		self.killInput2;
		self.killInput3;
		self.killInput4;
    self.killDist;
		self;
	},

	makeFaders: { | self |

		self;
	},

	killFaders: { | self |

		self;
	},

	topOhm: { | self, val |
		if( val == 1,
			{
				~ohm.turnYellow(self.main);
				~restoreOhm.never.page.put(self.main, \yellow);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.never.page.put(self.main, \red);
			}
		);
		self;
	},

	makeInput1: { | self |
		~ohm.turnGreen(self.input1);
		~restoreOhm.never.page.put(self.input1, \green);
		self.makeInput1MIDI;
		~restoreOhm.never.routerInput1 = 1;
		self;
	},

	killInput1: { | self |
		~ohm.turnOff(self.input1);
		~restoreOhm.never.page.put(self.input1, \off);
		self.killInput1MIDI;
		~restoreOhm.never.routerInput1 = 0;
		self;
	},

	makeInput1MIDI: { | self |
		MIDIdef.noteOn(\routerInput1, {
			~never.router.setIn1;
			~scLang.sendMsg(\neverControl, \routerInput, ~never.router.currentIn);
		}, self.input1);
		self;
	},

	killInput1MIDI: { | self |
		MIDIdef(\routerInput1).free;
		self;
	},

	makeInput2: { | self |
		~ohm.turnBlue(self.input2);
		~restoreOhm.never.page.put(self.input2, \blue);
		self.makeInput2MIDI;
		~restoreOhm.never.routerInput2 = 1;
		self;
	},

	killInput2: { | self |
		~ohm.turnOff(self.input2);
		~restoreOhm.never.page.put(self.input2, \off);
		self.killInput2MIDI;
		~restoreOhm.never.routerInput2 = 0;
		self;
	},

	makeInput2MIDI: { | self |
		MIDIdef.noteOn(\routerInput2On, {
			~never.router.setIn2;
			~scLang.sendMsg(\neverControl, \routerInput, ~never.router.currentIn);
		}, self.input2);
		MIDIdef.noteOff(\routerInput2Off, {
			~never.router.setIn1;
			~scLang.sendMsg(\neverControl, \routerInput, ~never.router.currentIn);
		}, self.input2);
		self;
	},

	killInput2MIDI: { | self |
		MIDIdef(\routerInput2On).free;
		MIDIdef(\routerInput2Off).free;
		self;
	},

	makeInput3: { | self |
		~ohm.turnBlue(self.input3);
		~restoreOhm.never.page.put(self.input3, \blue);
		self.makeInput3MIDI;
		~restoreOhm.never.routerInput3 = 1;
		self;
	},

	killInput3: { | self |
		~ohm.turnOff(self.input3);
		~restoreOhm.never.page.put(self.input3, \off);
		self.killInput3MIDI;
		~restoreOhm.never.routerInput3 = 0;
		self;
	},

	makeInput3MIDI: { | self |
		MIDIdef.noteOn(\routerInput3On, {
			~never.router.setIn3;
			~scLang.sendMsg(\neverControl, \routerInput, ~never.router.currentIn);
		}, self.input3);
		MIDIdef.noteOff(\routerInput3Off, {
			~never.router.setIn1;
			~scLang.sendMsg(\neverControl, \routerInput, ~never.router.currentIn);
		}, self.input3);
		self;
	},

	killInput3MIDI: { | self |
		MIDIdef(\routerInput3On).free;
		MIDIdef(\routerInput3Off).free;
		self;
	},

	makeInput4: { | self |
		~ohm.turnBlue(self.input4);
		~restoreOhm.never.page.put(self.input4, \blue);
		self.makeInput4MIDI;
		~restoreOhm.never.routerInput4 = 1;
		self;
	},

	killInput4: { | self |
		~ohm.turnOff(self.input4);
		~restoreOhm.never.page.put(self.input4, \off);
		self.killInput4MIDI;
		~restoreOhm.never.routerInput4 = 0;
		self;
	},

	makeInput4MIDI: { | self |
		MIDIdef.noteOn(\routerInput4On, {
			~never.router.setIn4;
			~scLang.sendMsg(\neverControl, \routerInput, ~never.router.currentIn);
		}, self.input4);
		MIDIdef.noteOff(\routerInput4Off, {
			~never.router.setIn1;
			~scLang.sendMsg(\neverControl, \routerInput, ~never.router.currentIn);
		}, self.input4);
		self;
	},

	killInput4MIDI: { | self |
		MIDIdef(\routerInput4On).free;
		MIDIdef(\routerInput4Off).free;
		self;
	},

	inputOhm: { | self, val |
		case
		{ val == 1 }
		{
			~ohm.turnGreen(self.input1);
			~restoreOhm.never.page.put(self.input1, \green);
			~ohm.turnBlue(self.input2);
			~restoreOhm.never.page.put(self.input2, \blue);
			~ohm.turnBlue(self.input3);
			~restoreOhm.never.page.put(self.input3, \blue);
			~ohm.turnBlue(self.input4);
			~restoreOhm.never.page.put(self.input4, \blue);
		}
		{ val == 2 }
		{
			~ohm.turnBlue(self.input1);
			~restoreOhm.never.page.put(self.input1, \blue);
			~ohm.turnGreen(self.input2);
			~restoreOhm.never.page.put(self.input2, \green);
			~ohm.turnBlue(self.input3);
			~restoreOhm.never.page.put(self.input3, \blue);
			~ohm.turnBlue(self.input4);
			~restoreOhm.never.page.put(self.input4, \blue);
		}
		{ val == 3 }
		{
			~ohm.turnBlue(self.input1);
			~restoreOhm.never.page.put(self.input1, \blue);
			~ohm.turnBlue(self.input2);
			~restoreOhm.never.page.put(self.input2, \blue);
			~ohm.turnGreen(self.input3);
			~restoreOhm.never.page.put(self.input3, \green);
			~ohm.turnBlue(self.input4);
			~restoreOhm.never.page.put(self.input4, \blue);
		}
		{ val == 4 }
		{
			~ohm.turnBlue(self.input1);
			~restoreOhm.never.page.put(self.input1, \blue);
			~ohm.turnBlue(self.input2);
			~restoreOhm.never.page.put(self.input2, \blue);
			~ohm.turnBlue(self.input3);
			~restoreOhm.never.page.put(self.input3, \blue);
			~ohm.turnGreen(self.input4);
			~restoreOhm.never.page.put(self.input4, \green);
		}
	},

  makeDist: { | self |
    ~ohm.turnYellow(self.dist);
    ~restoreOhm.never.page.put(self.dist, \yellow);
    self.makeDistMIDI;
    ~restoreOhm.never.routerDist = 1;
    self;
  },

  killDist: { | self |
    ~ohm.turnOff(self.dist);
    ~restoreOhm.never.page.put(self.dist, \off);
    self.killDistMIDI;
    ~restoreOhm.never.routerDist = 0;
    self;
  },

  makeDistMIDI: { | self |
    MIDIdef.noteOn(\routerDistOn, {
      ~never.router.distToggle;
      ~scLang.sendMsg(\neverControl, \routerDist, ~never.router.distState);
    }, self.dist);

  },

  killDistMIDI: { | self |
    MIDIdef(\routerDistOn).free;
    self;
  },

  distOhm: { | self, val |
    if( val == 1,
      { ~ohm.turnWhite(self.dist); },
      { ~ohm.turnYellow(self.dist); }
    );
    self;
  },


	makeDials: { | self |
		self;
	},

	killDials: { | self |
		self;
	},

);