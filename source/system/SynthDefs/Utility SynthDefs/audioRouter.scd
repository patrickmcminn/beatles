/*
Wednesday, September 4th 2013
audioRouter.scd
prm
*/

SynthDef(\audioRouter, {
	|
	in1, in2, in3, in4,
	out, amp = 1, inSel = 0,
	pan = 0
	|
	var input1, input2, input3, input4;
	var selectInput, sig;
	input1 = In.ar(in1, 2);
	input2 = In.ar(in2, 2);
	input3 = In.ar(in3, 2);
	input4 = In.ar(in4, 2);
	selectInput = SelectX.ar(inSel, [input1, input2, input3, input4]);
	sig = selectInput * amp;
	sig = Pan2.ar(sig, pan);
	sig = Out.ar(out, sig);
}).add;
	