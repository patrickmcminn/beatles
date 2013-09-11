/*
Tuesday, August 20th 2013
Lucy Page.scd
prm
*/

var trumpet;
trumpet = 0;


~page.rita = ( );

~page.rita.top = {
	~ohm.clearAll;
	~ohm.addEssential;

	// trumpet:
	~ohm.turnWhite(trumpet);
	MIDIdef.noteOn(\ritaTrumpet, {
		~rita.trumpet.spawn;
		~scLang.sendMsg(\ritaControl, \trumpetTop, ~rita.trumpet.state);
	}, trumpet);

	~restoreOhm.rita.keysValuesDo({ | name, state |  ~scLang.sendMsg(\restoreOhmRita, name, state); });

	~restoreOhm.rita.page.do({ | color, note |
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