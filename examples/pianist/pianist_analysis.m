% function mgdemo1
% This example shows how you can read Video, Mocap, Audio files into Matlab
% and visulize the data

% read video file into matlab
% load mg_structure.mat;
mg = mgread('pianist.avi','pianist.wav','pianist.tsv');
% extract a segment from 10 seconds to 30 seconds from the mg
mgseg = mgvideoreader(mg,'Extract',10,30);
% map the same segment to audio,mocap dataset
mgseg = mgmap(mgseg,'Both');

% alternatively, extract a segment by mgreadsegment without using mgmap.
% mgseg = mgreadsegment(mg,10,30);
%% if needed
% down sampling the video to half size in space. The sampled video was
% written back to disk.
% mgsam = mgvideosample(mgseg,[2,2],'samplevideo.avi');

%% if needed
% crop the region of interest in a video
% mgcrop = mgvideocrop(mg);
% mgcrop = mgvideocrop(mgsam);

%%
% compute the motion image, motiongrams, quantity of motion,centroid of
% motion
mgsegmo = mgmotion(mgseg,'Diff');
% mgseg_flow = mgmotion(mgseg,'OpticalFlow');
%%
% compute the periodicity of movement
[per,ac,eac,lag] = mgautocor(mgsegmo,'video',3);
figure,subplot(211),plot(lag,ac)
title('period')
xlabel('seconds')
ylabel('magnitude')
subplot(212),plot(lag,eac)
title('enhanced period')
xlabel('seconds')
ylabel('magnitude')
%%
% plot the motion image motiongrams over time. If 'Converted' is set to
% 'On' , then mgvideoplot will plot white-black motiongrams.
mgvideoplot(mgsegmo,'Converted','Off');
%
% mgvideoplot(mgsegmo,'Converted','On')
%%
% plot the whole motion grams
figure;
subplot(211)
gramx = medfilt2(mgsegmo.video.gram.x,[3,3]);
gramx = mgsegmo.video.gram.x>0.3;
gramx = mgsegmo.video.gram.x.*gramx;
%gramx = medfilt2(mgsegmo.video.gram.gramx,[3,3]);
%gramx = mgsegmo.video.gram.gramx>0.3;
%gramx = mgsegmo.video.gram.gramx.*gramx;

imagesc(gramx)
[~,n] = size(mgsegmo.video.gram.x);
%[~,n] = size(mgsegmo.video.gram.gramx);
set(gca,'XTick',[0:2*mgsegmo.video.obj.FrameRate:n]);
set(gca,'XTickLabel',[0:2*mgsegmo.video.obj.FrameRate:n]/mgsegmo.video.obj.FrameRate+mgsegmo.video.starttime);
title('horizontal gram');
subplot(212)
gramy = medfilt2(mgsegmo.video.gram.y,[3,3]);
gramy = mgsegmo.video.gram.y>0.4;
gramy = mgsegmo.video.gram.y.*gramy;
%gramy = medfilt2(mgsegmo.video.gram.gramy,[3,3]);
%gramy = mgsegmo.video.gram.gramy>0.4;
%gramy = mgsegmo.video.gram.gramy.*gramy;
imagesc(gramy);
set(gca,'YTick',[0:2*mgsegmo.video.obj.FrameRate:n]);
set(gca,'YTickLabel',[0:2*mgsegmo.video.obj.FrameRate:n]/mgsegmo.video.obj.FrameRate+mgsegmo.video.starttime);
ylabel('seconds');
title('vertical gram');

%%
% plot the waveform,rms,spectrum
mgwaveplot(mgsegmo);

% compute the spectrum of quantity of motion, spectrum of rms
%
mir = mirframe(mgsegmo.audio.mir,'Length',1/15)
rms = mirrms(mir);
envelop = mirenvelope(rms);
%
envelop_data = mirgetdata(envelop);
envelop_data = envelop_data/max(envelop_data);
%%
figure;
subplot(211)
fft_envelop_data = fft(envelop_data);
L = length(fft_envelop_data);
y = abs(fft_envelop_data/L);
y1 = y(1:L/2+1);
y1(2:end-1) = 2*y1(2:end-1);
fs = 30;
f = fs*(0:L/2)/L;
plot(f,y1)
set(gca,'XTick',[0:15])
xlabel('f(Hz)')
ylabel('magnitude')
title('spectrum of rms');
%
subplot(212)
fft_qom = fft(mgsegmo.video.qom);
L = length(fft_qom);
x = abs(fft_qom/L);
x1 = x(1:L/2+1);
x1(2:end-1) = 2*x1(2:end-1);
fs = 30;
f = fs*(0:L/2)/L;
plot(f,x1);
xlabel('f(Hz)')
ylabel('magnitude')
title('spectrum of qom')
%% statistics  first order descriptors
features1 = mgstatistics(mgsegmo,'Video','FirstOrder');
features1_norm = features1./repmat(max(features1),size(mgsegmo.video.gram.gramy,1),1);
plot(features1_norm(:,2),features1_norm(:,3),'.')

%% second order descriptors
features2 = mgstatistics(mgseg_motion,'Video','SecondOrder');
features2_norm = features2./repmat(max(features2),size(mgsegmo.video.gram.gramy,1),1);
plot(features2_norm(:,7),features2_norm(:,8),'.')
