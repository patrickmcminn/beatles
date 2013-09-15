/*
Sunday, September 15th 2013
Intro Page.scd
prm
*/

var texture;
texture = 0;


~page.intro = ( );

~page.intro.top = {
	~ohm.clearAll;
	~ohm.addEssential;

	// texture:
	~ohm.turnPurple(texture);
	MIDIdef.noteOn(\introTexture, {
		~intro.texture.spawn;
		~scLang.sendMsg(\introControl, \textureTop, ~intro.texture.state);
	}, texture);


	~restoreOhm.intro.keysValuesDo({ | name, state |  ~scLang.sendMsg(\restoreOhmIntro, name, state); });

	~restoreOhm.intro.page.do({ | color, note |
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