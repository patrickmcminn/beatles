/*
Tuesday, August 27th 2013
Henry Page.scd
prm
*/

var bells, harmonica, toyPiano, triangle;
bells = 0;
harmonica = 3;
triangle = 5;


~page.henry = ( );

~page.henry.top = {
	~ohm.clearAll;
	~ohm.addEssential;

	~ohm.turnBlue(bells);
	MIDIdef.noteOn(\henryBells, {
		~henry.bells.spawn;
		~scLang.sendMsg(\henryControl, \bellsTop, ~henry.bells.state);
	}, bells);

	~ohm.turnGreen(harmonica);
	MIDIdef.noteOn(\henryHarmonica, {
		~henry.harmonica.spawn;
		~scLang.sendMsg(\henryControl, \harmonicaTop, ~henry.harmonica.state);
	}, harmonica);

	~ohm.turnWhite(triangle);
	MIDIdef.noteOn(\henryTriangle, {
		~henry.triangle.spawn;
		~scLang.sendMsg(\henryControl, \triangleTop, ~henry.triangle.state);
	}, triangle);


	~restoreOhm.henry.keysValuesDo({ | name, state |  ~scLang.sendMsg(\restoreOhmHenry, name, state); });

	~restoreOhm.henry.page.do({ | color, note |
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