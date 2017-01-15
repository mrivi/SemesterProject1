function [signAve]=signMovAve(s)

len=length(s);
singAve=0;

for k=2:len
    if s(k-1)>s(k)
        signAve(k)=-1;
    end
    if s(k-1)<s(k)
        signAve(k)=1;
    end
    if s(k-1)==s(k)
        signAve(k)=0;
    end
    
end