/*
Friday, August 16th 2013
woodblock triggers.scd
prm
*/

{

	SynthDef(\blockTr1, {
		| in, id = 1, trigger = 0, trigRate = 3, thresh = 0.05, ampHi = 0.4 |
		var input, amplitude, onset, trigDelay, send;
		input = In.ar(in);
		onset = Coyote.kr(input, 0.2, 0.2, 0.001, 0.5, thresh, 0.1);
		amplitude = Amplitude.ar(input, 0.001, 0.05);
		amplitude = amplitude.linlin(0, 0.4, 0, 1);
		trigDelay = Delay2.kr(onset);
		send = SendReply.kr(trigDelay, '/block1', amplitude, id);
	}).add;

	SynthDef(\blockTr2, {
		| in, id = 1, trigger = 0, trigRate = 3, thresh = 0.05, ampHi = 0.4 |
		var input, amplitude, onset, trigDelay, send;
		input = In.ar(in);
		onset = Coyote.kr(input, 0.2, 0.2, 0.001, 0.5, thresh, 0.1);
		amplitude = Amplitude.ar(input, 0.001, 0.05);
		amplitude = amplitude.linlin(0, 0.4, 0, 1);
		trigDelay = Delay2.kr(onset);
		send = SendReply.kr(trigDelay, '/block2', amplitude, id);
	}).add;

	SynthDef(\blockTr3, {
		| in, id = 1, trigger = 0, trigRate = 3, thresh = 0.05, ampHi = 0.4 |
		var input, amplitude, onset, trigDelay, send;
		input = In.ar(in);
		onset = Coyote.kr(input, 0.2, 0.2, 0.001, 0.5, thresh, 0.1);
		amplitude = Amplitude.ar(input, 0.001, 0.05);
		amplitude =  amplitude.linlin(0, 0.4, 0, 1);
		trigDelay = Delay2.kr(onset);
		send = SendReply.kr(trigDelay, '/block3', amplitude, id);
	}).add;

	s.sync;

	~blockTrig = ( );
	~blockTrig.one = Synth(\blockTr1, [\in, ~inst.block1], ~group.input, \addToTail);
	~blockTrig.two = Synth(\blockTr2, [\in, ~inst.block2], ~group.input, \addToTail);
	~blockTrig.three = Synth(\blockTr3, [\in, ~inst.block3], ~group.input, \addToTail)



}.fork