 Fc=[16 19.01 22.59 26.84 31.9 37.91 45.05 53.54 63.62 75.6 89.84 106.76 126.86 ...
    150.75 179.15 212.89 252.98 300.62 357.24 424.52 504.46 599.46 712.36 846.52 ...
    1005.94 1195.39 1420.51 1688.03 2005.93 2388.7 2832.62 3366.08 4000];

pi = 3.14159265358979;
Fs=44100;
for i=1:13
    N=2;
    format long
    f1= Fc(i)/1.09;
    f2= Fc(i)*1.09;
    Qr=Fc(i)/(f2-f1);
    Qd=(pi/2/N)/(sin(pi/2/N))*Qr;
    alpha=(1+sqrt(1+4*Qd^2))/2/Qd;
    W1=Fc(i)/(Fs/2)/alpha;
    W2=Fc(i)/(Fs/2)*alpha;
    [B,A]=butter(N,[W1,W2]);
    stability(i)=isstable(B,A);
    npoints = 10000; 
    [h,f]=freqz(B,A,npoints,Fs);
    response_dB = 10.*log10(h.*conj(h));
    response_deg = 180/pi*angle(h);
    semilogx(f,response_dB);
    hold on
    grid on
    
end


for i=14:33
    N=3;
    f1= Fc(i)/1.09;
    f2= Fc(i)*1.09;
    Qr=Fc(i)/(f2-f1);
    Qd=(pi/2/N)/(sin(pi/2/N))*Qr;
    alpha=(1+sqrt(1+4*Qd^2))/2/Qd;
    W1=Fc(i)/(Fs/2)/alpha;
    W2=Fc(i)/(Fs/2)*alpha;
    [B,A]=butter(N,[W1,W2]);
    stability(i)=isstable(B,A);
    npoints = 10000; 
    [h,f]=freqz(B,A,npoints,Fs);
    response_dB = 10.*log10(h.*conj(h));
    response_deg = 180/pi*angle(h);
    semilogx(f,response_dB);
    xlabel('Frequency (Hz)');
    ylabel('Response (dB)');
    title('Log spaced filters N=2 <=126.86Hz')
    hold on
    grid on     
end
 
N=3;
f1= Fc(1)/1.09;
f2= Fc(1)*1.09;
Qr=Fc(1)/(f2-f1);
Qd=(pi/2/N)/(sin(pi/2/N))*Qr;
alpha=(1+sqrt(1+4*Qd^2))/2/Qd;
W1=Fc(1)/(Fs/2)/alpha;
W2=Fc(1)/(Fs/2)*alpha;
[B,A]=butter(N,[W1,W2]);
isstable(B,A)
z=tf('z',1/Fs);
H=tf(B,A,z);
max(abs(pole(H)))
figure
[z,p,k] = butter(N,[W1,W2]);
zplane(z,p)

N=3;
f1= 45/3; %15
f2= 45*3; %135
Qr=40/(f2-f1);
Qd=(pi/2/N)/(sin(pi/2/N))*Qr;
alpha=(1+sqrt(1+4*Qd^2))/2/Qd;
W1=45/(Fs/2)/alpha;
W2=45/(Fs/2)*alpha;
[B,A]=butter(N,[W1,W2]);
isstable(B,A)
z=tf('z',1/Fs);
H=tf(B,A,z);
max(abs(pole(H)))
figure
[z,p,k] = butter(N,[W1,W2]);
zplane(z,p)
   
N=3;
f1= Fc(33)/1.09; %*0.9998;
f2= Fc(33)*1.09; %x/0.9998;
Qr=Fc(33)/(f2-f1);
Qd=(pi/2/N)/(sin(pi/2/N))*Qr;
alpha=(1+sqrt(1+4*Qd^2))/2/Qd;
W1=Fc(33)/(Fs/2)/alpha;
W2=Fc(33)/(Fs/2)*alpha;
[B,A]=butter(N,[W1,W2]);
isstable(B,A)
z=tf('z',1/Fs);
H=tf(B,A,z);
max(abs(pole(H)))
figure
[z,p,k] = butter(N,[W1,W2]);
zplane(z,p)
