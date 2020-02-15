%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Examples of how to analyse a dance video
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%
% Motion videos
%%%%%%%%%%%%%%%

% Perform basic motion analysis
mgmotion('dance.avi');

% Using a binary filter and higher thresholding
mgmotion('dance.avi','Binary',0.3);

% Using a regular filter
mgmotion('dance.avi','Regular',0.1);

% Can also be done with invert output
mgmotion('dance.avi','Regular',0.1,'invert');

% Can also be done in color
mgmotion('dance.avi','Regular',0.1,'color');


%%%%%%%%%%%%%%%%%%%%%%
% Motion history video
%%%%%%%%%%%%%%%%%%%%%%

% Make a history video
mgmotionhistory('dance.avi');

% Make a history video in color
mgmotionhistory('dance.avi',40);

% Make a history video in color
mgmotionhistory('dance.avi',40,'color');

% Make a motion history video (from the motion video)
mgmotionhistory('dance_motion.avi',40,'color');


%%%%%%%%%%%%%%%%%%%%%%
% Motion average image
%%%%%%%%%%%%%%%%%%%%%%

% Make an average image
mgmotionaverage('dance.avi');

% Make an average image in color
mgmotionaverage('dance.avi','color');

% Make an average motion image
mgmotionaverage('dance_motion.avi','color');


% Make a average video
mgmotionaverage('dance_motion.avi');


%%%%%%%%%%%%%%%%%%%%%%
% Pre-processing
%%%%%%%%%%%%%%%%%%%%%%

% extract a temporal segment from the video
mgseg= mgvideoreader(mg,'Extract',5,25);

% resample the video frames,reduce the size of each frame.
mgsam = mgvideosample(mgseg,[4,4],'dancesamplevideo.avi');

% crop the interest of region of the video frame
% click and drag in video to select crop area, then double-click to crop
mgcrop = mgvideocrop(mgsam)

mgsammo = mgmotion(mgsam,'Diff');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% More advanced functionality
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%
subplot(211)
plot(mgsammo.video.qom,'-b')
set(gca,'XTick',[0:4*mgsammo.video.obj.FrameRate:mgsammo.video.nframe])
set(gca,'XTickLabel',[mgsammo.video.starttime:4:mgsammo.video.endtime])
xlabel('Time(s)')
ylabel('magnitude')
title('quantity of motion')
subplot(212)
plot(mgsammo.video.com(:,1),mgsammo.video.com(:,2),'.')
xlabel('x coordinate')
ylabel('y coordinate')
title('centroid of motion')
%%
[per,ac,eac,lag] = mgautocor(mgsammo,'Video',1);
figure,subplot(211),plot(lag,ac)
title('period')
xlabel('seconds')
ylabel('magnitude')
subplot(212),plot(lag,eac)
title('enhanced period')
xlabel('seconds')
ylabel('magnitude')

%%
gramx = medfilt2(mgsammo.video.gram.x,[3,3]);
gramx = mgsammo.video.gram.x>0.3;
gramx = mgsammo.video.gram.x.*gramx;
%gramx = medfilt2(mgsammo.video.gram.gramx,[3,3]);
%gramx = mgsammo.video.gram.gramx>0.3;
%gramx = mgsammo.video.gram.gramx.*gramx;
figure;
subplot(211)
imagesc(gramx)
fr = mgsammo.video.obj.FrameRate;
[~,n] = size(mgsammo.video.gram.x);
%[~,n] = size(mgsammo.video.gram.gramx);
set(gca,'XTick',[0:2*fr:mgsammo.video.nframe]);
set(gca,'XTickLabel',[fr*...
    mgsammo.video.starttime:...
    2*fr:...
    mgsammo.video.endtime*fr]...
    /fr);
title('horizontal gram');
gramy = medfilt2(mgsammo.video.gram.y,[3,3]);
gramy = mgsammo.video.gram.y>0.4;
gramy = mgsammo.video.gram.y.*gramy;
%gramy = medfilt2(mgsammo.video.gram.gramy,[3,3]);
%gramy = mgsammo.video.gram.gramy>0.4;
%gramy = mgsammo.video.gram.gramy.*gramy;
subplot(212)
imagesc(gramy);
set(gca,'YTick',[0:2*fr:mgsammo.video.nframe]);
set(gca,'YTickLabel',[fr*...
    mgsammo.video.starttime:...
    2*fr:...
    mgsammo.video.endtime*fr]...
    /fr);
ylabel('seconds');
title('vertical gram');

%%
% plot the waveform,rms,spectrum
mgwaveplot(mgsammo);
%%

