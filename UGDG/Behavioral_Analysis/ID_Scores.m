clear all
close all
clc

% Calculate ID scores of interest for the ISTART project..

% Daniel Sazhin
% ISTART
% 12/09/21
% DVS Lab
% Temple University

%subjects = [1002, 1004, 1006, 1007, 1009, 1010, 1011, 1012, 1013, 1015, 1016, 1019, 1021, 1240, 1242, 1243, 1244, 1245, 1247, 1248, 1249, 1251, 1253, 1255, 1276, 1282, 1286, 1294, 1300, 1301, 1302, 1303, 3101, 3116, 3122, 3125, 3140, 3143, 3152, 3164, 3166, 3167, 3170, 3173, 3175, 3176, 3189, 3190, 3200, 3223];

% main subject list has missing data!!!
% Warning, this creates extra data in the output file. Check for
% duplicates!

% Exclude 1002, 1010 (?), 1243?, 1244 (no IDs), 1253 (No IDs), 1255 (no IDS), 1286 (no IDs), 3101 (no IDs), 3125 (no IDs), 3152 (no IDs), 3166 (?), 3167 (no IDs), 3218 (no IDs), 3220 (no motion),

subjects = [1004, 1006, 1007, 1009, 1011, 1012, 1013, 1015, 1016, 1019, 1021, 1240, 1242, 1245, 1247, 1248, 1249, 1251, 1276, 1282, 1294, 1300, 1301, 1302, 1303, 3116, 3122, 3140, 3143, 3164, 3170, 3173, 3175, 3176, 3189, 3190, 3200, 3212];
%% EQ Scale

% Find the columns you will need.
t = readtable('ISTART_EI_Data_120921.csv');
start = 2;
finish = 31;
N = 30; % Number of questions
IndexedColumns = round(linspace(start,finish, N));

% Extract data
data = table2array(t);
EQ_data = round(data(:,IndexedColumns));


subjEQScore = [];

for ii = 1:length(subjects)
    subject_num = subjects(ii);
    subj_row = find(data==subject_num);
    subj= EQ_data((subj_row),:);
    Save_values = [];
    
    %EQ_data = EQ_data(2:end,:); % Eliminating 1001, which had bad data.
    %Total_Subjects = size(EQ_data);
    %Total_Subjects = Total_Subjects(1);
    
    WellbeingScore = [];
    SelfcontrolScore = [];
    EmotionalityScore = [];
    SociabilityScore = [];
    TotalEQScore = [];
    max_EQ = 7;
    min_EQ = 1;
    add_EQ = max_EQ + min_EQ;
    
    
    
    total = [];
    Save_values = [];
    
    for jj = 1:subj
        EQ1 = subj(1);
        EQ2 = add_EQ+(-1*(subj(2)));% Reverse code
        EQ3 = subj(3);
        EQ4 = add_EQ+(-1*(subj(4)));% Reverse code
        EQ5 = add_EQ+(-1*(subj(5)));% Reverse code
        EQ6 = subj(6);
        EQ7 = add_EQ+(-1*(subj(7)));% Reverse code
        EQ8 = add_EQ+(-1*(subj(8)));% Reverse code
        EQ9 = subj(9);
        EQ10 = add_EQ+(-1*(subj(10)));% Reverse code
        EQ11 = subj(11);
        EQ12 = add_EQ+(-1*(subj(12)));% Reverse code
        EQ13 = add_EQ+(-1*(subj(13)));% Reverse code
        EQ14 = add_EQ+(-1*(subj(14)));% Reverse code
        EQ15 = subj(15);
        EQ16 = add_EQ+(-1*(subj(16)));% Reverse code
        EQ17 = subj(17);
        EQ18 = add_EQ+(-1*(subj(18)));% Reverse code
        EQ19 = subj(19);
        EQ20 = subj(20);
        EQ21 = subj(21);
        EQ22 = add_EQ+(-1*(subj(22)));% Reverse code
        EQ23 = subj(23);
        EQ24 = subj(24);
        EQ25 = add_EQ+(-1*(subj(25)));% Reverse code
        EQ26 = add_EQ+(-1*(subj(26)));% Reverse code
        EQ27 = subj(27);
        EQ28 = add_EQ+(-1*(subj(28)));% Reverse code
        EQ29 = subj(29);
        EQ30 = subj(30);
        
        total = EQ1+EQ2+EQ3+EQ4+EQ5+EQ6+EQ7+EQ8+EQ9+EQ10+EQ11+EQ12+EQ13+EQ14+EQ15+EQ16+EQ17+EQ18+EQ19+EQ20+EQ21+EQ22+EQ23+EQ24+EQ25+EQ26+EQ27+EQ28+EQ29+EQ30;
        
        % Subscales are calculated from Deshawn's code
        
        WS = EQ5 + EQ20 + EQ9 + EQ24 + EQ12 + EQ27;
        WellbeingScore = [WellbeingScore, WS];
        
        SC = EQ4 + EQ19 + EQ7 +EQ22 + EQ15 + EQ30;
        SelfcontrolScore = [SelfcontrolScore, SC];
        
        ES = EQ1 + EQ16 + EQ2 + EQ17 + EQ8 + EQ23 + EQ13 + EQ28;
        EmotionalityScore = [EmotionalityScore, ES];
        
        SS = EQ6 + EQ21 + EQ10 + EQ25 + EQ11 + EQ26;
        SociabilityScore = [SociabilityScore, SS];
        
        Save_values = [subject_num, total];
        
        
        
    end
    subjEQScore = [subjEQScore; Save_values];
