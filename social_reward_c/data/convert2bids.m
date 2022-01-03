    
clear; close all;
maindir = pwd;
warning off all

subs = [1001, 1002, 1003, 1004, 1006, 1007, 1009, 1010, 1011, 1012, 1013, 1015, 1016, ... 
    1019, 1021, 1240, 1242, 1243, 1244, 1245, 1247, 1248, 1249, 1251, 1253, 1255, 1276, ...
    1281, 1282, 1286, 1294, 1300, 1301, 1302, 3101, 3116, 3122, 3125, 3140, ...
    3143, 3152, 3164, 3166, 3167, 3170, 3173, 3175, 3176, 3186, 3189, 3190, ...
    1303, 3199, 3200, 3206, 3210, 3212, 3218, 3220, 3223];

tasks = {'faceA', 'faceB', 'facesA', 'facesB', 'doorsA', 'doorsB', 'imageA', 'imageB'};

% loop through each sub
for s = 1:length(subs)
    
    for t = 1:length(tasks)
        rawtask = tasks{t};
    
        % rename task
        if strcmp(rawtask,'faceA') || strcmp(rawtask,'faceB') || strcmp(rawtask,'facesA') || strcmp(rawtask,'facesB')
            bidstask = 'socialdoors';
        elseif strcmp(rawtask,'doorsA') || strcmp(rawtask,'doorsB') || strcmp(rawtask,'imageA') || strcmp(rawtask,'imageB')
            bidstask = 'doors';
        else
        end
    
        % set file names and load in source data
        inputdir = sprintf('%s/%d', pwd, subs(s));
        inputname = sprintf('%s/sub-%d_ses-1_task-socialReward_%s_events.tsv', inputdir, subs(s), rawtask);
        outputname = sprintf('%s/sub-%d_task-%s_run-1_events.tsv', inputdir, subs(s), bidstask);
        
        % confirm file exists & rename file
        if isfile(inputname)
            T = readtable(inputname,'FileType','delimitedtext');
    
            % replace NaN with proper BIDS naming
            %T.rt(isnan(T.rt)) = 'n/a'
    
            writetable(T,outputname,'FileType','text','Delimiter','\t') 
        else
        end
    end
end
