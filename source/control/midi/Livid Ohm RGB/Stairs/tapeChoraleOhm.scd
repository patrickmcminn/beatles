/*
Wednesday, August 28th 2013
trumpetOhm.scd
prm
*/

~stairsOhm.tapeChorale = (

	main: 0,

	playChorale: 8,

	erosion: 16,
	radio1: 1,
	radio2: 9,
	tape: 17,

	vol: 14,

	radio2Vol: 22,
	radio1Vol: 23,
	tapeVol: 15,

	makeOSC: { | self |
		OSCdef(\stairsTapeChoraleOhm, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \tapeChoraleTop } { self.spawn(val); }
			{ id == \tapeChoralePlay } { self.playOhm(val); }
			{ id == \tapeChoraleRadio1 } { self.radio1Ohm(val) }
			{ id == \tapeChoraleRadio2 } { self.radio2Ohm(val); }
			{ id == \tapeChoraleTape } { self.tapeOhm(val); }
		}, \stairsControl, ~scLang);

		OSCdef(\stairsTapeChoraleOhmRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \tapeChoraleVol } { if ( val == 1, { self.makeChoraleVol; }) }
			{ id == \radioNoise1Vol } { if ( val == 1, { self.makeRadio1Vol; }) }
			{ id == \radioNoise2Vol } { if ( val == 1, { self.makeRadio2Vol; }) }
			{ id == \tapeNoiseVol } { if ( val == 1, { self.makeTapeVol; }) }
			{ id == \tapeChoralePlay } { if ( val == 1, { self.makePlayMIDI; }) }
			{ id == \radio1 } { if ( val == 1, { self.makeRadio1MIDI; }) }
			{ id == \radio2 } { if ( val == 1, { self.makeRadio2MIDI; }) }
			{ id == \tape } { if ( val == 1, { self.makeTapeMIDI; }) }
			{ id == \erosion } { if ( val == 1, { self.makeErodeMIDI; }) }
		}, \restoreOhmStairs, ~scLang);
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
		self.makeTapeChoralePlay;
		self.makeErosion;
		self.makeRadio1;
		self.makeRadio2;
		self.makeTape;
		self;
	},

	killButtons: { | self |
		self.topOhm(0);
		self.killErosion;
		self.killTapeChoralePlay;
		self.killRadio1;
		self.killRadio2;
		self.killTape;
		self;
	},

	makeFaders: { | self |
		self.makeChoraleVol;
		self.makeRadio1Vol;
		self.makeRadio2Vol;
		self.makeTapeVol;
		self;
	},

	killFaders: { | self |
		self.killChoraleVol;
		self.killRadio1Vol;
		self.killRadio2Vol;
		self.killTapeVol;
		self;
	},

	makeDials: { | self |

		self;
	},

	killDials: { | self |

		self;
	},

	topOhm: { | self, val |
		if( val == 1,
			{
				~ohm.turnGreen(self.main);
				~restoreOhm.stairs.page.put(self.main, \green);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.rita.page.put(self.main, \red);
			}
		);
		self;
	},

	makeTapeChoralePlay: { | self |
		~ohm.turnBlue(self.playChorale);
		~restoreOhm.stairs.page.put(self.playChorale, \blue);
		self.makePlayMIDI;
		~restoreOhm.stairs.tapeChoralePlay = 1;
		self;
	},

	killTapeChoralePlay: { | self |
		~ohm.turnOff(self.playChorale);
		~restoreOhm.stairs.page.put(self.playChorale, \off);
		self.killPlayMIDI;
		~restoreOhm.stairs.tapeChoralePlay = 0;
		self;
	},

	makePlayMIDI: { | self |
		MIDIdef.noteOn(\tapeChoralePlay, {
			~stairs.tapeChorale.toggleChorale;
			~scLang.sendMsg(\stairsControl, \tapeChoralePlay, ~stairs.tapeChorale.playState);
		}, self.playChorale);
		self;
	},

	killPlayMIDI: { | self |
		MIDIdef(\tapeChoralePlay).free;
		self;
	},

	playOhm: { | self, val |
		if( val == 1,
			{ ~ohm.turnGreen(self.playChorale); ~restoreOhm.stairs.page.put(self.playChorale, \green); },
			{ ~ohm.turnRed(self.playChorale); ~restoreOhm.stairs.page.put(self.playChorale, \red) }
		);
		self;
	},

	makeErosion: { | self |
		~ohm.turnWhite(self.erosion);
		~restoreOhm.stairs.page.put(self.erosion, \white);
		self.makeErosionMIDI;
		~restoreOhm.stairs.erosion = 1;
		self;
	},

	killErosion: { | self |
		~ohm.turnOff(self.erosion);
		~restoreOhm.stairs.page.put(self.erosion, \off);
		self.killErosionMIDI;
		~restoreOhm.stairs.erosion = 0;
		self;
	},

	makeErosionMIDI: { | self |
		MIDIdef.noteOn(\tapeChoraleErosionOn, {
			~stairs.tapeChorale.erodeChorale;
			~ohm.turnYellow(self.erosion);
		}, self.erosion);
		MIDIdef.noteOff(\tapeChoraleErosionOff, {
			~stairs.tapeChorale.stopErosion;
			~ohm.turnWhite(self.erosion);
		}, self.erosion);
		self;
	},

	killErosionMIDI: { | self |
		MIDIdef(\tapeChoraleErosionOn).free;
		MIDIdef(\tapeChoraleErosionOff).free;
		self;
	},

	makeRadio1: { | self |
		~ohm.turnBlue(self.radio1);
		~restoreOhm.stairs.page.put(self.radio1, \blue);
		self.makeRadio1MIDI;
		~restoreOhm.stairs.radio1 = 1;
		self;
	},

	killRadio1: { | self |
		~ohm.turnOff(self.radio1);
		~restoreOhm.stairs.page.put(self.radio1, \off);
		self.killRadio1MIDI;
		~restoreOhm.stairs.radio1 = 0;
		self;
	},

	makeRadio1MIDI: { | self |
		MIDIdef.noteOn(\playRadio1, {
			~stairs.tapeChorale.toggleRadioNoise1;
			~scLang.sendMsg(\stairsControl, \tapeChoraleRadio1, ~stairs.tapeChorale.radioNoise1State;);
		}, self.radio1);
		self;
	},

	killRadio1MIDI: { | self |
		MIDIdef(\playRadio1).free;
		self;
	},

	radio1Ohm: { | self, val |
		if( val == 1,
			{ ~ohm.turnPurple(self.radio1); ~restoreOhm.stairs.page.put(self.radio1, \purple); },
			{ ~ohm.turnBlue(self.radio1); ~restoreOhm.stairs.page.put(self.radio1, \blue); },
		);
		self;
	},

	makeRadio2: { | self |
		~ohm.turnCyan(self.radio2);
		~restoreOhm.stairs.page.put(self.radio2, \cyan);
		self.makeRadio2MIDI;
		~restoreOhm.stairs.radio2 = 1;
		self;
	},

	killRadio2: { | self |
		~ohm.turnOff(self.radio2);
		~restoreOhm.stairs.page.put(self.radio2, \off);
		self.killRadio2MIDI;
		~restoreOhm.stairs.radio2 = 0;
		self;
	},

	makeRadio2MIDI: { | self |
		MIDIdef.noteOn(\playRadio2, {
			~stairs.tapeChorale.toggleRadioNoise2;
			~scLang.sendMsg(\stairsControl, \tapeChoraleRadio2, ~stairs.tapeChorale.radioNoise2State;);
		}, self.radio2);
		self;
	},

	killRadio2MIDI: { | self |
		MIDIdef(\playRadio2).free;
		self;
	},

	radio2Ohm: { | self, val |
		if( val == 1,
			{ ~ohm.turnPurple(self.radio2); ~restoreOhm.stairs.page.put(self.radio2, \purple); },
			{ ~ohm.turnCyan(self.radio2); ~restoreOhm.stairs.page.put(self.radio2, \cyan); },
		);
		self;
	},

	makeTape: { | self |
		~ohm.turnYellow(self.tape);
		~restoreOhm.stairs.page.put(self.tape, \yellow);
		self.makeTapeMIDI;
		~restoreOhm.stairs.tape = 1;
		self;
	},

	killTape: { | self |
		~ohm.turnOff(self.tape);
		~restoreOhm.stairs.page.put(self.tape, \off);
		self.killTapeMIDI;
		~restoreOhm.stairs.tape = 0;
		self;
	},

	makeTapeMIDI: { | self |
		MIDIdef.noteOn(\playTape, {
			~stairs.tapeChorale.toggleTapeNoise;
			~scLang.sendMsg(\stairsControl, \tapeChoraleTape, ~stairs.tapeChorale.tapeNoiseState);
		}, self.tape);
		self;
	},

	killTapeMIDI: { | self |
		MIDIdef(\playTape).free;
		self;
	},

	tapeOhm: { | self, val |
		if( val == 1,
			{ ~ohm.turnPurple(self.tape); ~restoreOhm.stairs.page.put(self.tape, \purple); },
			{ ~ohm.turnYellow(self.tape); ~restoreOhm.stairs.page.put(self.tape, \yellow); },
		);
		self;
	},


	makeChoraleVol: { | self |
		MIDIdef.cc(\tapeChoraleVol, { | val |
			var amp = val.linlin(0, 127, 0, 4.dbamp);
			~stairs.tapeChorale.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.stairs.tapeChoraleVol = 1;
		self;
	},

	killChoraleVol: { | self |
		MIDIdef(\tapeChoraleVol).free;
		~restoreOhm.stairs.tapeChoraleVol = 0;
		self;
	},

	makeRadio1Vol: { | self |
		MIDIdef.cc(\radio1Vol, { | val |
			var amp = val.linlin(0, 127, 0, 6.dbamp);
			if( ~stairs.tapeChorale.radioNoise1State == 1, {
				~stairs.tapeChorale.radioNoise1.set(\amp, amp);
			});
		}, self.radio1Vol);
		self;
	},

	killRadio1Vol: { | self |
		MIDIdef(\radio1Vol).free;
		self;
	},

	makeRadio2Vol: { | self |
		MIDIdef.cc(\radio2Vol, { | val |
			var amp = val.linlin(0, 127, 0, 6.dbamp);
			if( ~stairs.tapeChorale.radioNoise2State == 1, {
				~stairs.tapeChorale.radioNoise2.set(\amp, amp);
			});
		}, self.radio2Vol);
		self;
	},

	killRadio2Vol: { | self |
		MIDIdef(\radio2Vol).free;
		self;
	},

	makeTapeVol: { | self |
		MIDIdef.cc(\tapeVol, { | val |
			var amp = val.linlin(0, 127, 0, 6.dbamp);
			if( ~stairs.tapeChorale.tapeNoiseState == 1, {
				~stairs.tapeChorale.tapeNoise.set(\amp, amp);
			});
		}, self.tapeVol);
		self;
	},

	killTapeVol: { | self |
		MIDIdef(\tapeVol).free;
		self;
	},

	makeDials: { | self |

		self;
	},

	killDials: { | self |

		self;
	},



);
