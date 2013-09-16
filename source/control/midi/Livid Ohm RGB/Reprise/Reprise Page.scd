/*
Tuesday, August 27th 2013
Nothing Page.scd
prm
*/

var warmUp, laughTrack;
warmUp = 0;
laughTrack = 1;

~page.reprise = ( );

~page.reprise.top = {
	~ohm.clearAll;
	~ohm.addEssential;

  ~ohm.turnGreen(warmUp);
  MIDIdef.noteOn(\repriseWarmUp, {
    ~reprise.warmUp.spawn;
    ~scLang.sendMsg(\repriseControl, \warmUpTop, ~reprise.warmUp.state);
  }, warmUp);

  ~ohm.turnGreen(laughTrack);
  MIDIdef.noteOn(\repriseLaughTrack, {
    ~reprise.laughTrack.spawn;
    ~scLang.sendMsg(\repriseControl, \laughTrackTop, ~reprise.laughTrack.state);
  }, laughTrack);


	~restoreOhm.reprise.keysValuesDo({ | name, state |  ~scLang.sendMsg(\restoreOhmReprise, name, state); });

	~restoreOhm.reprise.page.do({ | color, note |
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