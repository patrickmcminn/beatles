/*
Tuesday, September 10th 2013
Stairs Page.scd
prm
*/

var chorale = 0;


~page.stairs = ( );

~page.stairs.top = {
	~ohm.clearAll;
	~ohm.addEssential;

	~ohm.turnPurple(chorale);
	MIDIdef.noteOn(\stairsTapeChorale, {
		~stairs.tapeChorale.spawn;
		~scLang.sendMsg(\stairsControl, \tapeChoraleTop, ~stairs.tapeChorale.state);
	}, chorale);


	~restoreOhm.stairs.keysValuesDo({ | name, state |  ~scLang.sendMsg(\restoreOhmStairs, name, state); });

	~restoreOhm.stairs.page.do({ | color, note |
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