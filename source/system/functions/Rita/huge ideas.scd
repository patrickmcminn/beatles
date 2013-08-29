a = Synth(\huge2, [\shiftArray, #[1.25, 0.75, 0.625, 0.5, 0.25, 1.25, 0.75], \in, b], addAction: \addToTail)
a.set(\grainAmp, 0, \amp, 0.3, \cutoffLo, 1000, \cutoffHi, 3000, \cutoffChangeRate, 12, \delayTime, 0, \subAmp, 0.6, \shiftAmp, 2)

(
b = Bus.audio;
{ Out.ar(b, SoundIn.ar(0)) }.play;
)

