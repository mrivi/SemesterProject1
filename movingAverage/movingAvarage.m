function [a]=movingAvarage(v,window,overlap)

sample_step=window-overlap;
len=(length(v)-window)/sample_step+1;

i=1;
movAve=0;

for k=1:1:len
    s=sum(v(i:i+window-1)); 
    a(k)=s/window;
    i=i+sample_step;
%     if k>1
%        if a(k-1)>a(k)
%            movAve(k)=-1;
%        end
%        if a(k-1)<a(k)
%            movAve(k)=1;
%        end
%         if a(k-1)==a(k)
%         movAve(k)=0;
%         end
%     end
end
