/*
Monday, August 19th 2013
tptAccomp.scd
prm
*/

~never.tptAccomp = (

	state: 0,
	muteState: 0,
	output: ~mixer.s2,

	spawn: { | self |
		if( self.state == 0, { self.init; }, { self.kill; });
		self;
	},

	init: { | self |
		self.makeGroups;
		self.makeBuffers;
		self.makeBusses;
		self.makeSynths;
		self.state = 1;
		self;
	},

	kill: { | self |
		self.killGroups;
		self.killBuffers;
		self.killBusses;
		self.killSynths;
		self.state = 0;
		self;
	},

	makeGroups: { | self |
		self.playGroup = Group.new(self.fader, \addBefore);
		self;
	},

	killGroups: { | self |
		self.playGroup.free;
		self;
	},

	makeBuffers: { | self |
		self.buffer = Buffer.allocConsecutive(9, s, s.sampleRate * 0.5, 1);
		self;
	},

	killBuffers: { | self |
		self.buffer.do({ | i | i.free; });
		self;
	},

	makeBusses: { | self |
		self.faderBus = Bus.audio;
		self;
	},

	killBusses: { | self |
		self.faderBus.free;
		self;
	},

	makeSynths: { | self |
		self.fader = Synth.tail(~group.fx, \pan, [\in, self.faderBus, \out, self.output, \amp, -6.dbamp]);
		self;
	},

	killSynths: { | self |
		self.fader.free;
		self;
	},

	recordTpt: { | self, num |
		Synth.tail(~group.fx, \recordBuf, [\in, ~inst.mute, \bufName, self.buffer[num]]);
		self;
	},

	muteToggle: { | self |
		if( self.muteState == 1, { self.mute; }, { self.unmute; });
		self;
	},

	mute: { | self |
		self.inFader.set(\mute, 0);
		self.muteState = 0;
		self;
	},

	unmute: { | self |
		self.inFader.set(\mute, 1);
		self.muteState = 1;
		self;
	},

	setOutput: { | self, output |
		case
		{ output == 1 } { self.set1; }
		{ output == 2 } { self.set2; }
		{ output == 3 } { self.set3; }
	},

	set1: { | self |
		self.output = ~mixer.s1;
		self.fader.set(\out, self.output);
		self;
	},

	set2: { | self |
		self.output = ~mixer.s2;
		self.fader.set(\out, self.output);
		self;
	},

	set3: { | self |
		self.output = ~mixer.s3;
		self.fader.set(\out, self.output);
		self;
	},

);