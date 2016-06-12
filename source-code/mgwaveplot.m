function mgwaveplot(varargin)
% function mgwaveplot(varargin)
% mgwaveplot plots the waveform of the audio,and spectrum, rms,envelop of the audio
% syntax: mgwaveplot(mg)
% input: 
% mg: musical gestures data structure containing the audio information
% output:
% a figure showing the waveform,spectrum,rms,envelop of the audio
close all
if isempty(varargin)
    return
end
audio = varargin{1}.audio.mir
title('Waveform')
ax1 = gca;
rms = mirrms(audio,'frame',2/varargin{1}.video.obj.FrameRate)
title('RMS')
xlabel('time(s)')
ylabel('amplitude')
ax2 = gca;
spec = mirspectrum(audio,'Frame','dB')
title('Spectrogram')
xlabel('time(s)')
ax3 = gca;
ax31 = gca;
spec_rms = mirspectrum(rms)
title('Spectrum of RMS')
ax4 = gca;
s = varargin{1};
h = figure;
ax1_copy = copyobj(ax1,h);
ax2_copy = copyobj(ax2,h);
ax3_copy = copyobj(ax3,h);
ax4_copy = copyobj(ax4,h);
subplot(2,2,1,ax1_copy);
subplot(2,2,2,ax2_copy);
subplot(2,2,3,ax3_copy); 
subplot(2,2,4,ax4_copy);
figureobj = findobj('Type','figure');
l = length(figureobj);
close(figure(l-1))
close(figure(l-2))
close(figure(l-3))
close(figure(l-4))
if isfield(s,'video')
    if isfield(s.video,'qom')
        figure;
        subplot(2,1,1),plot(s.video.qom);
        title('QoM')
        tmp = s.video.obj.FrameRate;
        set(gca,'XTick',[0:2*tmp:length(s.video.qom)]);
        set(gca,'XTickLabel',s.video.starttime+[0:2*tmp:length(s.video.qom)]/tmp)
        ylabel('magnitude')
        rms_data = mirgetdata(rms);
        subplot(2,1,2),plot(rms_data);
        set(gca,'XTick',[0:2*tmp:length(rms_data)]);
        set(gca,'XTickLabel',s.video.starttime+[0:2*tmp:length(rms_data)]/tmp)
        title('RMS')
        xlabel('time(s)')
        ylabel('magnitude')

    end
end

