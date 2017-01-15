function y=hanning(y,frame_duration,fs)

[m,n]=size(y);

for i=1:n
    y(:,i)=y(:,i).*hann(frame_duration*fs);
end
end
