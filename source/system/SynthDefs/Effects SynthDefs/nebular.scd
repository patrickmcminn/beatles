/*
Tuesday, September 17th 2013
nebular.scd
prm
*/

SynthDef(\nebular, {
  |
  in, out, amp = 1,
  loFreq = 250, loGain = -2, hiFreq = 2500, hiGain = -6,
  verbMix = 0.75, room = 0.7, damp = 0.1,
  dist = 150, distScale = 0.5, cutoff = 5000, activity = 100, depth = 100,
  delTime = 0.915, decay = 9, centerFreq = 1000, bw = 6, delMix = 0.36
  |

  var input, lowShelf, hiShelf, reverb, distortion, filter;
  var range, offset, rate, trigger, nebulaLeft, nebulaRight, left, right;
  var sig;

  //input = In.ar(in);
  input = SoundIn.ar(0);
  lowShelf = BLowShelf.ar(input, loFreq, 1, loGain);
  hiShelf = BHiShelf.ar(lowShelf, hiFreq, 1, hiGain);
  reverb = FreeVerb.ar(hiShelf, verbMix, room, damp);
  distortion = (reverb * dist).distort;
  distortion = distortion * distScale;
  filter = LPF.ar(distortion, cutoff);

  range = depth * 0.01;
  offset = 0.945 - range + (range/5);
  rate = ((activity/100) -1*(-500)+11)/1000;
	trigger = Impulse.kr(1/rate);
  nebulaLeft = Mix.fill(4, {
		(TRand.kr(0, range, trigger) + offset).linexp(0, 1.2, 0.0001, 1.2)
	});
	nebulaLeft = nebulaLeft/4;
	nebulaRight = Mix.fill(4, {
		(TRand.kr(0, range, trigger) + offset).linexp(0, 1.2, 0.0001, 1.2)
	});
	nebulaRight = nebulaRight/4;

	left = filter * Lag2.kr(nebulaLeft, 0.7);
	right = filter * Lag2.kr(nebulaRight, 0.7);

  sig = [left, right];
  sig = sig * amp;
  sig = Out.ar(out, sig);
}).add;
