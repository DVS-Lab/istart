clear all
close all
clc

%% Behavioral Data analysis

% 01/16/2022
% Daniel Sazhin

% This script takes a participant's responses and collapses them into a
% dollar amount for analysis.

% This script is to deal with two subjects with different input folders.

% Update the subjects list with up-to-date subjects

maindir = 'C:\Users\danie\Documents\Github\istart\UGDG'; % set on computer doing the analysis

%subjects = [1002, 1004, 1006, 1007, 1009, 1010, 1011, 1012, 1013, 1015, 1016, 1019, 1021, 1240, 1242, 1243, 1244, 1245, 1247, 1248, 1249, 1251, 1253, 1255, 1276, 1282, 1286, 1294, 1300, 1301, 1302, 1303, 3101, 3116, 3122, 3125, 3140, 3143, 3152, 3164, 3166, 3167, 3170, 3173, 3175, 3176, 3189, 3190, 3200, 3212];
%subjects = [1002, 1004, 1006, 1007, 1009, 1011, 1012, 1013, 1015, 1016, 1019, 1021, 1242, 1243, 1245, 1247, 1249, 1251, 1276, 1282, 1294, 1300, 1301, 1302, 1303, 3116, 3122, 3140, 3143, 3164, 3170, 3173, 3175, 3176, 3189, 3190, 3200];

subjects_debug = [1240,1248]; % These have different column numbers, probably because RAs used psychopy2.

%% Extract data

% I need to parse the data into the separate games.

for ii= 1:length(subjects_debug)
    subj = subjects_debug(ii);
    
    UG_R_accept_2 = [];
    UG_R_reject_2 = [];
    DG_P_2 = [];
    UG_P_2 = [];
    UG_R_accept = [];
    UG_R_reject = [];
    DG_P = [];
    UG_P = [];

    try

r1 = 1; % Run 1
r2 = 1; % Run 2

% Select 1 if you want to use the run. Zero if not.

%% Run 1

if r1 > 0
    
    for r = 0
        
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
        
        Trial = C{1};
        Block = C{8};
        Endowment = C{5};
        response = C{17};
        response = round(response);
        L_Option = C{4};
        R_Option = C{6};
        
    end
    
    
    % Distribute games per responses
    
    % Block 1 = UG Prop
    % Block 2 = DG prop
    % Block 3 = UG Resp
    
    for t = 1:length(Endowment)
        
        if Block(t) == 3
            if response(t) == 2
                if round(L_Option(t)) > 0
                    update = [Trial(t), Endowment(t), L_Option(t)];
                    UG_R_accept = [UG_R_accept; update];
                else
                    update = [Trial(t), Endowment(t), R_Option(t)];
                    UG_R_reject = [UG_R_reject; update];
                end
            end
        end
        
        if Block(t) == 3
            if response(t) == 3
                if round(R_Option(t)) > 0
                    update = [Trial(t), Endowment(t), R_Option(t)];
                    UG_R_accept = [UG_R_accept; update];
                else
                    update = [Trial(t), Endowment(t), L_Option(t)];
                    UG_R_reject = [UG_R_reject; update];
                end
            end
        end
        
        % Block 2 = DG prop
        
        if Block(t) == 2
            if response(t) == 2
                update = [Trial(t), Endowment(t), R_Option(t)];
                DG_P = [DG_P; update];
            end
            if response(t) == 3
                update = [Trial(t), Endowment(t), L_Option(t)];
                DG_P = [DG_P; update];
            end
        end
        
        % Block 1 = UG prop
        
        if Block(t) == 1
            if response(t) == 2
                update = [Trial(t), Endowment(t), R_Option(t)];
                UG_P = [UG_P; update];
            end
            if response(t) == 3
                update = [Trial(t), Endowment(t), L_Option(t)];
                UG_P = [UG_P; update];
            end
        end
        
    end
    
end

%% Run 2

