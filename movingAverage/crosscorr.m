function [f1,f2,c]=crosscorr(f1,f2)
maxLag=0.15*44100;
[cor,lag]=xcorr(f1,f2,maxLag);
[c,I]=max(abs(cor));
lagDiff=lag(I);
%[c,~]=max(abs(cor));

if lagDiff==0
    if length(f1)>length(f2)
        f1=f1(1:length(f2));
    end
    if length(f1)<length(f2)
        f2=f2(1:length(f1));
    end
    return
end

if lagDiff>0
    f1=f1(lagDiff:end);
else
    f2=f2(-lagDiff:end);    
end

if length(f1)>length(f2)
    f1=f1(1:length(f2));
end
if length(f1)<length(f2)
    f2=f2(1:length(f1));
end

end