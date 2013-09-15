/*
Thursday, September 20th 2012
topBranch.scd
prm
defines function for making the top layer of the tree
*/

var intro, billy, lucy, worse, where, stairs, henry, space, rita, nothing, reprise, boy, never;
intro = 0;
billy = 1;
lucy = 2;
worse = 3;
where = 4;
stairs = 5;
henry = 6;
space = 7;
rita = 8;
nothing = 9;
reprise = 10;
boy = 11;
never = 12;

~page[\top] = {
	~ohm.clearAll;
	~ohm.addEssential;

	// 1. Intro ( Audience Noise ):
	~ohm.turnGreen(intro);
	MIDIdef.noteOn(\introPage, { ~page.intro.top; }, intro);

	// 2. Billy Shears:
	~ohm.turnPurple(billy);
	MIDIdef.noteOn(\billyPage, { ~page.billy.top; }, billy);

	// 3. Lucy:
	~ohm.turnBlue(lucy);
	MIDIdef.noteOn(\lucyPage, { ~page.lucy.top; }, lucy);

	// 4. No Worse:
	~ohm.turnWhite(worse);
	MIDIdef.noteOn(\worsePage, { ~page.worse.top; }, worse);

	// 5. Where it Will Go:
	~ohm.turnGreen(where);
	MIDIdef.noteOn(\wherePage, { ~page.where.top; }, where);

	// 6. Top of the Stairs:
	~ohm.turnBlue(stairs);
	MIDIdef.noteOn(\stairsPage, { ~page.stairs.top; }, stairs);

	// 7. Henry the Horse:
	~ohm.turnCyan(henry);
	MIDIdef.noteOn(\henryPage, { ~page.henry.top; }, henry);

	// 8. The Space Between Us All:
	~ohm.turnRed(space);
	MIDIdef.noteOn(\spacePage, { ~page.space.top; }, space);

	// 9. Rita:
	~ohm.turnBlue(rita);
	MIDIdef.noteOn(\ritaPage, { ~page.rita.top; }, rita);

	// 10. Nothing to Say:
	~ohm.turnRed(nothing);
	MIDIdef.noteOn(\nothingPage, { ~page.nothing.top; }, nothing);

	// 11. Reprise:
	~ohm.turnRed(reprise);
	MIDIdef.noteOn(\reprisePage, { ~page.reprise.top; }, reprise);

	// 12. Oh Boy:
	~ohm.turnPurple(boy);
	MIDIdef.noteOn(\boyPage, { ~page.boy.top; }, boy);

	// 13. Never Could See Any Other Way:
	~ohm.turnWhite(never);
	MIDIdef.noteOn(\neverPage, { ~page.never.top; }, never);
};
