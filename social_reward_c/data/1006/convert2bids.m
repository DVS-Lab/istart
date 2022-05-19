
clear; close all;
maindir = pwd;
warning off all

sub = 1006;
tasks = {'faceA', 'faceB', 'facesA', 'facesB', 'doorsA', 'doorsB', 'imageA', 'imageB'};

for t = 1:length(tasks)
    rawtask = tasks{t};
    
    % rename task
    if strcmp(rawtask,'faceA')
        bidstask = 'socialdoors';
    elseif strcmp (rawtask,'faceB')
        bidstask = 'socialdoors';
    elseif strcmp(rawtask,'facesA')
        bidstask = 'socialdoors';
    elseif strcmp (rawtask,'facesB')
        bidstask = 'socialdoors';
    elseif strcmp (rawtask,'doorsA')
        bidstask = 'doors';
    elseif strcmp (rawtask,'doorsB')
        bidstask = 'doors';
    elseif strcmp (rawtask,'imageA')
        bidstask = 'doors';
    else
        bidstask = 'doors';
    end
    
    % set file names and load in source data
    inputname = sprintf('sub-%d_ses-1_task-socialReward_%s_events.tsv', sub, rawtask);
    outputname = sprintf('sub-%d_task-%s_run-01_events.tsv', sub, bidstask);
    T = readtable(inputname,'FileType','delimitedtext');
    
    % replace NaN with proper BIDS naming
    %T.rt(isnan(T.rt)) = 'n/a'
    
    writetable(T,outputname,'FileType','text','Delimiter','\t') 
    
end

