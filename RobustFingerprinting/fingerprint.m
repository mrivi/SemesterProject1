function F=fingerprint(p,frame_numb,band_numb)

%ogni colonna di p corrisponde a un frame
%righe bande dalla 1 alla 33

F=[];

for n=2:frame_numb
    for m=1:(band_numb-1)
        temp=p(m,n)-p(m+1,n)-(p(m,n-1)-p(m+1,n-1));
        if temp>0
            F(m,n-1)=1;
        else
            F(m,n-1)=0;
        end
    end
end
end
