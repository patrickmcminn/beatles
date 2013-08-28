/*
Wednesday, August 28th 2013
transportOhm.scd
prm
*/

~billyOhm.transport = (

	main: 0,

	makeOSC: { | self |
		OSCdef(\billyTransportOhm, { | msg |
			var id, val;
			id = msg.at(1);
			val = msg.at(2);
			case
			{ id == \transportTop } { self.spawn(val); }
		}, \billyControl, ~scLang);
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
		self;
	},

	killButtons: { | self |
		self.topOhm(0);
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
				~ohm.turnWhite(self.main);
				~restoreOhm.billy.page.put(self.main, \white);
			},
			{
				~ohm.turnRed(self.main);
				~restoreOhm.billy.page.put(self.main, \red);
			}
		);
		self;
	},

);