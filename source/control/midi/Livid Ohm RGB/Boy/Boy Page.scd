/*
Friday, August 30th 2013
Boy Page.scd
prm
*/

var noiseBed, numbers;
noiseBed = 0;
numbers = 1;

~page.boy = ( );

~page.boy.top = {
	~ohm.clearAll;
	~ohm.addEssential;

	~ohm.turnWhite(noiseBed);
	MIDIdef.noteOn(\boyNoiseBed, {
		~boy.noiseBed.spawn;
		~scLang.sendMsg(\boyControl, \noiseBedTop, ~boy.noiseBed.state);
	}, noiseBed);


	~ohm.turnBlue(numbers);
	MIDIdef.noteOn(\boyNumbers, {
		~boy.numbers.spawn;
		~scLang.sendMsg(\boyControl, \numbersTop, ~boy.numbers.state);
	}, numbers);


	~restoreOhm.boy.keysValuesDo({ | name, state |  ~scLang.sendMsg(\restoreOhmBoy, name, state); });

	~restoreOhm.boy.page.do({ | color, note |
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