/*
Thursday, August 29th 2013
Where Page.scd
prm
*/

var pianoChords, endChords;
pianoChords = 0;
endChords = 5;


~page.where = ( );

~page.where.top = {
	~ohm.clearAll;
	~ohm.addEssential;

	// Piano Chords:
	~ohm.turnPurple(pianoChords);
	MIDIdef.noteOn(\pianoChords, {
		~where.pianoChords.spawn;
		~scLang.sendMsg(\whereControl, \pianoChordsTop, ~where.pianoChords.state;)
	}, pianoChords);

	// End Chords:
	~ohm.turnBlue(endChords);
	MIDIdef.noteOn(\endChords);
	MIDIdef.noteOn(\endChords, {
		~where.endChords.spawn;
		~scLang.sendMsg(\whereControl, \endChordsTop, ~where.endChords.state;)
	}, endChords);

	~restoreOhm.where.keysValuesDo({ | name, state |  ~scLang.sendMsg(\restoreOhmWhere, name, state); });

	~restoreOhm.where.page.do({ | color, note |
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