if r2 > 0
    for r = 1
        
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
        
        Trial = C{1};
        Block = C{8};
        Endowment = C{5};
        response = C{17};
        response = round(response);
        L_Option = C{4};
        R_Option = C{6};
        
    end
    
    
    % Distribute games per responses
    
    % Block 1 = UG Prop
    % Block 2 = DG prop
    % Block 3 = UG Resp
    
    for t = 1:length(Endowment)
        
        if Block(t) == 3
            if response(t) == 2
                if round(L_Option(t)) > 0
                    update = [Trial(t), Endowment(t), L_Option(t)];
                    UG_R_accept_2 = [UG_R_accept_2; update];
                else
                    update = [Trial(t), Endowment(t), R_Option(t)];
                    UG_R_reject_2 = [UG_R_reject_2; update];
                end
            end
        end
        
        if Block(t) == 3
            if response(t) == 3
                if round(R_Option(t)) > 0
                    update = [Trial(t), Endowment(t), R_Option(t)];
                    UG_R_accept_2 = [UG_R_accept_2; update];
                else
                    update = [Trial(t), Endowment(t), L_Option(t)];
                    UG_R_reject_2 = [UG_R_reject_2; update];
                end
            end
        end
        
        % Block 2 = DG prop
        
        if Block(t) == 2
            if response(t) == 2
                update = [Trial(t), Endowment(t), L_Option(t)];
                DG_P_2 = [DG_P_2; update];
            end
            if response(t) == 3
                update = [Trial(t), Endowment(t), R_Option(t)];
                DG_P_2 = [DG_P_2; update];
            end
        end
        
        % Block 1 = UG prop
        
        if Block(t) == 1
            if response(t) == 2
                update = [Trial(t), Endowment(t), L_Option(t)];
                UG_P_2 = [UG_P_2; update];
            end
            if response(t) == 3
                update = [Trial(t), Endowment(t), R_Option(t)];
                UG_P_2 = [UG_P_2; update];
            end
        end
        
    end
    
end


%% DG Earnings

% DG_P is easy... simply subtract endowment from offer.

for ii = 1
    
    try
        
        a = size(DG_P);
        b = size(DG_P_2);
        a = a(1);
        b = b(1);
          
 
    if a>0 || b==0
        
        DG_P_Earnings = sum(DG_P(:,2) - DG_P(:,3));
    end
    
    if b>0 || a==0
        
        DG_P_Earnings = sum(DG_P_2(:,2) - DG_P_2(:,3));
        
    end
    
    if a>0 || b>0
        
        DG_P_Earnings = (sum(DG_P(:,2) - DG_P(:,3)) + sum(DG_P_2(:,2) - DG_P_2(:,3)))/2;
         
    end
    end
    
end



%% UG_R Earnings

% UG_R_Earnings is easy... simply add the accept behavior.




for ii = 1
    
    try
        
        a = size(UG_R_accept);
        b = size(UG_R_accept_2);
        a = a(1);
        b = b(1);
          
 
    if a>0 || b==0
        
        UG_R_Earnings = sum(UG_R_accept(:,3));
    end
    
    if b>0 || a==0
        
        UG_R_Earnings = sum(UG_R_accept_2(:,3));
        
    end
    
    if a>0 || b>0
        
        UG_R_Earnings = (sum(UG_R_accept_2(:,3)) + sum(UG_R_accept(:,3)))/2 ;
         
    end
    end
    
end



%% UG_R_Rejection behavior

% Proportion of rejection and acceptances

try
    Accepted = UG_R_accept_2(:,3) ./ UG_R_accept_2(:,2);  
end
try
    Accepted = [Accepted; UG_R_accept(:,3) ./ UG_R_accept(:,2)];
end
try
    Rejected = UG_R_reject_2(:,3) ./ UG_R_reject_2(:,2);
end
try
    Rejected = [Rejected; UG_R_reject(:,3) ./ UG_R_reject(:,2)];
end
    


%% Save

try
    UG_R_Behavior_Accepted = array2table(Accepted(1:end,:),'VariableNames', {'Accept',});
    UG_R_Behavior_Rejected = array2table(Rejected(1:end,:),'VariableNames', {'Reject',});
    name = ['Subject_' num2str(subj) '_accepted.csv'];
    writetable(UG_R_Behavior_Accepted, name); % Save as csv file
    
    name = ['Subject_' num2str(subj) '_rejected.csv'];
    writetable(UG_R_Behavior_Rejected, name); % Save as csv file
    
end

Total = [DG_P_Earnings, UG_R_Earnings];
DG_P_and_UG_R_earnings = array2table(Total(1:end,:),'VariableNames', {'DG_P_Earnings', 'UG_R_Earnings'});
name = ['Subject_' num2str(subj) '_Earnings.csv'];
writetable(DG_P_and_UG_R_earnings , name); % Save as csv file


try 
    
UG_P_Behavior_r1 = array2table(UG_P(1:end,:),'VariableNames', {'Trial','Endowment','Choice',});
name = ['Subject_' num2str(subj) '_UGP.csv'];
writetable(UG_P_Behavior_r1, name); % Save as csv file
end

try 
UG_P_Behavior_r2 = array2table(UG_P_2(1:end,:),'VariableNames', {'Trial','Endowment','Choice',});
name = ['Subject_' num2str(subj) '_UGP2.csv'];
writetable(UG_P_Behavior_r2, name); % Save as csv file
end


%% Save Proposer

raw = [DG_P;DG_P_2];
try 
DG_P_Raw = array2table(raw(1:end,:),'VariableNames', {'Trial','Endowment','Choice',});
name = ['Subject_' num2str(subj) '_DGP.csv'];
writetable(DG_P_Raw, name); % Save as csv file
end

end

end
