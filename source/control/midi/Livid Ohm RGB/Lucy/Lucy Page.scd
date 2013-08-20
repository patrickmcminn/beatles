/*
Tuesday, August 20th 2013
Lucy Page.scd
prm
*/

var texture, taiko;
texture = 0;
taiko = 1;


~page.lucy = ( );

~page.lucy.top = {
	~ohm.clearAll;
	~ohm.addEssential;

	// texture:
	~ohm.turnPurple(texture);
	MIDIdef.noteOn(\texture, {
		~lucy.texture.spawn;
		~scLang.sendMsg(\lucyControl, \textureTop, ~lucy.texture.state);
	}, texture);

	// taiko:
	~ohm.turnBlue(taiko);
	MIDIdef.noteOn(\taiko, {
		~lucy.taiko.spawn;
		~scLang.sendMsg(\lucyControl, \taikoTop, ~lucy.taiko.state);
	}, taiko);

	~restoreOhm.lucy.keysValuesDo({ | name, state |  ~scLang.sendMsg(\restoreOhmLucy, name, state); });

	~restoreOhm.lucy.page.do({ | color, note |
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