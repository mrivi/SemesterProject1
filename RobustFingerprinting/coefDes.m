function [B,A]=coefDes(Fc,Fs,N)

if (nargin > 3) | (nargin <= 2)
  error('Invalide number of arguments.');
end
if (Fc > 0.88*(Fs/2))
  error('Design not possible. Check frequencies.');
end

pi = 3.14159265358979;
Fs=44100;
f1= Fc/1.09;
f2= Fc*1.09;
Qr=Fc/(f2-f1);
Qd=(pi/2/N)/(sin(pi/2/N))*Qr;
alpha=(1+sqrt(1+4*Qd^2))/2/Qd;
W1=Fc/(Fs/2)/alpha;
W2=Fc/(Fs/2)*alpha;
[B,A]=butter(N,[W1,W2]);
end