% compute the spectrum of quantity of motion, spectrum of rms
%
mir = mirframe(mgsammo.audio.mir,'Length',1/15)
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
%%
subplot(212)
fft_qom = fft(mgsammo.video.qom);
L = length(fft_qom);
x = abs(fft_qom/L);
x1 = x(1:L/2+1);
x1(2:end-1) = 2*x1(2:end-1);
fs = 30;
f = fs*(0:L/2)/L;
plot(f,x1);
xlabel('f(Hz)')
set(gca,'XTick',[0:15])
ylabel('magnitude')
title('spectrum of qom')


%% statistics 
features1 = mgstatistics(mgsammo,'Video','FirstOrder');
features1_norm = features1./repmat(max(features1),size(mgsammo.video.gram.gramy,1),1);
plot(features1_norm(:,2),features1_norm(:,3),'.')
%%
features2 = mgstatistics(mgsampleseg_motion,'Video','SecondOrder');
features2_norm = features2./repmat(max(features2),size(mgsammo.video.gram.gramy,1),1);
plot(features2_norm(:,7),features2_norm(:,8),'.')

%%
%%%%%%%%%%% analysis the mocap data
mcplottimeseries(mgsammo.mocap,[1:9],'dim',3)
mcplottimeseries(mgsammo.mocap,[1:9],'dim',2)
mcplottimeseries(mgsammo.mocap,[1:9],'dim',1)
%%
mocap = mgseg.mocap;
[m,n] = size(mocap.data);
for i =  1:m-1
    mocap.diffdata(i,:) = abs((mocap.data(i+1,:) - mocap.data(i,:)));
end
mocap_diff = mocap;
mocap_diff.data = mocap.diffdata;
mocap_diff.nFrames = mocap_diff.nFrames - 1;
mocap_diff = mcnorm(mocap_diff);
%% norm difference movement of each person
figure,
for i = 1:9
    subplot(3,3,i)
    plot(mocap_diff.data(:,i))
    set(gca,'XTick',[0:1600:m-1])
    set(gca,'XTickLabel',[ts:8:te])
    ylim([0 10])
    title(['difference movement of person',num2str(i)])
    xlabel('Time(s)')
end
%% periodicity of difference movement
[per2,ac2,eac2,lag2] = mcperiod(mocap_diff,3);
figure,
for i = 1:9
    subplot(3,3,i)
    plot(lag2,ac2(:,i))
    title(['periodicity of person',num2str(i)])
    xlabel('lag(s)')
end
%% average movement of 9 persons
figure,
av = sum(mocap_diff.data,2)/9;
plot(av)
set(gca,'XTick',[0:1600:m-1])
set(gca,'XTickLabel',[ts:8:te])
xlabel('Time(s)')
title('average movement of 9 persons')
%% summation movement of 9 persons
figure,
total = sum(mocap_diff.data,2);
plot(total);
set(gca,'XTick',[0:1600:m-1])
set(gca,'XTickLabel',[ts:8:te])
xlabel('Time(s)')
title('total movement of 9 persons')
%% similarity of persons
sm = mgsimilarity(mocap_diff.data');
figure,imagesc(sm)
xlabel('no.person')
ylabel('no.person')
title('similarity matrix')
%% spectrum of difference position
figure,
[s2,f2] = mcspectrum(mocap_diff);
for i = 1:9
    subplot(3,3,i)
    plot(f2(1:6000),s2.data(1:6000,i))
    xlim([0 20])
    title(['spectrum of person',num2str(i)])
    xlabel('Hz')
end
%% similarity of spectrum of persons
sm_spec = mgsimilarity(s2.data');
figure,imagesc(sm_spec)
xlabel('no.person')
ylabel('no.person')
title('spectrum similarity matrix')
%% marker positions of 9 nine persons
figure;
mocap = mcnorm(mocap);
for i = 1:9
    subplot(3,3,i)
    plot(mocap.data(:,i))
    set(gca,'XTick',[0:1600:m])
    set(gca,'XTickLabel',[5:8:125])
    title(['marker position of person',num2str(i)])
    xlabel('Time(s)')
end
figure,
av = sum(mocap.data,2)/n;
plot(av)
set(gca,'XTick',[0:1600:m])
set(gca,'XTickLabel',[ts:8:te])
xlabel('Time(s)')
title('average position of 9 persons')
%%
[per3,ac3,eac3,lag3] = mcperiod(mocap,3);
figure,
for i = 1:9
    subplot(3,3,i)
    plot(lag3,ac3(:,i))
    title(['periodicity of person',num2str(i)])
    xlabel('lag(s)')
end

%% spectrum of marker position
[s1,f1] = mcspectrum(mocap);
figure
for i = 1:9
    subplot(3,3,i)
    plot(f1(1:6000),s1.data(1:6000,i))
    xlim([0 2])
    title(['spectrum of person',num2str(i)])
    xlabel('Hz')
end









    

