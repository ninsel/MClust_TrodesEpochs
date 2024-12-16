function [t, wv] = LoadTT_Trodes_Epoch(fn, records_to_get, record_units)
%[t, wv] = mClustTrodesLoadingEngine(fn, records_to_get, record_units)
%
% This loading engine combines spikes across epochs (R1, behavior, R2)
%       
% NOTE: due to changes, "fn" won't actually be the file name. We'll have to resolve
% the name internally.
%
% INPUTS:
% fn = the file name of an exported .dat file from a Trodes recording containing spike waveforms and spike times
% records_to_get = = a range of values
% record_units = a flag taking one of 5 cases (1,2,3,4 or 5)
% OUTPUT:
% t = n x 1: timestamps of each spike in file
% wv = n x 4 x 32 waveformsfileData = readTrodesExtractedDataFile(fn);
%
%
% nei 12/24 built from van der Meer's mClustTrodesLoadingEngine


%



%Need to decompose the fn into directory and (false) filename, then pull
%the times and waveforms from the multiple files associated witht he falst
%filename

curdir = pwd;
if ispc
	folderchar = '\';
else
	folderchar = '/';
end
splitpath = strsplit(fn, folderchar);

filenameend = splitpath{end};

file_allepochs = FindFiles(['*spikes*' filenameend]);
if isempty(file_allepochs) %OOPS -- made a mistake when creating the FD files, this helps fix the issue 
    file_allepochs = FindFiles(['*spikes*' [filenameend(1:5) filenameend(end-2:end)]]);
end


epochfolder = {};
sysTimeE = nan(length(file_allepochs),1);
for i = 1:length(file_allepochs)
    E{i} = readTrodesExtractedDataFile(file_allepochs{i});
    if (isempty(E{i}))     
        disp(['File read error: ',fn]);    
        return;
    end
    if isempty(strfind(E{i}.description, 'Spike waveforms'))  
        disp(['File does not contain spike waveforms: ',fn]);    
        return
    end
    sysTimeE(i) = E{i}.system_time_at_creation;
end

[sT sTo] = sort(sysTimeE);
newstartTS = sT-sT(1); % new timestamps! 

for i = 1:length(sTo) % we're putting this in order
    ts_cur{i} = double(E{sTo(i)}.fields(1).data)/E{sTo(i)}.clockrate;
    ts_cur{i} = ts_cur{i} + newstartTS(i)/1000; %Note the conversion back to seconds from ms! 
end

completeTimestamps = cat(1,ts_cur{:});


    recordIndex = [];
    wv = [];
    t = [];
 

if nargin > 1
    switch record_units  
    case 1   %implies that records_to_get is a timestamp list.     
        recordIndex = zeros(length(records_to_get),1);    
        for i=1:length(records_to_get)      
            hit = find(completeTimestamps==records_to_get(i),1,'first');      
            if (~isempty(hit))        
                recordIndex(i) = hit;      
            end    
        end      
    case 2 % implies that records_to_get  is a record number list    
        recordIndex = records_to_get;      
    case 3     % implies that records_to_get  is range of timestamps (a vector with 2 elements: a start and an end timestamp)     
        recordIndex = find((completeTimestamps >= records_to_get(1)) & (completeTimestamps <= records_to_get(2)));      
    case 4     % implies that records_to_get  is a range of records (a vector with 2 elements: a start and an end record number)     
        recordIndex = [records_to_get(1):records_to_get(2)]';       
    case 5     %asks to return the count of spikes (records_to_get should be [] in this case)     
        t = length(completeTimestamps);    
    end 
else
    recordIndex = 1:length(completeTimestamps);
end


    t = completeTimestamps(recordIndex);  
    if (nargout > 1)    
        wv = zeros(length(t),32,4);    

        for i = 1:length(sTo)
            for fieldInd = 2:(min(length(E{sTo(i)}.fields),5)) 
                curwav{i}(:,:,fieldInd-1) = double(E{sTo(i)}.fields(fieldInd).data(:,1:32))*E{sTo(i)}.voltage_scaling;        
            end
        end
        wv = cat(1, curwav{:});
        wv = permute(wv(recordIndex,:,:),[1 3 2]); 
    end   

