% file output with results
filename='/Users/martinarivizzigno/Documents/MATLAB/RobustFingerpring/prova.csv';
header='user,id,enviroment,error,match';
fileID=fopen(filename,'w');
fprintf(fileID,'%s\n',header);

%load audio
audioDir='/Users/martinarivizzigno/Documents/MATLAB/RobustFingerpring/prova/';
audioFiles=dir(strcat(audioDir,'*.wav'));
audioMatrix={};
counter=1;
user=[];
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

%parameters
frame_interval=0.0116;
frame_duration=0.37;
frame_numb=256;
band_numb=33;
alpha=0.35;
n_bit=(band_numb-1)*frame_numb; %number of bits=band_number*frame_numb
T=ceil(alpha * n_bit);%threshold for similarity 

for i=1:2:counter-1
    web=audioMatrix{i};
    phone=audioMatrix{i+1};
        
    %cross correlation
    [web,phone]=crosscorr(web,phone);

    [web]=frame(web, fs, frame_duration, frame_interval);
    web=hanning(web,frame_duration,fs);
    [phone]=frame(phone, fs, frame_duration, frame_interval);
    phone=hanning(phone,frame_duration,fs);
   
    for k=1:frame_numb+1
        p1(:,k)=filterBank(web(:,k),fs);
        p2(:,k)=filterBank(phone(:,k),fs);
    end


    F1=fingerprint(p1,frame_numb+1,band_numb);
    F2=fingerprint(p2,frame_numb+1,band_numb);
    

    hamming=F1-F2;
    nz=nnz(hamming);
  
    if nz<T
        match=1;
    else
        match=0;
    end
    
    formatSpec ='%s,%d,%s,%d,%d,'; % format for user,id,enviroment,nz,match
    formatSpec = strcat(formatSpec,'%d,'); 
    fprintf(fileID, formatSpec, user{1,i},id(i),enviroment{1,i},nz,match);
    fprintf(fileID,'\n');
   
end

fclose(fileID);
