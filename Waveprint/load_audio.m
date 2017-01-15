function varargout=load_audio(varargin)

% Load the list of audio file in input.
% The output list has one element per audio file.
% If the audio is stereo, it discards one channel.
% The first element of the output vector is the sampling frequency of the first input file.
% If input files have different sampling frequency, it displays a warning.
 str=varargin{1};
 [tmp,fs]=audioread(str,'double');
 tmp=double(tmp);
 varargout{1}=fs;
 varargout{2}=tmp(:,1);

 if nargin>1
    for i = 2: nargin
        str=varargin{i};
        [tmp,fs2]=audioread(str,'double');
        tmp=double(tmp);
        if(fs2~=fs)
            warning('Input files differ in sampling frequency!!!');
        end
        varargout{i+1}=tmp(:,1);
    end
 end
end

 
