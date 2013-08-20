/*
Saturday, August 17th 2013
stringsOhm.scd
prm
*/

~lucyOhm.texture = (

	main: 0,
	playGran: 8,

	trigRateTop: 12,

	vol: 14,

	makeOSC: { | self |
		OSCdef(\lucyTextureOhm, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \textureTop } { self.spawn(val); }
			{ id == \textureToggleGran} { self.playGranOhm(val); }
		}, \lucyControl, ~scLang);

		OSCdef(\lucyTextureOhmRestore, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case

			{ id == \textureVol } { if ( val == 1, { self.makeVol; }) }
			{ id == \texturelayGran } { if ( val == 1, { self.makePlayGranMIDI; } ) }
			{ id == \textureDials } { if ( val == 1, { self.makeDials; }); }

		}, \restoreOhmLucy, ~scLang);

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
		self.makePlayGran;
		self;
	},

	killButtons: { | self |
		self.topOhm(0);
		self.killPlayGran;
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
				~restoreOhm.worse.page.put(self.main, \white);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.worse.page.put(self.main, \red);
			}
		);
		self;
	},

	makePlayGran: { | self |
		~ohm.turnBlue(self.playGran);
		~restoreOhm.worse.page.put(self.playGran, \blue);
		self.makePlayGranMIDI;
		~restoreOhm.lucy.texturePlayGran = 1;
		self;
	},

	killPlayGran: { | self |
		~ohm.turnOff(self.playGran);
		~restoreOhm.worse.page.put(self.playGran, \off);
		self.killPlayGranMIDI;
		~restoreOhm.lucy.texturePlayGran = 0;
		self;
	},

	makePlayGranMIDI: { | self |
		MIDIdef.noteOn(\texturePlayGran, {
			~lucy.texture.toggleGran;
			~scLang.sendMsg(\lucyControl, \textureToggleGran, ~lucy.texture.playState);
		}, self.playGran);
		self;
	},

	killPlayGranMIDI: { | self |
		MIDIdef(\texturePlayGran).free;
		self;
	},

	playGranOhm: { | self, val |
		if( val == 1,
			{
				~ohm.turnGreen(self.playGran);
				~restoreOhm.lucy.page.put(self.playGran, \green);
			},
			{
				~ohm.turnRed(self.playGran);
				~restoreOhm.lucy.page.put(self.playGran, \red);
			}
		);
		self;
	},


	makeVol: { | self |
		MIDIdef.cc(\textureVol, { | val |
			var amp = val.linlin(0, 127, 0, -2.dbamp);
			~lucy.texture.fader.set(\amp, amp);
		}, self.vol);
		~restoreOhm.lucy.textureVol = 1;
		self;

	},

	killVol: { | self |
		MIDIdef(\textureVol).free;
		~restoreOhm.texture.stringsVol = 0;
		self;
	},

	makeDials: { | self |
		self.makeTrigRate;
		~restoreOhm.worse.stringDials = 1;
		self;
	},

	killDials: { | self |
		self.killTrigRate;
		~restoreOhm.worse.stringDials = 0;
		self;
	},

	makeTrigRate: { | self |
		MIDIdef.cc(\textureTrigRate, { | val |
			var rate = val.linlin(0, 127, 1.0, 12.0);
			~lucy.texture.trigRate = rate;
			if( ~lucy.texture.playState == 1, { ~lucy.texture.gran.set(\trigRate, rate); });
		}, self.trigRateTop);
		self;
	},

	killTrigRate: { | self |
		MIDIdef(\textureTrigRate).free;
		self;
	},

);