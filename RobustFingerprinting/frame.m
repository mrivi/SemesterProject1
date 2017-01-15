function [y]=frame(audio, fs, frame_duration, frame_interval)

N=length(audio);
frame_step=floor(frame_interval*fs);
frame_length=ceil(frame_duration*fs);
frame_num=ceil(N/frame_step);

for K=1:size(audio,2)
    y = buffer(audio(:,K),frame_length,frame_length-frame_step);
end
end


