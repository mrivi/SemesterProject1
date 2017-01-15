filename='/Users/martinarivizzigno/Documents/MATLAB/RobustFingerpring/attackHome.csv';
header='vic_user,vic_id,vic_enviroment,adv_user,adv_id,adv_enviroment,error,match';
fileID=fopen(filename,'w');
fprintf(fileID,'%s\n',header);

vicDir='/Users/martinarivizzigno/Documents/MATLAB/MovingAvarage/vicHome/';
advDir='/Users/martinarivizzigno/Documents/MATLAB/MovingAvarage/advHome/';
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
frame_interval=0.0116;
frame_duration=0.37;
frame_numb=256;
band_numb=33;
alpha=0.35;
n_bit=(band_numb-1)*frame_numb; %number of bits=band_number*frame_numb
T=ceil(alpha * n_bit);%threshold for similarity 

for i=1:size(VictimAudioMatrix,2)
    f1=VictimAudioMatrix{i};
    for j=1:size(AdversaryAudioMatrix,2)
        f2=AdversaryAudioMatrix{j};
        
        [web,phone]=crosscorr(f1,f2);

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
        %num_match=n_bit-nz;
        if nz<T
            match=1;
        else
            match=0;
        end
        
        formatSpec ='%s,%d,%s,%s,%d,%s,%d,%d,'; % format 
        formatSpec = strcat(formatSpec,'%d,'); 
        fprintf(fileID, formatSpec, vic_user{1,i},vic_id(i),vic_enviroment{1,i},adv_user{1,j},adv_id(j),adv_enviroment{1,j},nz,match);
        fprintf(fileID,'\n');
    end
end

fclose(fileID)