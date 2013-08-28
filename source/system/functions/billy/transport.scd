/*
Wednesday, August 28th 2013
clock.scd
prm
*/

~billy.transport = (

	state: 0,
	tempo: 126/60,

	spawn: { | self |
		if (self.state == 0, { self.init; }, { self.kill });
		self;
	},

	init: { | self |
		self.tempoClock = TempoClock.new(self.tempo);
		self;
	},

	kill: { | self |
		self.tempoClock.clear;
		self;
	},

)