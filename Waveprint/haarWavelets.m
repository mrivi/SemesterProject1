function [wavelet]=haarWavelets(frames,n)


wavelet=[];
for i=1:size(frames,1)
    tmp=frames(i,1:n);
    %wavelet(i,:)=HaarDecomposition(tmp,'max');
    wavelet(i,:)=wavedec(tmp,6,'haar');
end

for j=1:n
%     wavelet(:,j)=HaarDecomposition((wavelet(:,j))','max');
    wavelet(:,j)=wavedec(wavelet(:,j),5,'haar');
end

end