end

%% Demean the EQscores

EQaverage = mean(subjEQScore(:,2));

[N,M] = size(subjEQScore);

A(1:N,1) = zeros; % subject number
B(1:N,1) = ones; % subject number
C(1:N,1) = EQaverage;



demeaned_EQscores = [subjEQScore(:,1), B, subjEQScore(:,2) - C];
subjEQScore_output = [subjEQScore(:,1), B, subjEQScore(:,2)];

demeaned_EQscores = array2table(demeaned_EQscores(1:end,:),'VariableNames', {'Subject', 'Ones','Demeaned_EI_Score'});
name = ['demeaned_subjEQScores.xls'];
writetable(demeaned_EQscores, name); % Save as csv file

subjEQScore_output = array2table(subjEQScore_output(1:end,:),'VariableNames', {'Subject', 'Ones','EI Score'});
name = ['subjEQScores.xls'];
writetable(subjEQScore_output, name); % Save as csv file


%% Personal Norm Scale

% Find the columns you will need.
data = readtable('ISTART_PNR_Data_122321.xlsx');
start = 2;
finish = 11;
Total_Subjects = [];


% Extract data
data = table2array(t);
PNR_data = round(data(:,IndexedColumns));

subjPNRScore = [];

for ii = 1:length(subjects)
    subject_num = subjects(ii);
    subj_row = find(data==subject_num);
    subj= PNR_data((subj_row),:);
    Save_values = [];
    
    
    N = 9; % Number of questions
    IndexedColumns = round(linspace(start,finish, N));
    Total_Subjects = size(PNR_data);
    Total_Subjects = Total_Subjects(1);
    
    % PNR Scale
    
    
    Total_Subjects = Total_Subjects;
    max_pnr = 7;
    min_pnr = 1;
    add_pnr = max_pnr + min_pnr;
    
    for jj = 1:subj % ii is the subject
        PNRScore = [];
        a = PNR_data(ii,1);
        b = PNR_data(ii,2);
        c = PNR_data(ii,3);
        d = PNR_data(ii,4);
        e = PNR_data(ii,5);
        f = PNR_data(ii,6);
        g = PNR_data(ii,7);
        h = PNR_data(ii,8);
        i = PNR_data(ii,9);
        total = a+b+c+d+e+f+g+h+i;
        PNRScore = [PNRScore, total];
        
        Save_values = [subject_num, PNRScore];
    end
    
    subjPNRScore = [subjPNRScore; Save_values];
    
end

%% Demean PNR scale

PNRaverage = mean(subjPNRScore(:,2));

[N,M] = size(subjPNRScore);

A(1:N,1) = zeros; % subject number
B(1:N,1) = ones; % subject number
C(1:N,1) = PNRaverage;

