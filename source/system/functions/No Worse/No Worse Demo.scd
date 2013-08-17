/*
Thursday, August 15th 2013
No Worse.scd
prm
demoing ideas for "Getting Better" Interlude
*/


// SynthDefs:

(
SynthDef(\playBufStereo, {
	| bufName, out, rate = 1, loop = 0, startPos = 0, amp = 1,
	attack = 0.05, sustain = 1, release = 0.05, pan = 0 |
	var play, sig, env;
	play = PlayBuf.ar(1, bufName, rate, 1, startPos, loop);
	env = EnvGen.kr(Env.linen(attack, sustain, release), 1, doneAction: 2);
	sig =  env * play;
	sig = Pan2.ar(sig, pan);
	sig = sig * amp;
	sig = Out.ar(out, sig);
}).add;


SynthDef(\freezePlayerSus2, {
	|
	out, buffer, pan = 0, trigRate = 90, grainDurLo = 0.65, grainDurHi = 0.9, posLo = 0, posHi = 1, rateLo = 1, rateHi = 1,
	atk = 0.01, dec = 0, sus = 1, rel = 6.0, gate = 1, amp = 1, cutoff = 1000,
	tremRate = 0, tremDepth = 0
	|
	var grainTrig, position, duration, rater, granulation, trem, env, filter, sig;
	grainTrig = Dust.ar(trigRate);
	position = TRand.ar(posLo, posHi, grainTrig);
	duration = TRand.ar(grainDurLo, grainDurHi, grainTrig);
	rater = TRand.ar(rateLo, rateHi, grainTrig);
	granulation = GrainBuf.ar(2, trigger: grainTrig, dur: duration,
		sndbuf: buffer, rate: rater, pos: position, pan: pan, maxGrains: 2048);
	trem = SinOsc.ar(tremRate).range((1-tremDepth), 1);
	filter = LPF.ar(granulation, cutoff);
	env = EnvGen.ar(Env.adsr(atk, dec, sus, rel), gate, doneAction: 2);
	sig = filter * env;
	sig = sig * trem;
	sig = sig * amp;
	sig = Out.ar(out, sig);
}).add;
)


(
~path = "/Users/patrickmcminn/Documents/Music/Current Work/Patrick McMinn/Great Noise Ensemble/Beatles Concert/Beatles/data/No Worse/";

// main buffers:
~g5 = Buffer.read(s, ~path ++ "G5.aif");
~g6 = Buffer.read(s, ~path ++ "G6.aif");
~c6 = Buffer.read(s, ~path ++ "C6.aif");
~e6 = Buffer.read(s, ~path ++ "E6.aif");

~allStrings = Buffer.readChannel(s, ~path ++ "allStrings.aif", 0, -1, 1);
~tanpura = Buffer.read(s, ~path ++ "tanpura.aif");

~brokenBuf = [
	Buffer.read(s, ~path ++ "Broken1.aif"),
	Buffer.read(s, ~path ++ "Broken2.aif"),
	Buffer.read(s, ~path ++ "Broken3.aif"),
	Buffer.read(s, ~path ++ "Broken4.aif"),
	Buffer.read(s, ~path ++ "Broken5.aif"),
	Buffer.read(s, ~path ++ "Broken6.aif"),

	Buffer.read(s, ~path ++ "Broken9.aif")
];


/*
~stringC5 = Buffer.read(s, ~path ++ "String C5.aif");
~stringD5 = Buffer.read(s, ~path ++ "String D5.aif");
~stringDSharp5 = Buffer.read(s, ~path ++ "String D#5.aif");
~stringE5 = Buffer.read(s, ~path ++ "String E5.aif");
~stringF5 = Buffer.read(s, ~path ++ "String F5.aif");
~stringFSharp5 = Buffer.read(s, ~path ++ "String F#5.aif");
~stringG5 = Buffer.read(s, ~path ++ "String G5.aif");
~stringGSharp5 = Buffer.read(s, ~path ++ "String G#5.aif");
~stringA5 = Buffer.read(s, ~path ++ "String A5.aif");
~stringASharp5 = Buffer.read(s, ~path ++ "String A#5.aif");
~stringB5 = Buffer.read(s, ~path ++ "String B5.aif");
*/
);


(
~tempo = TempoClock.new;
~tempo.tempo = 110/60;


~tempoRoutine = r {
	loop {
		~tempo.tempo = [exprand(60/60, 440/60).postln, (110/60).postln].choose;
		5.0.rand.wait;
	}
};

);


