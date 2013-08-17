/*
Friday, August 16th 2013
beatlesOhm.scd
prm
*/

~ohm.addUniqueMethod(\addEssential, {

	// Ohm Button to go to Top Page
	~ohm.turnGreen(71);
	MIDIdef.noteOn(\topPage, { ~scLang.sendMsg(\page, \top) }, 71);

	// Master Volume Control (Far Right Slider)
	MIDIdef.cc(\masterVolume, { | val |
		var amp;
		amp = val.linlin(0, 127, 0, 1);
		~scLang.sendMsg(\mixer, \master, amp)
	}, 4);

	// Submix 1
	MIDIdef.cc(\s1, { | val |
		var amp;
		amp = val.linlin(0, 127, 0, 0.7);
		~scLang.sendMsg(\mixer, \s1, amp);
	}, 5);

	// Submix 2
	MIDIdef.cc(\s2, { | val |
		var amp;
		amp = val.linlin(0, 127, 0, 0.7);
		~scLang.sendMsg(\mixer, \s2, amp);
	}, 7);

	// Submix 3
	MIDIdef.cc(\s3, { | val |
		var amp;
		amp = val.linlin(0, 127, 0, 0.7);
		~scLang.sendMsg(\mixer, \s3, amp);
	}, 6);

	~restoreOhm.structure.page.do({ | color, note |
		case
		{ color == \off } { ~ohm.turnOff(note); }
		{ color == \lavender } { ~ohm.turnLavender(note); }
		{ color == \blue } { ~ohm.turnBlue(note); }
		{ color == \pink } { ~ohm.turnPink(note) ; }
		{ color == \red } { ~ohm.turnRed(note); }
		{ color == \purple } { ~ohm.turnPurple(note); }
		{ color == \green } { ~ohm.turnGreen(note); }
		{ color == \yellow } { ~ohm.turnYellow(note); }
	});

	~restoreOhm.structure.keysValuesDo({ | name, state |  ~scLang.sendMsg(\restoreOhm, name, state); });
	~structureOhmMidi.changer.init;
});


// creates dictionary to hold restore data

~restoreOhm = ( );
