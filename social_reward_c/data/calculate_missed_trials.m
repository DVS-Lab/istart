% Script to determine proportion of missed trials for socialdoors
% Prints files to be excluded & missing files in the command window
% Jimmy Wyngaarden, 11 Feb 2022

clear; close all;
maindir = pwd;
warning off all

% Specify subs
subs = [1001, 1002, 1003, 1004, 1006, 1007, 1009, 1010, 1011, 1012, 1013, 1015, 1016, ... 
    1019, 1021, 1240, 1242, 1243, 1244, 1245, 1247, 1248, 1249, 1251, 1253, 1255, 1276, ...
    1282, 1286, 1294, 1300, 1301, 1302, 1303, 3101, 3116, 3122, 3125, 3140, ...
    3143, 3152, 3164, 3166, 3167, 3170, 3173, 3175, 3176, 3186, 3189, 3190, ...
    3199, 3200, 3206, 3210, 3212, 3218, 3220, 3223];

% Create a framework for data_mat--3 columns, sub ID, doors missed, social
% missed
data_mat = zeros(length(subs),3);

% Loop through each subject
for s = 1:length(subs)
    
    % Assign sub ID to first column of data_mat
    data_mat(s,1) = subs(s);
    
    % Loop through monetary then social domains
    task = {'doors', 'socialdoors'};
    for t = 1:length(task)
       
        % Build path for data
        sourcedatadir = fullfile(maindir, num2str(subs(s)));
        sourcedata = fullfile([sourcedatadir '/sub-' num2str(subs(s)) '_task-' task{t} '_run-1_events.tsv']);
        
        % Confirm file exists
        if isfile(sourcedata)
        
            % Read file
            T = readtable(sourcedata,'FileType','delimitedtext');
        
            % Isolate decision phase
            alltrials = T.trial_type == "decision" | T.trial_type == "decision-missed";
            missedtrials = T.trial_type == "decision-missed";
        
               % Calculate proportion of missed trials
            prop_missed = sum(missedtrials)/sum(alltrials);
        
            % Assign missed trials value to data_mat
            if task{t} == "doors"
                data_mat(s,2) = prop_missed;
            else
                data_mat(s,3) = prop_missed;
            end
            
            % Print message for prop missed trials >.20
            if prop_missed > .2
                excl_message = ['Meets exclusion criteria: ', num2str(subs(s)), ' ', task{t}];
                disp(excl_message);
            else
            end
            
        else
            % Print message if file is missing
            missing_message = ['File not found: ', num2str(subs(s)), ' ', task{t}];
            disp(missing_message);
        end
    end
end
