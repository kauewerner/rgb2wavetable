(
s.waitForBoot{
Buffer.freeAll;
~bufSize = 2048;
~bufR = Buffer.alloc(s,2048);
~bufG = Buffer.alloc(s,2048);
~bufB = Buffer.alloc(s,2048);
SynthDef.new(\wtoscRGB,{
	arg bufR, bufG, bufB, freq = 100, ampR, ampG, ampB, pan = 0, at = 0.001, re = 1, mix = 0.0, mainAmp = 0.5;
	var sig, env;
	env = EnvGen.kr(Env.perc(at,re),doneAction:2);
	sig = Osc.ar(bufR,0.5*freq,mul:ampR) + Osc.ar(bufG,freq,mul:ampG) + Osc.ar(bufB,2*freq,mul:ampB);
	sig = FreeVerb.ar(sig,mix);
	sig = Pan2.ar(sig,pan);
	Out.ar(0,LeakDC.ar(sig * mainAmp * env));
}).add;
OSCdef(\getXR,{
	arg msg, wt;
	msg = (msg[1..1024]).linlin(0,255,-0.5,0.5);
	wt = Env(msg,(1.0/1024)!(msg.size - 1)).asSignal(1024).asWavetable;
	~bufR.sendCollection(wt);
},"/xRed");
OSCdef(\getXG,{
	arg msg, wt;
	msg = (msg[1..1024]).linlin(0,255,-0.5,0.5);
	wt = Env(msg,(1.0/1024)!(msg.size - 1)).asSignal(1024).asWavetable;
	~bufG.sendCollection(wt);
},"/xGreen");
OSCdef(\getXB,{
	arg msg, wt;
	msg = (msg[1..1024]).linlin(0,255,-0.5,0.5);
	wt = Env(msg,(1.0/1024)!(msg.size - 1)).asSignal(1024).asWavetable;
	~bufB.sendCollection(wt);
},"/xBlue");
Pbindef(\pWT,\instrument,\wtoscRGB);
Pbindef(\pWT,\bufR,~bufR);
Pbindef(\pWT,\bufG,~bufG);
Pbindef(\pWT,\bufB,~bufB);
Pbindef(\pWT,\dur,1.5);
Pbindef(\pWT,\at,1.005);
Pbindef(\pWT,\re,Pexprand(0.5,3.5,inf));
Pbindef(\pWT,\mix,0.0);
Pbindef(\pWT,\ampR,0.125);
Pbindef(\pWT,\ampG,0.125);
Pbindef(\pWT,\ampB,0.125);
Pbindef(\pWT,\mainAmp,0.25);
Pbindef(\pWT,\freq,Pexprand(20,200,inf));
Pbindef(\pWT).play;
}
)
Pbindef(\pWT).stop;