demeaned_PNRscores = [subjPNRScore(:,1), B, subjPNRScore(:,2) - C];
subjPNRScore_output = [subjPNRScore(:,1), B, subjPNRScore(:,2)];

demeaned_PNRscores = array2table(demeaned_PNRscores(1:end,:),'VariableNames', {'Subject', 'Ones','Demeaned_PNR_Score'});
name = ['demeaned_subjPNRScores.xls'];
writetable(demeaned_PNRscores, name); % Save as csv file

subjPNRScore_output = array2table(subjPNRScore_output(1:end,:),'VariableNames', {'Subject', 'Ones','PNR_Score'});
name = ['subjPNRScores.xls'];
writetable(subjPNRScore_output, name); % Save as csv file

%% Read in the tsr and means 

% Find the columns you will need.
data = readtable('ugdg_tsr_means.xlsx');
data = table2array(data)

motion_data = [];

% tsnr is second column. motion is third column

for ii = 1:length(subjects)
    subj = subjects(ii);
    subj_row = find(data==subj);
    save = data(subj_row,:);
    motion_data = [motion_data;save];
end

% test

motion_data_output = array2table(motion_data(1:end,:),'VariableNames', {'Subject', 'tsnr','fd_mean'});
name = ['Motionoutput.xls'];
writetable(motion_data_output, name); % Save as csv file
    

%% Strategic Behavior 

% First figure out raw values, then combine into strategic behavior

% Raw DG

DG_P_Raw = [];
save_value = [];

for ii = 1:length(subjects)
    
        name = ['Subject_' num2str(subjects(ii)) '_DGP.csv'];
        O = readtable(name);
        O = table2array(O);
        save_value = sum(O(:,3));
        DG_P_Raw = [DG_P_Raw; save_value]; 
       
end

%% Raw results UG-P

Final_save_2 = [];
UG_P_2 = [];

Final_save = [];
UG_P = [];
UG_P_Total = [];
Subjects = [];
Subjects_2 = [];

UG_P_Raw = [];
Final_Subjects =[];

for jj = 1:length(subjects)
    save_value = [];
    
    name = ['Subject_' num2str(subjects(jj)) '_UGP.csv'];
    
    T = readtable(name);
    UG_P = table2array(T);
    
    total_save_2= [];
    saveme_2 = [];
    save_value = sum(UG_P(:,2) - UG_P(:,3));
    UG_P_Raw = [UG_P_Raw; save_value];
    UG_P_Raw = abs(UG_P_Raw);
    
end

UG_P_2_Raw = [];

for jj = 1:length(subjects)
    save_value = [];
    
    name = ['Subject_' num2str(subjects(jj)) '_UGP2.csv'];
    
    T = readtable(name);
    UG_P_2 = table2array(T);
    save_value = sum(UG_P_2(:,2) - UG_P_2(:,3));
    UG_P_2_Raw = [UG_P_2_Raw; save_value];
    UG_P_2_Raw = abs(UG_P_2_Raw);
    
end

UG_P_Raw = round(((UG_P_2_Raw + UG_P_Raw)/2));

Strategic_Behavior = UG_P_Raw - DG_P_Raw;

% Demean strategic behavior

deameaned_Strategic_Behavior = Strategic_Behavior - mean(Strategic_Behavior);

deameaned_Strategic_Behavior = array2table(deameaned_Strategic_Behavior(1:end,:),'VariableNames', {'Demeaned_strategic_behavior'});
name = ['demeaned_strategic_behavior.xls'];
writetable(deameaned_Strategic_Behavior, name); % Save as csv file

%test
%% Combine outputs into single ID assessment

% combine EI, strategic behavior, PNR, and motion.

final_output = [demeaned_EQscores, deameaned_Strategic_Behavior(:,'Demeaned_strategic_behavior'), demeaned_PNRscores(:,'Demeaned_PNR_Score'), motion_data_output(:,'tsnr'), motion_data_output(:,'fd_mean')]

% final_output = final_output(1:end,:),'VariableNames', {'Subject', 'Ones', 'Demeaned_EI_Score', 'PNR_Deameaned','tsnr','fd_mean'});
name = ['final_IDs.xls'];
writetable(final_output, name); % Save as csv file
    

