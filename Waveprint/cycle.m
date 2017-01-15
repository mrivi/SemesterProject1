% file output with results
folder = 'samples';
filename=strcat(pwd, '/', folder, '/','out.csv');
header='user,id,enviroment,error';
fileID=fopen(filename,'w');
fprintf(fileID,'%s\n',header);

%load audio
audioDir=strcat(pwd, '/', folder, '/');
%'/Users/martinarivizzigno/Documents/MATLAB/waveprint2//';
audioFiles=dir(strcat(audioDir,'*.wav'));
audioMatrix={};
counter=1;
user={};
for audioFile=audioFiles'
	file=strcat(audioDir,audioFile.name);
    fname=strsplit(audioFile.name,'_');
    user{counter}=fname{1};
	id(counter)=str2num(fname{2});
    enviroment{counter}=fname{4};
	[fs,f]=load_audio(file);
	audioMatrix{counter}=f;
	counter=counter+1;
end


fs=44100;
frame_interval=0.0116;%0.001; %0.0116;
frame_duration=0.371;

spectral_image_length = 1.5; %sec
si_sampling_stride = 0.048; %sec

Fc=[19.01 22.59 26.84 31.9 37.91 45.05 53.54 63.62 75.6 89.84 106.76 126.86 ...
    150.75 179.15 212.89 252.98 300.62 357.24 424.52 504.46 599.46 712.36 846.52 ...
    1005.94 1195.39 1420.51 1688.03 2005.93 2388.7 2832.62 3366.08 4000];
nBands = size(Fc,2);

frame_length=ceil(frame_duration*fs);
frame_step=floor(frame_interval*fs);
overlap=frame_length-frame_step;
t=200;%6; %200; % number of top wavelet
p=50; %permutation

%w= columns * elements
w = nBands * floor((spectral_image_length-frame_duration)/frame_interval);

%s=colums * elements skipped
s = nBands * floor(si_sampling_stride/frame_interval);


for i=1:2:counter-1
    web=audioMatrix{i};
    phone=audioMatrix{i+1};

    [f1,f2]=crosscorr(web,phone);
    
    [specWeb,F,T] = spectrogram(f1,hann(frame_length),overlap, Fc,fs);
 
    [specPhone,~] = spectrogram(f2,hann(frame_length),overlap, Fc,fs);
    
    specWeb = real(specWeb);
    specPhone = real(specPhone);

    tmpW = reshape(specWeb,1,[]);
    tmpP = reshape(specPhone,1,[]);
    siW = buffer(tmpW,w,w-s, 'nodelay');
    siP = buffer(tmpP,w,w-s, 'nodelay');
    itP=size(siP,2);
    itW=size(siW,2);
    it=min(itP,itW); 
    
    for k=1:it
        
        [specWeb]=specImage(siW,k, floor((spectral_image_length-frame_duration)/frame_interval), nBands);
        [specPhone]=specImage(siP,k, floor((spectral_image_length-frame_duration)/frame_interval), nBands);
        
        powW=floor(log2(size(specWeb,2)));
        powP=floor(log2(size(specPhone,2))); 
   
        [wWeb] = wavedec2(specWeb,6,'haar');
        
        [wPhone] = wavedec2(specPhone,6,'haar');
    
        [tWeb]=topt(t,wWeb);
        [tPhone]=topt(t,wPhone);
        
    end

   formatSpec ='%s,%d,%s,%d,%d,'; % format for user,id,enviroment,error
   formatSpec = strcat(formatSpec,'%d,'); 
   fprintf(fileID, formatSpec, user{1,i},id(i),enviroment{1,i});
   fprintf(fileID,'\n');
end

fclose(fileID)

