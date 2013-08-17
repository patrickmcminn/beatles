/*
Tuesday, October 9th 2012
instruments.scd
prm
defines external inputs to the system
*/

var amp = 1;

// define dictionary to store instrument busses:
~inst = ();

// define dictionary to store instruments:
~instI = ();

// input busses:
~inst[\trick] = Bus.audio;
~inst[\mute] = Bus.audio;
~inst[\mic] = Bus.audio;
~inst[\block1] = Bus.audio;
~inst[\block2] = Bus.audio;
~inst[\block3] = Bus.audio;
~inst[\extMic1] = Bus.audio;
~inst[\extMic2] = Bus.audio;
~inst[\extMic3] = Bus.audio;


// instrument inputs:
~instI[\mute] = Synth(\instIn, [\in, 0, \out, ~inst[\mute], \amp, amp], ~group[\input], \addToTail);
~instI[\mic] = Synth(\instIn, [\in, 1, \out, ~inst[\mic], \amp, amp], ~group[\input], \addToTail);

~instI[\block1] = Synth(\instIn, [\in, 2, \out, ~inst[\block1], \amp, amp], ~group[\input], \addToTail);
~instI[\block2] = Synth(\instIn, [\in, 3, \out, ~inst[\block2], \amp, amp], ~group[\input], \addToTail);
~instI[\block3] = Synth(\instIn, [\in, 4, \out, ~inst[\block3], \amp, amp], ~group[\input], \addToTail);

~instI[\extMic1] = Synth(\instIn, [\in, 5, \out, ~inst[\extMic1], \amp, amp], ~group[\input], \addToTail);
~instI[\extMic1] = Synth(\instIn, [\in, 6, \out, ~inst[\extMic2], \amp, amp], ~group[\input], \addToTail);
~instI[\extMic1] = Synth(\instIn, [\in, 7, \out, ~inst[\extMic3], \amp, amp], ~group[\input], \addToTail);
