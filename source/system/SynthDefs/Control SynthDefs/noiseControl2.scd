/*
Tuesday, August 20th 2013
noiseControl2.scd
prm
control-rate noise signal
*/


SynthDef(\noiseControl2, {	// control SynthDef using LFNoise2
	| out, freq = 1, rangeLo = 0, rangeHi = 1 |
	var sig;
	sig = LFNoise2.kr(freq).range(rangeLo, rangeHi);
	sig = ReplaceOut.kr(out, sig);
}).add;

"noiseControl0 Synth Added".postln;
"     args: out, freq = 1, rangeLo = 0, rangeHi = 1".postln;