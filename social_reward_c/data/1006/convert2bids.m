
sub = 1006;
tasks = {'faceA', 'imageA'};

for t = 1:length(tasks)
    rawtask = tasks{t};
    
    % rename task
    if strcmp(rawtask,'faceA')
        bidstask = 'socialdoors';
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

