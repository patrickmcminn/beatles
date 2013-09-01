/*
Monday October 8th 2012
lfSin.scd
prm
control-rate sine oscillator
*/

SynthDef(\lfSaw, {	// low-frequency control Saw Oscillator
	| out, freq = 1, rangeLo = 0, rangeHi = 1 |
	var sig;
	sig = LFSaw.kr(freq).range(rangeLo, rangeHi);
	sig = ReplaceOut.kr(out, sig);
}).add;

"lfSaw SynthDef added".postln;
"     args: out, freq = 1, rangeLo = 0, rangeHi = 1".postln;