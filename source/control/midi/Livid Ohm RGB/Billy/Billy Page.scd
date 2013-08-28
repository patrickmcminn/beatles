/*
Wednesday, August 28th 2013
Billy Page.scd
prm
*/

var transport, vibraphone, trumpetChords, bassline;

transport = 0;
vibraphone = 1;
trumpetChords = 3;
bassline = 6;


~page.billy = ( );

~page.billy.top = {
	~ohm.clearAll;
	~ohm.addEssential;

	~ohm.turnGreen(transport);
	MIDIdef.noteOn(\billyTransport, {
		~billy.transport.spawn;
		~scLang.sendMsg(\billyControl, \transportTop, ~billy.transport.state);
	}, transport);

	~ohm.turnPurple(vibraphone);
	MIDIdef.noteOn(\billyVibraphone, {
		~billy.vibraphone.spawn;
		~scLang.sendMsg(\billyControl, \vibraphoneTop, ~billy.vibraphone.state);
	}, vibraphone);

	~ohm.turnBlue(trumpetChords);
	MIDIdef.noteOn(\billyTrumpetChords, {
		~billy.trumpetChords.spawn;
		~scLang.sendMsg(\billyControl, \trumpetChordsTop, ~billy.trumpetChords.state);
	}, trumpetChords);

	~ohm.turnYellow(bassline);
	MIDIdef.noteOn(\billyBassline, {
		~billy.bassline.spawn;
		~scLang.sendMsg(\billyControl, \basslineTop, ~billy.bassline.state);
	}, bassline);

	~restoreOhm.billy.keysValuesDo({ | name, state |  ~scLang.sendMsg(\restoreOhmBilly, name, state); });

	~restoreOhm.billy.page.do({ | color, note |
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