/*
Tuesday, August 20th 2013
variPhaserStereo.scd
prm
*/

SynthDef(\variPhaserStereo, {

	|
	in, out, amp = 1,
	delTime1 = 0.01, delTime2Lo = -0.0095, delTime2Hi = 0.0015,
	del2RateLo = 0.1, del2RateHi = 0.9, del2RateFreq = 4
	|

	var input, delay1, delay2Change, delay2, sum, sig;

	input = In.ar(in, 2);
	delay1 = DelayL.ar(input, 0.2, delTime1);
	delay2Change = LFNoise2.ar(LFNoise0.ar(del2RateFreq).range(del2RateLo, del2RateHi)).range(delTime2Lo, delTime2Hi);
	delay2 = DelayL.ar(input, 0.2, (delTime1 + delay2Change));
	delay2 = delay2 * -1;
	sum = Mix.ar([delay1 + delay2]);
	sig = sum * amp;
	sig = Out.ar(out, sig);
}).add;


	