/*
Monday, August 26th 2013
multiShift.scd
prm
*/

SynthDef(\multiShift, {
	|
	in, out, amp = 1,
	shiftKind = 0, shiftRate = 5,
	shiftArray1 = #[0, 7, -5, 12],
	shiftArray2 = #[0, 7, -5, 12],
	shiftArray3 = #[0, 7, -5, 12],
	shiftArray4 = #[0, 7, -5, 12],
	cutoff = 3000, pan = 0
	|
	var input, trigger, shiftSel1, shiftSel2, shiftSel3, shiftSel4;
	var shift1, shift2, shift3, shift4;
	var sum, filter, sig;

	input = In.ar(in);


	trigger = Select.ar(shiftKind, [Impulse.ar(shiftRate), Dust.ar(shiftRate)]);
	shiftSel1 = Demand.ar(trigger, 0, Drand(shiftArray1, inf));
	shiftSel2 = Demand.ar(trigger, 0, Drand(shiftArray2, inf));
	shiftSel3 = Demand.ar(trigger, 0, Drand(shiftArray3, inf));
	shiftSel4 = Demand.ar(trigger, 0, Drand(shiftArray4, inf));

	shift1 = PitchShift.ar(input, 0.2, exp(0.057762265 * shiftSel1));
	shift1 = shift1/2;
	shift2 = PitchShift.ar(input, 0.2, exp(0.057762265 * shiftSel2));
	shift2 = shift2/2;
	shift3 = PitchShift.ar(input, 0.2, exp(0.057762265 * shiftSel3));
	shift3 = shift3/2;
	shift4 = PitchShift.ar(input, 0.2, exp(0.057762265 * shiftSel4));
	shift4 = shift4/2;
	sum = Mix.new([shift1, shift2, shift3, shift4]);

	filter = LPF.ar(sum, cutoff);

	sig = filter * amp;
	sig = Pan2.ar(sig, pan);
	sig = Out.ar(out, sig);
}).add;

		