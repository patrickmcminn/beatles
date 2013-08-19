/*
Saturday, August 17th 2013
No Worse Page.scd
prm
*/

var strings, drone, brokenPiano, vamp;
strings = 0;
drone = 1;
brokenPiano = 2;
vamp = 3;

~page.worse = ( );

~page.worse.top = {
	~ohm.clearAll;
	~ohm.addEssential;

	// string granulation:
	~ohm.turnPurple(strings);
	MIDIdef.noteOn(\strings, {
		~worse.strings.spawn;
		~scLang.sendMsg(\worseControl, \stringsTop, ~worse.strings.state);
	}, strings);

	// tanpura drone:
	~ohm.turnCyan(drone);
	MIDIdef.noteOn(\drone, {
		~worse.drone.spawn;
		~scLang.sendMsg(\worseControl, \droneTop, ~worse.drone.state);
	}, drone);

	// brokenPiano:
	~ohm.turnWhite(brokenPiano);
	MIDIdef.noteOn(\brokenPiano, {
		~worse.brokenPiano.spawn;
		~scLang.sendMsg(\worseControl, \brokenPianoTop, ~worse.brokenPiano.state);
	}, brokenPiano);

	// vamp:
	~ohm.turnBlue(vamp);
	MIDIdef.noteOn(\vamp, {
		~worse.vamp.spawn;
		~scLang.sendMsg(\worseControl, \vampTop, ~worse.vamp.state);
	}, vamp);

	~restoreOhm.light.keysValuesDo({ | name, state |  ~scLang.sendMsg(\restoreOhmLight, name, state); });

	~restoreOhm.light.page.do({ | color, note |
		case
		{ color == \off } { ~ohm.turnOff(note); }
		{ color == \blue } { ~ohm.turnBlue(note); }
		{ color == \red } { ~ohm.turnRed(note); }
		{ color == \purple } { ~ohm.turnPurple(note); }
		{ color == \green } { ~ohm.turnGreen(note); }
		{ color == \yellow } { ~ohm.turnYellow(note); }
		{ color == \cyan } { ~ohm.turnCyan(note); }
		{ color == \white } { ~ohm.turnWhite(note); }
	});
};