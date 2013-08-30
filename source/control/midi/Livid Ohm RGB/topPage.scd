/*
Thursday, September 20th 2012
topBranch.scd
prm
defines function for making the top layer of the tree
*/

var intro, billy, lucy, worse, where, stairs, henry, interlude, space, rita, nothing, reprise, boy, never;
intro = 0;
billy = 1;
lucy = 2;
worse = 3;
where = 4;
stairs = 5;
henry = 6;
interlude = 7;
space = 8;
rita = 9;
nothing = 10;
reprise = 11;
boy = 12;
never = 13;

~page[\top] = {
	~ohm.clearAll;
	~ohm.addEssential;

	// 1. Intro ( Audience Noise ):
	~ohm.turnRed(intro);
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
	~ohm.turnRed(stairs);
	MIDIdef.noteOn(\stairsPage, { ~page.stairs.top; }, stairs);

	// 7. Henry the Horse:
	~ohm.turnRed(henry);
	MIDIdef.noteOn(\henryPage, { ~page.henry.top; }, henry);

	// 8. interlude:
	~ohm.turnRed(interlude);
	MIDIdef.noteOn(\interludePage, { ~page.interlude.top; }, interlude);

	// 9. The Space Between Us All:
	~ohm.turnRed(space);
	MIDIdef.noteOn(\spacePage, { ~page.space.top; }, space);

	// 10. Rita:
	~ohm.turnWhite(rita);
	MIDIdef.noteOn(\ritaPage, { ~page.rita.top; }, rita);

	// 11. Nothing to Say:
	~ohm.turnRed(nothing);
	MIDIdef.noteOn(\nothingPage, { ~page.nothing.top; }, nothing);

	// 12. Reprise:
	~ohm.turnRed(reprise);
	MIDIdef.noteOn(\reprisePage, { ~page.reprise.top; }, reprise);

	// 13. Oh Boy:
	~ohm.turnRed(boy);
	MIDIdef.noteOn(\boyPage, { ~page.boy.top; }, boy);

	// 14. Never Could See Any Other Way:
	~ohm.turnRed(never);
	MIDIdef.noteOn(\neverPage, { ~page.never.top; }, never);
};
