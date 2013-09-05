/*
Wednesday, September 4th 2013
Never Page.scd
prm
*/


var fifteenK, tptAccomp, router, mainLoop, beatlesGran, rewind, chord;
fifteenK = 0;
tptAccomp = 1;
router = 64;
mainLoop = 4;
beatlesGran = 7;
rewind = 23;
chord = 47;

~page.never = ( );

~page.never.top = {
	~ohm.clearAll;
	~ohm.addEssential;

	//fifteenK:
	~ohm.turnWhite(fifteenK);
	MIDIdef.noteOn(\fifteenK, {
		~never.fifteenK.spawn;
		~scLang.sendMsg(\neverControl, \fifteenKTop, ~never.fifteenK.state);
	}, fifteenK);

	//tptAccomp:
	~ohm.turnBlue(tptAccomp);
	MIDIdef.noteOn(\tptAccomp, {
		~never.tptAccomp.spawn;
		~scLang.sendMsg(\neverControl, \tptAccompTop, ~never.tptAccomp.state);
	}, tptAccomp);

	//router:
	~ohm.turnGreen(router);
	MIDIdef.noteOn(\router, {
		~never.router.spawn;
		~scLang.sendMsg(\neverControl, \routerTop, ~never.router.state);
	}, router);

	//mainLoop:
	~ohm.turnYellow(mainLoop);
	MIDIdef.noteOn(\mainLoop, {
		~never.mainLoop.spawn;
		~scLang.sendMsg(\neverControl, \mainLoopTop, ~never.mainLoop.state);
	}, mainLoop);

	//beatlesGran:
	~ohm.turnPurple(beatlesGran);
	MIDIdef.noteOn(\beatlesGran, {
		~never.beatlesGran.spawn;
		~scLang.sendMsg(\neverControl, \beatlesGranTop, ~never.beatlesGran.state);
	}, beatlesGran);

	//rewind:
	~ohm.turnWhite(rewind);
	MIDIdef.noteOn(\rewind, {
		~never.rewind.spawn;
		~scLang.sendMsg(\neverControl, \rewindTop, ~never.rewind.state);
	}, rewind);

	~ohm.turnBlue(chord);
	MIDIdef.noteOn(\chord, {
		~never.chord.spawn;
		~scLang.sendMsg(\neverControl, \chordTop, ~never.chord.state);
	}, chord);

	~restoreOhm.never.keysValuesDo({ | name, state |  ~scLang.sendMsg(\restoreOhmNever, name, state); });

	~restoreOhm.never.page.do({ | color, note |
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