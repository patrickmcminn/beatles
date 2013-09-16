/*
Tuesday, August 27th 2013
Nothing Page.scd
prm
*/

var birdSong, brass;
birdSong = 0;
brass = 1;


~page.nothing = ( );

~page.nothing.top = {
	~ohm.clearAll;
	~ohm.addEssential;

  ~ohm.turnBlue(birdSong);
  MIDIdef.noteOn(\nothingBirds, {
    ~nothing.birdSong.spawn;
    ~scLang.sendMsg(\nothingControl, \birdSongTop, ~nothing.birdSong.state);
  }, birdSong);

  ~ohm.turnPurple(brass);
  MIDIdef.noteOn(\nothingBrass, {
    ~nothing.brass.spawn;
    ~scLang.sendMsg(\nothingControl, \brassTop, ~nothing.brass.state);
  }, brass);

	~restoreOhm.nothing.keysValuesDo({ | name, state |  ~scLang.sendMsg(\restoreOhmNothing, name, state); });

	~restoreOhm.nothing.page.do({ | color, note |
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