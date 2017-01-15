filename='/Users/martinarivizzigno/Documents/MATLAB/Waveprint/attackSicc.csv';
header='vic_user,vic_id,vic_enviroment,adv_user,adv_id,adv_enviroment,error';
fileID=fopen(filename,'w');
fprintf(fileID,'%s\n',header);

vicDir='/Users/martinarivizzigno/Documents/MATLAB/Waveprint/victim/';
advDir='/Users/martinarivizzigno/Documents/MATLAB/Waveprint/adversary/';
vicFiles = dir(strcat(vicDir,'*.wav'));
advFiles = dir(strcat(advDir,'*.wav'));
VictimAudioMatrix={};
counter=1;
for vicFile=vicFiles'
    file=strcat(vicDir,vicFile.name);
    fname=strsplit(vicFile.name,'_');
    vic_user{counter}=fname{1};
	vic_id(counter)=str2num(fname{2});
    vic_enviroment{counter}=fname{4};
	[fs,f]=load_audio(file);
	VictimAudioMatrix{counter}=f;
	counter=counter+1;
end

AdversaryAudioMatrix={};
counter=1;
for advFile = advFiles'
    file=strcat(advDir,advFile.name);
    fname=strsplit(advFile.name,'_');
    adv_user{counter}=fname{1};
	adv_id(counter)=str2num(fname{2});
    adv_enviroment{counter}=fname{4};
	[fs,f]=load_audio(file);
	AdversaryAudioMatrix{counter}=f;
	counter=counter+1;
end

%parameters
frame_interval=0.0023;
frame_duration=0.0185; %0.371;
Fc=[19.01 22.59 26.84 31.9 37.91 45.05 53.54 63.62 75.6 89.84 106.76 126.86 ...
    150.75 179.15 212.89 252.98 300.62 357.24 424.52 504.46 599.46 712.36 846.52 ...
    1005.94 1195.39 1420.51 1688.03 2005.93 2388.7 2832.62 3366.08 4000];
frame_length=ceil(frame_duration*fs);
frame_step=floor(frame_interval*fs);
overlap=frame_length-frame_step;
t=6; % number of top wavelet
fs=44100;
p=50; %permutation
w=4*32; %4 columns * 32 elements
s=2*32; %2 colums *32 elements skipped

for i=1:size(VictimAudioMatrix,2)
    f1=VictimAudioMatrix{i};
    for j=1:size(AdversaryAudioMatrix,2)
        f2=AdversaryAudioMatrix{j};
        
        [f1,f2]=crosscorr(f1,f2);

        [specf1,~] = spectrogram(f1,hann(frame_length),overlap, Fc,fs);
        [specf2,~] = spectrogram(f2,hann(frame_length),overlap, Fc,fs);
        
        tmpf1 = reshape(specf1,1,[]);
        tmpf2 = reshape(specf2,1,[]);
        sif1 = buffer(tmpf1,w,w-s);
        sif2 = buffer(tmpf2,w,w-s);
        it=size(sif1,2); %non necessario
    
        for k=1:it
            [specf1]=specImage(sif1,k);
            [specf2]=specImage(sif2,k);
   
            pow1=floor(log2(size(specf1,2))); 
            pow2=floor(log2(size(specf2,2))); %non sono piu necessari
   
            [wf1]=haarWavelets(specf1,2^pow1);
            [wf2]=haarWavelets(specf2,2^pow2);
    
            [tf1]=top(t,wf1);
            [tf2]=top(t,wf2);
   
            nomatch(k)=nnz(tf1-tf2);
        end
        %num_zero=length(nomatch)-nnz(nomatch) 
        nomatch=mean(nomatch)
        
        formatSpec ='%s,%d,%s,%s,%d,%s,%d,'; % format 
        formatSpec = strcat(formatSpec,'%d,'); 
        fprintf(fileID, formatSpec, vic_user{1,i},vic_id(i),vic_enviroment{1,i},adv_user{1,j},adv_id(j),adv_enviroment{1,j},nomatch);
        fprintf(fileID,'\n');
    end
end

fclose(fileID)