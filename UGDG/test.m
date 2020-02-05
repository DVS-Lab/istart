maindir = pwd;

%try

for r = 0:1
    
    % sub-101_task-ultimatum_run-0_raw.csv sub-102_task-ultimatum_run-1_raw.csv
    fname = fullfile(maindir,'logs',num2str(subj),sprintf('sub-%04d_task-ultimatum_run-%d_raw.csv',subj,r)); % Psychopy taken out from Logs to make work for now.
    if exist(fname,'file')
        fid = fopen(fname,'r');
    else
        fprintf('sub-%d -- Let''s Make a Deal Game, Run %d: No data found.\n', subj, r+1)
        continue;
    end
    C = textscan(fid,repmat('%f',1,23),'Delimiter',',','HeaderLines',1,'EmptyValue', NaN);
    fclose(fid);
    
    
    % "Feedback" is the offer value (out of $20)
    
    decision_onset = C{16};
    endowment_onset = C{12};
    endowment_offset = C{13};
    onset = C{11};
    RT = C{18};
    duration = C{21};
    Block = C{3};
    Endowment = C{4};
    response = C{17};
    response = round(response);
    L_Option = C{7};
    R_Option = C{8};
    
end