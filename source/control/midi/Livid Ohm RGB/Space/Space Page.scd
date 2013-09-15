/*
Tuesday, August 27th 2013
Henry Page.scd
prm
*/

var tanpura, drone;
tanpura = 0;
drone = 1;


~page.space = ( );

~page.space.top = {
	~ohm.clearAll;
	~ohm.addEssential;

  ~ohm.turnBlue(tanpura);
  MIDIdef.noteOn(\spaceTanpura, {
    ~space.tanpura.spawn;
    ~scLang.sendMsg(\spaceControl, \tanpuraTop, ~space.tanpura.state);
  }, tanpura);

  ~ohm.turnYellow(drone);
  MIDIdef.noteOn(\spaceDrone, {
    ~space.drone.spawn;
    ~scLang.sendMsg(\spaceControl, \droneTop, ~space.drone.state);
  }, drone);

	~restoreOhm.space.keysValuesDo({ | name, state |  ~scLang.sendMsg(\restoreOhmSpace, name, state); });

	~restoreOhm.space.page.do({ | color, note |
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