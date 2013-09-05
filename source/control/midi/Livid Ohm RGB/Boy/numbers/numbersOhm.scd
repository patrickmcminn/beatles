/*
Thursday, September 5th 2013
numberOhm.scd
prm
*/

~boyOhm.numbers = (

	main: 1,
	play540: 9,
	play6959: 17,
	numbersArray: [2, 10, 18, 26, 34, 42, 50, 58, 3, 11, 19, 27, 35, 43, 51, 59, 4, 12, 20, 28, 36, 44, 52, 60],

	vol: 15,

	makeOSC: { | self |
		OSCdef(\boyNumbersRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \numbersTop } { self.spawn(val); }
			{ id == \numbers540 } { self.make540Ohm(val); }
			{ id == \numbers6959 } { self.make6959Ohm(val); }
			{ id == \numbersPlay} { self.numbersOhm(val); }
		}, \boyControl, ~scLang);

		OSCdef(\boyNumbersOhmRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \numbersVol } { if ( val == 1, { self.makeVol; }) }
			{ id == \play540 } { if ( val == 1, { self.make540MIDI; }) }
			{ id == \play6959 } { if ( val == 1, { self.make6959MIDI; }) }
			{ id == \numbersPlay } { if ( val == 1, { self.makeNumbersMIDI; }) }
		}, \restoreOhmBoy, ~scLang);
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
		self.make540;
		self.make6959;
		self.makeNumbers;
		self;
	},

	killButtons: { | self |
		self.topOhm(0);
		self.kill540;
		self.kill6959;
		self.killNumbers;
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
				~restoreOhm.boy.page.put(self.main, \white);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.boy.page.put(self.main, \red);
			}
		);
		self;
	},

	make540: { | self |
		~ohm.turnYellow(self.play540);
		~restoreOhm.boy.page.put(self.play540, \yellow);
		self.make540MIDI;
		~restoreOhm.boy.play540 = 1;
		self;
	},

	kill540: { | self |
		~ohm.turnOff(self.play540);
		~restoreOhm.boy.page.put(self.play540, \off);
		self.kill540MIDI;
		~restoreOhm.boy.play540 = 0;
		self;
	},

	make540MIDI: { | self |
		MIDIdef.noteOn(\boyPlay540, {
			~boy.numbers.play540;
			~scLang.sendMsg(\boyControl, \numbers540, 1);
		}, self.play540);
		self;
	},

	kill540MIDI: { | self |
		MIDIdef(\boyPlay540).free;
		self;
	},

	make540Ohm: { | self, val, time = 2 |
		if( val == 1, {
			~ohm.blink(self.play540, \green, time);
			{ ~ohm.turnYellow(self.play540) }.defer(time);
		});

		self;
	},


	make6959: { | self |
		~ohm.turnBlue(self.play6959);
		~restoreOhm.boy.page.put(self.play6959, \blue);
		self.make6959MIDI;
		~restoreOhm.boy.play6959 = 1;
		self;
	},

	kill6959: { | self |
		~ohm.turnOff(self.play6959);
		~restoreOhm.boy.page.put(self.play6959, \off);
		self.kill6959MIDI;
		~restoreOhm.boy.play6959 = 0;
		self;
	},

	make6959MIDI: { | self |
		MIDIdef.noteOn(\play6959, {
			~boy.numbers.play6959;

		}, self.play6959);
		self;
	},

	kill6959MIDI: { | self |
		MIDIdef(\play6959).free;
		self;
	},

	make6959Ohm: { | self, val, time = 2 |
		if( val == 1, {
			~ohm.blink(self.play6959, \green, time);
			{ ~ohm.turnBlue(self.play6959) }.defer(time);
		});
		self;
	},

	makeNumbers: { | self |
		self.numbersArray.do({ | led, i |
			~ohm.turnPurple(led);
			~restoreOhm.boy.page.put(led, \purple);
		});
		self.makeNumbersMIDI;
		~restoreOhm.boy.numbersPlay = 1;
		self;
	},

	killNumbers: { | self |
		self.numbersArray.do({ | led, i |
			~ohm.turnOff(led);
			~restoreOhm.boy.page.put(led, \off);
		});
		self.killNumbersMIDI;
		~restoreOhm.boy.numbersPlay = 0;
	},

	makeNumbersMIDI: { | self |
		self.numbersArray.do({ | led, i |
			MIDIdef.noteOn(("numbersPlay" ++ (i + 1)).asSymbol, {
				("~boy.numbers.play" ++ (i + 1)).interpret;
				~scLang.sendMsg(\boyControl, \numbersPlay, led);
			}, led);
		});
		self;
	},

	killNumbersMIDI: { | self |
		self.numbersArray.do({ | led, i |
			MIDIdef((("numbersPlay" ++ (i + 1)).asSymbol)).free;
		});
		self;
	},

	numbersOhm: { | self, val, time = 0.5 |
		~ohm.blink(val, \green, time);
		{ ~ohm.turnPurple(val) }.defer(time);
		self;
	},


	makeVol: { | self |
		MIDIdef.cc(\numbersVol, { | val |
			var amp = val.linlin(0, 127, 0, 6.dbamp);
			~boy.numbers.fader.set(\amp, amp)
		}, self.vol);
		~restoreOhm.boy.numbersVol = 1;
		self;
	},

	killVol: { | self |
		MIDIdef(\numbersVol).free;
		~restoreOhm.boy.numbersVol = 0;
		self;
	},

	makeDials: { | self |
		self;
	},

	killDials: { | self |
		self;
	},

);
