filename='/Users/martinarivizzigno/Documents/MATLAB/MovingAvarage/attack_new.csv';
header='vicUser, vicId, vicEnviroment, advUser, advId, advEnviroment, lagUnbounded, lagBounded, meanCorr, ';
header=strcat(header,'16, 20, 25, 31.5, 40, 50, 63, 80, 100, 125, 160, 200, 250, 315, 400, 500,630, 800, 1000, 1250, 1600, 2000, 2500, 3150, 4000, 5000, 6300, 8000, 10000, 12500, ');
header=strcat(header,'meanMatch, ');
header=strcat(header,'16, 20, 25, 31.5, 40, 50, 63, 80, 100, 125, 160, 200, 250, 315, 400, 500,630, 800, 1000, 1250, 1600, 2000, 2500, 3150, 4000, 5000, 6300, 8000, 10000, 12500');
fileID=fopen(filename,'w');
fprintf(fileID,'%s\n',header);

vicDir='/Users/martinarivizzigno/Documents/MATLAB/MovingAvarage/vic/';
advDir='/Users/martinarivizzigno/Documents/MATLAB/MovingAvarage/adv/';
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
fs=44100;
Fc=[16, 20, 25, 31.5, 40, 50, 63, 80, 100, 125, 160, 200, 250, 315, 400, 500, ...
   630, 800, 1000, 1250, 1600, 2000, 2500, 3150, 4000, 5000, 6300, 8000, 10000, ...
   12500];%, 16000, 20000];
window=floor(0.5e4); %100;
overlap=ceil(0.4e4);

for i=1:size(VictimAudioMatrix,2)
    f1=VictimAudioMatrix{i};
    for j=1:size(AdversaryAudioMatrix,2)
        f2=AdversaryAudioMatrix{j};
        
        [lagUnbounded,lagBounded]=lagDiff(f1,f2);
        
        for k=1:length(Fc)
            [f1Filtered]=filterBank(f1,fs,Fc(k));
            [f2Filtered]=filterBank(f2,fs,Fc(k));
    
            [movAvef1]=movingAvarage(f1Filtered,window,overlap);
            [movAvef2]=movingAvarage(f2Filtered,window,overlap);

            [s1,s2,c]=crosscorr(movAvef1,movAvef2);
            corr(k)=c;
            [ma1]=signMovAve(s1);
            [ma2]=signMovAve(s2);
            matchPerc(k)=(length(ma1)-nnz(ma1-ma2))/length(ma1)*100;
    
        end
        
    meanMatch=mean(matchPerc);
    meanCorr=mean(corr);
    
    formatSpec ='%s,%d,%s,%s,%d,%s,%e,%e,%e,%e, '; % format for user,id,enviroment,lagUnbounded,lagBounded
    formatSpec = strcat(formatSpec,'%e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, ');
    formatSpec = strcat(formatSpec,'%e, '); %meanMatch
    formatSpec = strcat(formatSpec,'%e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e');
    %formatSpec = strcat(formatSpec,'%d,'); 
    fprintf(fileID, formatSpec, vic_user{1,i},vic_id(i),vic_enviroment{1,i},adv_user{1,j},adv_id(j),adv_enviroment{1,j},lagUnbounded,lagBounded,meanCorr,corr,meanMatch,matchPerc);
    fprintf(fileID,'\n');
    
    end
end
    
    fclose(fileID)