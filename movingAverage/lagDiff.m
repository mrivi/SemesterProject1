function [lagDiffU,lagDiffB]=lagDiff(f1,f2)
maxLag=0.15*44100;
[c,lag]=xcorr(f1,f2,maxLag);
[~,I]=max(abs(c));
lagDiffU=lag(I);

[c,lag]=xcorr(f1,f2,maxLag);
[~,I]=max(abs(c));
lagDiffB=lag(I);
end
