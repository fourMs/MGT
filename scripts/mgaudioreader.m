% Todo: lots of things, this is just a start

[mg.audio.obj mg.audio.fs] = audioread(fn);

mg.video.fps = mg.video.nframe/(mg.video.endtime-mg.video.starttime);

[p,q] = rat(mg.video.fps/mg.audio.fs,0.0001);
a=mean(mg.audio.obj')'; % sum the two channels
ar=downsample(a,q);