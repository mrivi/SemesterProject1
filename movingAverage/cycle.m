% file output with results
filename='/Users/martinarivizzigno/Documents/MATLAB/MovingAvarage/prova.csv';
header='user, id, enviroment, lagUnbounded, lagBounded, MeanCorr, ';
header=strcat(header,'16, 20, 25, 31.5, 40, 50, 63, 80, 100, 125, 160, 200, 250, 315, 400, 500,630, 800, 1000, 1250, 1600, 2000, 2500, 3150, 4000, 5000, 6300, 8000, 10000, 12500, ');
% header=strcat(header,'meanMatch, ');
% header=strcat(header,'16, 20, 25, 31.5, 40, 50, 63, 80, 100, 125, 160, 200, 250, 315, 400, 500,630, 800, 1000, 1250, 1600, 2000, 2500, 3150, 4000, 5000, 6300, 8000, 10000, 12500');

fileID=fopen(filename,'w');
fprintf(fileID,'%s\n',header);

%load audio
%audioDir='/Users/martinarivizzigno/Documents/MATLAB/RobustFingerpring/audiofile/trimmed/';
audioDir='/Users/martinarivizzigno/Documents/MATLAB/MovingAvarage/prova/';
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
fs=44100;
Fc=[16, 20, 25, 31.5, 40, 50, 63, 80, 100, 125, 160, 200, 250, 315, 400, 500, ...
   630, 800, 1000, 1250, 1600, 2000, 2500, 3150, 4000, 5000, 6300, 8000, 10000, ...
   12500];%, 16000, 20000];

window=[10 9.72 9.44 9.18 8.92 8.67 8.42 8.18 7.95 7.73 7.51 7.30 7.09 6.89 6.69 6.50 6.32 6.14 5.97 5.8 5.64 5.48 5.33 5.18 5.03 4.89 4.75 4.61 4.48 4.35].*1000;
overlap=0.95.*window;
window=ceil(window);
overlap=ceil(overlap);

for i=1:2:counter-1
    web=audioMatrix{i};
    phone=audioMatrix{i+1};
    
    web_len=length(web)/fs;
    phone_len=length(phone)/fs;
    [lagUnbounded,lagBounded]=lagDiff(web,phone);    
    
    for k=1:length(Fc)
        [pW]=filterBank(web,fs,Fc(k));
        [pP]=filterBank(phone,fs,Fc(k));
        
        [movAveW]=movingAvarage(pW,window(k),overlap(k));
        [movAveP]=movingAvarage(pP,window(k),overlap(k));
        
        fsWeb=floor(length(movAveW)/web_len);
        fsPhone=floor(length(movAveW)/phone_len);
        if fsWeb~=fsPhone
            error('Fs moving average should be the same');
        else
            fs_ma=fsWeb;
        end
               
        [s1,s2,c]=crosscorr(movAveW,movAveP,fs_ma);
        corr(k)=c;
    end
    
    meanCorr=mean(corr);
    
    formatSpec ='%s,%d,%s,%e,%e,%e,%e, '; % format for user,id,enviroment,lagUnbounded,lagBounded
    format long e
    formatSpec = strcat(formatSpec,'%e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e, %e'); 
    fprintf(fileID, formatSpec, user{1,i},id(i),enviroment{1,i},lagUnbounded,lagBounded,meanCorr,corr); 
    fprintf(fileID,'\n');
    
end

fclose(fileID);
    
     