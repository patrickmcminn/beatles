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


loop


b = Array.fill(10, { | i |
	var baseFreq = 15000;
	Synth(\sine, [\freq, baseFreq/i, \amp, 0.1, \atk, 4, \rel, 4]);
})

b.do({ | i | i.set(\gate, 0)})


{
	var baseFreq = 15000;
	var i = 1;
	loop{
		Synth(\sine, [\freq, baseFreq/i, \amp, 0.05, \atk, 4, \rel, 4]);
		i = i + 1;wwwww
		0.1.wait;
	}
}.fork;

s.meter