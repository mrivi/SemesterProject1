function [p]=filterBank(x,Fs,Fc)

if Fc>125
   [B,A] = octdsgn(Fc,Fs,3); 
else
    [B,A] = octdsgn(Fc,Fs,2); 
end
stability=isstable(B,A);
    if stability==0
        error('filter not stable');
    end

p=filter(B,A,x);        
end