(
Pbindef(\g5,
	\instrument, \playBufStereo,
	\bufName, ~g5,
	\sustain, 2,
	\dur, Pseq([0.5, 0.5, 0.5, 0.5, 1/3, 1/3, 1/3, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1/3, 1/3, 1/3], inf),
	\note, Pseq([1, \r, 1, \r, 1, \r, 1, 1, \r, 1, \r, 1, \r, 1, \r, 1], inf),
	\amp, Pwhite(0.9, 1.4),
	\rate, Pwhite(0.99, 1.01),
	\attack, Pwhite(0.05, 0.5),
	\pan, Pwhite(-1, 1)
);
Pbindef(\g6,
	\instrument, \playBufStereo,
	\bufName, ~g6,
	\sustain, 2,
	\dur, Pseq([0.5, 0.5, 0.5, 0.5, 1/3, 1/3, 1/3, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1/3, 1/3, 1/3], inf),
	\note, Pseq([1, \r, 1, \r, 1, \r, 1, 1, \r, 1, \r, 1, \r, 1, \r, 1], inf),
	\amp, Pwhite(0.9, 1.4),
	\rate, Pwhite(0.99, 1.01),
	\attack, Pwhite(0.05, 0.5),
	\pan, Pwhite(-1, 1)
);
Pbindef(\e6,
	\instrument, \playBufStereo,
	\bufName, ~e6,
	\sustain, 2,
	\dur, Pseq([0.5, 0.5, 0.5, 0.5, 1/3, 1/3, 1/3, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1/3, 1/3, 1/3], inf),
	\note, Pseq([1, \r, 1, \r, 1, \r, 1, 1, \r, 1, \r, 1, \r, 1, \r, 1], inf),
	\amp, Pwhite(0.9, 1.6),
	\rate, Pwhite(0.99, 1.01),
	\attack, Pwhite(0.05, 0.5),
	\pan, Pwhite(-1, 1)
);
Pbindef(\c6,
	\instrument, \playBufStereo,
	\bufName, ~c6,
	\sustain, 2,
	\dur, Pseq([0.5, 0.5, 0.5, 0.5, 1/3, 1/3, 1/3, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1/3, 1/3, 1/3], inf),
	\note, Pseq([1, \r, 1, \r, 1, \r, 1, 1, \r, 1, \r, 1, \r, 1, \r, 1], inf),
	\amp, Pwhite(0.9, 1.6),
	\rate, Pwhite(0.99, 1.01),
	\attack, Pwhite(0.05, 0.5),
	\pan, Pwhite(-1, 1)

);
);


(
Pbindef(\g5).play(~tempo);
Pbindef(\g6).play(~tempo);
Pbindef(\e6).play(~tempo);
Pbindef(\c6).play(~tempo);
);

(
~strings = Synth(\freezePlayerSus2, [\buffer, ~allStrings, \amp, 0.1, \trigRate, 25, \grainDurLo, 0.0001, \grainDurHi, 0.3,
	\rateLo, 0.95, \rateHi, 1.05, \cutoff, 2500])
)

~drone = Synth(\freezePlayerSus2, [\buffer, ~tanpura, \amp, 0.005, \posLo, 0.1, \posHi, 0.3, \rel, 15]);

s.meter


(
Pbindef(\g5).stop;
Pbindef(\g6).stop;
Pbindef(\e6).stop;
Pbindef(\c6).stop;
);

~strings.set(\gate, 0)
~drone.set(\gate, 0)


OSCdef(\blockBroken1, { | msg |
	var amp = msg.at(3);
	Synth(\playBufStereo, [\bufName, [~brokenBuf[0], ~brokenBuf[0], ~brokenBuf[0], ~brokenBuf[1], ~brokenBuf[2]].choose,
		\amp, amp * 1.5], ~group.fx, \addToTail);

}, \block1);

OSCdef(\blockBroken2, { | msg |
	var amp = msg.at(3);
	Synth(\playBufStereo, [\bufName, ~brokenBuf[6], \amp, amp* 2.2], ~group.fx, \addToTail);
}, \block2);

OSCdef(\blockBroken3, { | msg |
	var amp = msg.at(3);
	Synth(\playBufStereo, [\bufName, ~brokenBuf[7], \amp, amp* 2.2], ~group.fx, \addToTail);
}, \block3);






// older ideas:

