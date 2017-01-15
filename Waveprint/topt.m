function [twavelet]=topt(t,wavelet)

wavelet_abs=abs(wavelet);
sorted = sort(wavelet_abs(:));
ttop = sorted(end-t+1:end);
[~,ia,~] = intersect(wavelet_abs(:),ttop(:)); % // Get the indices of the top t values
%[r,c]=ind2sub(size(wavelet_abs),ia); % // Convert the indices to rows and columns

k=1;
twavelet=[];

for i=1:size(wavelet,1)
    for j=1:size(wavelet,2)
        if ismember(abs(wavelet(i,j)),ttop)==1
            if wavelet(i,j)>0
                %sn(i,j)=10;
                twavelet(k)=1;
                twavelet(k+1)=0;
            else
                %sn(i,j)=1;
                twavelet(k)=0;
                twavelet(k+1)=1;
            end
        else
            %sn(i,j)=0;
            twavelet(k)=0;
            twavelet(k+1)=0;
        end
        k=k+2;
    end
end
