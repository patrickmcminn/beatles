a = Synth(\hammond)


a = Synth(\hammondSus, [\amp, 0.2])

a.set(\dist, 4, \cutoff, 4000, \res, 0, \partial8Amp, 0.01, \partial6Amp, 0.01, \partial5Amp, 0.05, \partial4Amp, 0, \partial2Amp, 0, \bassAmp, 0.1, \subAmp, 0.125, \partial3Amp, 0.2)

Pbindef(\whereEnd,
	\instrument, \hammondSus,
	\subAmp, 0.7,
	\bassAmp, 0,
	\partial2Amp, 0.1,
	\partial3Amp, 0.01,
	\partial4Amp, 0,
	\partial5Amp, 0,
	\partial6Amp, 0.001,
	\partial8Amp, 0.005,
	\legato, 1,
	\dur, 6,
	\dist, 0.65,
	\root, 5,
	\octave, 3,
	\note, Pseq([[0, 15, 22, 31], [5, 15, 21, 31], [0, 15, 22, 31], [5, 12, 21, 31]], inf),
	\amp, Pseq([0.15, 0.13], inf),
	\cutoff, 1000
	);


Pbindef(\whereEnd).play
Pbindef(\whereEnd).stop


Pbindef(\whereEnd2,
	\instrument, \hammondSus,
	\group, a,
	\addAction, \addBefore,
	\out, b,
	\subAmp, 0.7,
	\bassAmp, 0,
	\partial2Amp, Pwhite(0.07, 1.2, inf),
	\partial3Amp, Pwhite(0.005, 0.015, inf),
	\partial4Amp, Pwhite(0, 0.0005, inf),
	\partial5Amp, Pwhite(0, 0.0005, inf),
	\partial6Amp, Pwhite(0, 0.003, inf),
	\partial8Amp, Pwhite(0.003, 0.007, inf),
	\atk, 0.1,
	\legato, 1,
	\dur, Pwhite(0.13, 0.21),
	\dist, 0.65,
	\root, 5,
	\octave, 3,
	\note, Pstutter(16, Pseq([[0, 15, 22, 29], [0, 17, 21, 29], [0, 15, 22, 29], [5, 12, 21, 29]], inf)),
	\amp, [0.09, 0.09, 0.09, 0.05],
	\cutoff, Pwhite(900, 1400, inf),
	\pan, Pwhite(-0.3, 0.3, inf)
	);

Pbindef(\whereEnd2, \octave, 4)
Pbindef(\whereEnd2, \amp, 0.06)

Pbindef(\whereEnd2).play
Pbindef(\whereEnd2).stop

b = Bus.audio;
d = Bus.audio;
a = Synth(\brokenAntenna, [\in, b, \out, 0])
c = Synth(\granulator, [\in, d, \out, 0, \grainDur, 0.1, \grainDurOffset, 0.05])
c.free;
a.set(\amp, 1)
a.free;

c.set(\grainDur, 0.3, \grainDurOffset, 0.15, \trigRate, 22)

c.set(\trigRate, 40)

a.set(\lowOutputGain, 0.3)
a.set(\lowInputGain, 0.6)
a.set(\hiOutputGain, 0)
a.set(\midOutputGain, 0.3)
a.autogui

c.set(\amp, 1, \mix, 1, \trigRate, 1, \grainDur, 0.05)
a.set(\mix, 0)

s.meter