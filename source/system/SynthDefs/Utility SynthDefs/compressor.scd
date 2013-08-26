/*
Sunday, August 25th 2013
compressor.scd
prm
*/

SynthDef(\compressor, {
	|
	in, out, amp = 1, makeup = 1,
	thresh = 0.5, ratio = 1, atk = 0.1, rel = 0.1
	|

	var input, comp, sig;

	input = In.ar(in);
	comp = Compander.ar(input, input, thresh, 1, 1/ratio, atk, rel);
	sig = comp * makeup;
	sig = comp * amp;
	sig = Out.ar(out, sig);
}).add;