(
Pbindef(\stringC,
	\instrument, \playBufStereo,
	\bufName, ~stringC5,
	\amp, Pwhite(0.05, 0.1),
	\rate, Pwhite(0.5, 1.5),
	\startPos, Pwhite(0, 0.3),
	\attack, Pwhite(0.05, 0.1),
	\pan, Pwhite(-1, 1),
	\note, Prand([1, \r, \r, \r, 1], inf),
	\dur, Pwhite(0.05, 0.1)
);
Pbindef(\stringD,
	\instrument, \playBufStereo,
	\bufName, ~stringD5,
	\amp, Pwhite(0.05, 0.1),
	\rate, Pwhite(0.5, 1.5),
	\startPos, Pwhite(0, 0.3),
	\attack, Pwhite(0.05, 0.1),
	\pan, Pwhite(-1, 1),
	\note, Prand([1, \r, \r, \r], inf),
	\dur, Pwhite(0.05, 0.1)
);
Pbindef(\stringDSharp,
	\instrument, \playBufStereo,
	\bufName, ~stringDSharp5,
	\amp, Pwhite(0.05, 0.1),
	\rate, Pwhite(0.5, 1.5),
	\startPos, Pwhite(0, 0.3),
	\attack, Pwhite(0.05, 0.1),
	\pan, Pwhite(-1, 1),
	\note, Prand([1, \r, \r, \r], inf),
	\dur, Pwhite(0.05, 0.1)
);
Pbindef(\stringE,
	\instrument, \playBufStereo,
	\bufName, ~stringE5,
	\amp, Pwhite(0.05, 0.1),
	\rate, Pwhite(0.5, 1.5),
	\startPos, Pwhite(0, 0.3),
	\attack, Pwhite(0.05, 0.1),
	\pan, Pwhite(-1, 1),
	\note, Prand([1, \r, \r, \r], inf),
	\dur, Pwhite(0.05, 0.1)
);
Pbindef(\stringF,
	\instrument, \playBufStereo,
	\bufName, ~stringF5,
	\amp, Pwhite(0.05, 0.1),
	\rate, Pwhite(0.5, 1.5),
	\startPos, Pwhite(0, 0.3),
	\attack, Pwhite(0.05, 0.1),
	\pan, Pwhite(-1, 1),
	\note, Prand([1, \r, \r, \r], inf),
	\dur, Pwhite(0.05, 0.1)
);
Pbindef(\stringFsharp,
	\instrument, \playBufStereo,
	\bufName, ~stringFSharp5,
	\amp, Pwhite(0.05, 0.1),
	\rate, Pwhite(0.5, 1.5),
	\startPos, Pwhite(0, 0.3),
	\attack, Pwhite(0.05, 0.1),
	\pan, Pwhite(-1, 1),
	\note, Prand([1, \r, \r, \r], inf),
	\dur, Pwhite(0.05, 0.1)
);
Pbindef(\stringG,
	\instrument, \playBufStereo,
	\bufName, ~stringG5,
	\amp, Pwhite(0.05, 0.1),
	\rate, Pwhite(0.5, 1.5),
	\startPos, Pwhite(0, 0.3),
	\attack, Pwhite(0.05, 0.1),
	\pan, Pwhite(-1, 1),
	\note, Prand([1, \r, \r, \r], inf),
	\dur, Pwhite(0.05, 0.1)
);
Pbindef(\stringGSharp,
	\instrument, \playBufStereo,
	\bufName, ~stringGSharp5,
	\amp, Pwhite(0.05, 0.1),
	\rate, Pwhite(0.5, 1.5),
	\startPos, Pwhite(0, 0.3),
	\attack, Pwhite(0.05, 0.1),
	\pan, Pwhite(-1, 1),
	\note, Prand([1, \r, \r, \r], inf),
	\dur, Pwhite(0.05, 0.1)
);
Pbindef(\stringA,
	\instrument, \playBufStereo,
	\bufName, ~stringA5,
	\amp, Pwhite(0.05, 0.1),
	\rate, Pwhite(0.5, 1.5),
	\startPos, Pwhite(0, 0.3),
	\attack, Pwhite(0.05, 0.1),
	\pan, Pwhite(-1, 1),
	\note, Prand([1, \r, \r, \r], inf),
	\dur, Pwhite(0.05, 0.1)
);
Pbindef(\stringASharp,
	\instrument, \playBufStereo,
	\bufName, ~stringASharp5,
	\amp, Pwhite(0.05, 0.1),
	\rate, Pwhite(0.5, 1.5),
	\startPos, Pwhite(0, 0.3),
	\attack, Pwhite(0.05, 0.1),
	\pan, Pwhite(-1, 1),
	\note, Prand([1, \r, \r, \r], inf),
	\dur, Pwhite(0.05, 0.1)
);
Pbindef(\stringB,
	\instrument, \playBufStereo,
	\bufName, ~stringB5,
	\amp, Pwhite(0.05, 0.1),
	\rate, Pwhite(0.5, 1.5),
	\startPos, Pwhite(0, 0.3),
	\attack, Pwhite(0.05, 0.1),
	\pan, Pwhite(-1, 1),
	\note, Prand([1, \r, \r, \r], inf),
	\dur, Pwhite(0.05, 0.1),
);

(
Pbindef(\stringC).play;
Pbindef(\stringD).play;
Pbindef(\stringDSharp).play;
Pbindef(\stringE).play;
Pbindef(\stringF).play;
Pbindef(\stringFSharp).play;
Pbindef(\stringG).play;
Pbindef(\stringGSharp).play;
Pbindef(\stringA).play;
Pbindef(\stringASharp).play;
Pbindef(\stringBSharp).play;
);


(
Pbindef(\stringC).stop;
Pbindef(\stringD).stop;
Pbindef(\stringDSharp).stop;
Pbindef(\stringE).stop;
Pbindef(\stringF).stop;
Pbindef(\stringFSharp).stop;
Pbindef(\stringG).stop;
Pbindef(\stringGSharp).stop;
Pbindef(\stringA).stop;
Pbindef(\stringASharp).stop;
Pbindef(\stringBSharp).stop;
);

s.meter