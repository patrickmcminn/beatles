/*
Wednesday, September 4th 2013
sine.scd
prm
*/

SynthDef(\sine, {
	|
	out, amp = 0.2, freq = 220,
	gate = 1, atk = 0.05, dec = 0, susLvl = 1, rel = 0.05,
	pan = 0
	|
	var sine, env, sig;
	sine = SinOsc.ar(freq);
	env = EnvGen.kr(Env.adsr(atk, dec, susLvl, rel), gate, doneAction: 2);
	sig = sine * env;
	sig = sig * amp;
	sig = Pan2.ar(sig, pan);
	sig = Out.ar(out, sig);
}).add;