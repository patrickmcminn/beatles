~billy.trumpetChords.spawn;
~billy.transport.spawn

~billy.trumpetChords.recordTpt(0);
~billy.trumpetChords.recordTpt(1);
~billy.trumpetChords.recordTpt(2);
~billy.trumpetChords.recordTpt(3);
~billy.trumpetChords.recordTpt(4);
~billy.trumpetChords.recordTpt(5);

(
~billy.vibraphone.togglePattern;
~billy.trumpetChords.togglePattern;
)
~billy.trumpetChords.playState


~billy.trumpetChords.buffer[0].play

~billy.trumpetChords.makePatterns

Pbindef(\billyChords, \amp, 0.15)


~billy.vibraphone.toggleOrig
~billy.vibraphone.toggleC
~billy.vibraphone.toggleD
~billy.vibraphone.toggleE


~billy.vibraphone.granFader.set(\amp, -21.dbamp)