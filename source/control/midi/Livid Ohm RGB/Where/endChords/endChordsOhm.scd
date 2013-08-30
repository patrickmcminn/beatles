/*
Thursday, August 29th 2013
endChordsOhm.scd
prm
*/

~whereOhm.endChords = (

	main: 5,
	playChords: 13,
	fade: 21,

	vol: 14,

	makeOSC: { | self |
		OSCdef(\whereEndChordsOhm, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \endChordsTop } { self.spawn(val); }
			{ id == \endChordsPlay } { self.chordsOhm(val) }

		}, \whereControl, ~scLang);

		OSCdef(\whereEndChordsOhmRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case

			{ id == \endChordsVol } { if ( val == 1, { self.makeVol; }) }
			{ id == \endChordsPlay } { if( val == 1, { self.makeChordsMIDI; }) }
			{ id == \endChordsFade } { if( val == 1, { self.makeFadeMIDI; }) }

		}, \restoreOhmWhere, ~scLang);

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
		self.makeChords;
		self.makeFade;
		self;
	},

	killButtons: { | self |
		self.topOhm(0);
		self.killChords;
		self.killFade;
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
				~restoreOhm.where.page.put(self.main, \cyan);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.where.page.put(self.main, \red);
			}
		);
		self;
	},

	makeChords: { | self |
		~ohm.turnBlue(self.playChords);
		~restoreOhm.where.page.put(self.playChords, \blue);
		self.makeChordsMIDI;
		~restoreOhm.where.endChordsPlay = 1;
		self;
	},

	killChords: { | self |
		~ohm.turnOff(self.playChords);
		~restoreOhm.where.page.put(self.playChords, \off);
		self.killChordsMIDI;
		~restoreOhm.where.endChordsPlay = 0;
		self;
	},

	makeChordsMIDI: { | self |
		MIDIdef.noteOn(\endChordsPlay, {
			~where.endChords.toggleChords;
			~scLang.sendMsg(\whereControl, \endChordsPlay, ~where.endChords.playState);
		}, self.playChords);
		self;
	},

	killChordsMIDI: { | self |
		MIDIdef(\endChordsPlay).free;
		self;
	},

	chordsOhm: { | self, val |
		if( val == 1,
			{
				~ohm.turnGreen(self.playChords);
				~restoreOhm.where.page.put(self.playChords, \green);
			},
			{
				~ohm.turnRed(self.playChords);
				~restoreOhm.where.page.put(self.playChords, \red);
			}
		);
		self;
	},

	makeFade: { | self |
		~ohm.turnYellow(self.fade);
		~restoreOhm.where.page.put(self.fade, \yellow);
		self.makeFadeMIDI;
		~restoreOhm.where.endChordsFade = 1;
		self;
	},

	killFade: { | self |
		~ohm.turnOff(self.fade);
		~restoreOhm.where.page.put(self.fade, \off);
		self.killFadeMIDI;
		~restoreOhm.where.endChordsFade = 0;
		self;
	},

	makeFadeMIDI: { | self |
		MIDIdef.noteOn(\endChordsFade, {
			~where.endChords.fadeIn;
			~ohm.turnGreen(self.fade;)
			{ ~ohm.turnYellow(self.fade); }.defer(~where.endChords.fadeTime);
			self;
		}, self.fade);
		self;
	},

	killFadeMIDI: { | self |
		MIDIdef(\endChordsFade).free;
		self;
	},

	makeVol: { | self |
		MIDIdef.cc(\endChordsVol, { | val |
			var amp = val.linlin(0, 127, 0, 1.5);
			~where.endChords.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.where.endChordsVol = 1;
		self;
	},

	killVol: { | self |
		MIDIdef(\endChordsVol).free;
		~restoreOhm.where.endChordsVol = 0;
		self;
	},

	makeDials: { | self |
		self;
	},

	killDials: { | self |
		self;
	},

);
