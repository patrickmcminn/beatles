~billy.transport.spawn;
~billy.vibraphone.spawn;
~billy.vibraphone.state;
~billy.vibraphone.recordVibraphone
~billy.vibraphone.togglePattern;
~billy.vibraphone.playPattern
~billy.vibraphone.stopPattern
~billy.vibraphone.playState
~billy.vibraphone.toggleFakeBuffer
~billy.vibraphone.killFakeBuffer

~billy.vibraphone.buffer.play

~billy.vibraphone.patternFader.set(\amp, 0)
~billy.vibraphone.fader.set(\amp, 0)


~billy.vibraphone.toggleOrig
~billy.vibraphone.toggleC
~billy.vibraphone.toggleD
~billy.vibraphone.toggleE

~billy.vibraphone.granFader.set(\amp, 1)


Pbindef(\billyVibraphone).play
Pbindef(\billyVibraphone, \out, 0)

(
Pbindef(\tester,
	\instrument, \freezePlayerSus2,
	\buffer, ~billy.vibraphone.buffer,
	\dur, Pstutter(Pseq([12, 12, 24], inf), Pseq([1/6, ((1/6) * (8/9)), ((1/6) * (4/5))], inf)),
	\rateLo, Pstutter(Pseq([12, 12, 24], inf), Pseq([0.6, 0.675, 0.75], inf)),
	\rateHi, Pkey(\rateLo),
	\grainDurLo, 0.7,
	\grainDurHi, 0.7,
	\posLo, 0.1,
	\posHi, 0.8,
	\rel, 0.01,
	\atk, 0.01,
	\legato, 1,
	\amp, 0.7,
	\cutoff, Pwhite(2000, 5000, inf),
	\env, ~grainBufs.gabWide
).play;

Pbindef(\tester2,
	\instrument, \freezePlayerSus2,
	\buffer, ~billy.vibraphone.buffer,
	\dur, Pstutter(Pseq([12, 12, 24], inf), Pseq([1/6, ((1/6) * (8/9)), ((1/6) * (4/5))], inf)),
	\rateLo, Pstutter(Pseq([12, 12, 24], inf), Pseq([1.2, 1.35, 1.5], inf)),
	\rateHi, Pkey(\rateLo),
	\grainDurLo, 0.7,
	\grainDurHi, 0.7,
	\posLo, 0.1,
	\posHi, 0.8,
	\rel, 0.01,
	\atk, 0.01,
	\legato, 1,
	\amp, 0.7,
	\cutoff, Pwhite(2000, 5000, inf),
	\env, ~grainBufs.gabWide
).play;
)


Pbindef(\tester3,
	\instrument, \freezePlayerSus2,
	\buffer, ~billy.vibraphone.buffer,
	\dur, Pstutter(Pseq([12, 12, 24], inf), Pseq([1/3, ((1/3) * (8/9)), ((1/3) * (4/5))], inf)),
	\rateLo, Pstutter(Pseq([12, 12, 24], inf), Pseq([[1.2, 0.6], [1.35, 0.675], [1.5, 0.75]], inf)),
	\rateHi, Pkey(\rateLo),
	\grainDurLo, 0.7,
	\grainDurHi, 0.7,
	\posLo, 0.1,
	\posHi, 0.8,
	\rel, 0.01,
	\atk, 0.01,
	\legato, 1,
	\amp, 0.7,
	\cutoff, Pwhite(2000, 5000, inf),
	\env, ~grainBufs.gabWide
).play;

Pbindef(\tester3).stop

(
Pbindef(\tester).stop;
Pbindef(\tester2).stop;
)

s.meter


~billy.vibraphone.makePatterns

Pbindef.removeAll