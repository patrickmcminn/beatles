

~path1 = "/Users/patrickmcminn/Documents/Music/Current Work/Patrick McMinn/Great Noise Ensemble/Beatles Concert/Beatles Project/Where It Will Go/Audio Files/Chord 1.aif";
~path2 = "/Users/patrickmcminn/Documents/Music/Current Work/Patrick McMinn/Great Noise Ensemble/Beatles Concert/Beatles Project/Where It Will Go/Audio Files/Chord 2.aif";

a = Buffer.read(s, ~path1, 0, s.sampleRate * 1);
b = Buffer.read(s, ~path2, 0, s.sampleRate * 0.9);

a.play

q = Bus.audio;
t = Synth(\playBufStereoSus, [\buffer, a, \out, 0])
t.set(\gate, 0)
Synth(\playBuf, [\bufName, b, \sustain, 0.1, \out, 0])
f = Synth(\multiShift, [\in, q])

(
Synth(\playBuf, [\bufName, a, \sustain, 0.1, \out, 0]);
10.do({ Synth(\playBuf, [\bufName, a, \sustain, 0.05, \rate, 0.5 + 1.0.rand, \amp, 0.4]) })
)

(
Synth(\playBuf, [\bufName, b, \sustain, 0.1, \out, 0]);
10.do({ Synth(\playBuf, [\bufName, b, \sustain, 0.05, \rate, 1 + 1.0.rand, \amp, 0.4]) })
)





~ohm.clearAll
~ohm.addEssential

~ohm.turnBlue(0)
~ohm.turnCyan(1);
~ohm.turnPurple(9);
~ohm.turnYellow(8);


~ohm.turnWhite(2);
~ohm.turnGreen(10)

MIDIdef.noteOn(\chord1, { t = Synth(\playBufStereoSus, [\buffer, a, \out, 0]); }, 0);
MIDIdef.noteOff(\chord1Rel, { t.set(\gate, 0); }, 0);

MIDIdef.noteOn(\chord2, { u = Synth(\playBufStereoSus, [\buffer, b, \out, 0]); }, 8);
MIDIdef.noteOff(\chord2Rel, { u.set(\gate, 0); }, 8);


MIDIdef.noteOn(\chord3, { v = Synth(\playBufStereoSus, [\buffer, a, \out, 0, \rate, 8/9]); }, 1);
MIDIdef.noteOff(\chord3Rel, { v.set(\gate, 0); }, 1);

MIDIdef.noteOn(\chord4, { w = Synth(\playBufStereoSus, [\buffer, b, \out, 0, \rate, 2/3]); }, 9);
MIDIdef.noteOff(\chord4Rel, { w.set(\gate, 0); }, 9);


MIDIdef.noteOn(\chord5, { x = Synth(\playBufStereoSus, [\buffer, a, \out, 0, \rate, 6/5]); }, 2);
MIDIdef.noteOff(\chord5Rel, { x.set(\gate, 0); }, 2);

MIDIdef.noteOn(\chord6, { y = Synth(\playBufStereoSus, [\buffer, b, \out, 0, \rate, 9/8]); }, 10);
MIDIdef.noteOff(\chord6Rel, { y.set(\gate, 0); }, 10);