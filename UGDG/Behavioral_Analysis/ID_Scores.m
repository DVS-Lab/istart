clear all
close all
clc

% Daniel Sazhin
% ISTART
% 12/09/21
% DVS Lab
% Temple University

% Use istart/UGDG/Behavioral_Analysis as your working directory.

% Calculate covariates of interest for the ISTART project to use in L3
% analysis in FSL. 

% Outputs csv files into covariates folder: 

% final_output_full.xls
% final_output_reward.xls
% final_output_substance.xls
% final_output_attitudes.xls

input = 'ISTART_CombinedDataSpreadsheet_031122.csv'; % input file 
motion_input = 'motion_data_input.xls';

output_path = 'C:\Users\danie\Documents\Github\istart\UGDG\Behavioral_Analysis\covariates\';

% Strategic Behavior requires using "behavioral_analysis.m script" and "behavioral_analysis_debug" to
% generate input files for Dictator and Ultimatum game decisions. 

make_full = 0; % Reads in all subjects. Outputs subs, ones, strategic behavior, tsnr, fd means.
make_reward = 1; % Reads in subjects with BAS and SPSRQ scores. Outputs subs, ones, strategic behavior, BAS, SPRSRQ, tsnr, fd means.
make_substance = 0; % Reads in subjects with AUDIT/DUDIT scores. Outputs subs, ones, strategic behavior, audit, dudit, tsnr, fd means. 
make_attitudes = 0; % Reads in subjects with TEIQUE/PNR scores. Outputs subs, ones, strategic behavior, TEIQUE, PNR, tsnr, fd means. 

%% Subs for SANS

% This was a limited pool of subjects used for analysis for the SANS poster
% in January. Left in case need to compare results.

% subjects = [1006, 1007, 1009, 1011, 1012, 1013, 1015, 1016, 1019, 1021, 1240, 1242, 1245, 1247, 1248, 1249, 1251, 1276, 1282, 1294, 1300, 1301, 1302, 1303, 3116, 3122, 3140, 3143, 3164, 3170, 3173, 3175, 3176, 3189, 3190, 3200, 3212];

%% Subs for full subject N, strat behavior, and motion.

% This is the full pool of subjects. 

% 1002 and 1243 excluded for now. 

if make_full == 1
    subjects = [1003, 1006, 1007, 1009, 1010, 1011, 1012, 1013, 1015, 1016, 1019, 1021, 1242, 1244, 1245, 1247, 1248, 1249, 1251, 1253, 1255, 1276, 1282, 1286, 1294, 1300, 1301, 1302, 1303, 3101, 3116, 3122, 3125, 3140, 3143, 3152, 3164, 3166, 3167, 3170, 3173, 3175, 3176, 3189, 3190, 3199, 3200, 3206, 3210, 3212, 3220];
end

%% Subs for reward


% Reward_missing =
% 
%         1242          40        -999

if make_reward == 1
    subjects = [1003, 1006, 1007, 1009, 1010, 1011, 1012, 1013, 1015, 1016, 1019, 1021, 1244, 1245, 1247, 1248, 1249, 1251, 1253, 1255, 1276, 1282, 1286, 1294, 1300, 1301, 1302, 1303, 3101, 3116, 3122, 3125, 3140, 3143, 3152, 3164, 3166, 3167, 3170, 3173, 3175, 3176, 3189, 3190, 3199, 3200, 3206, 3210, 3212, 3220];
end
%% Subjects for AUDIT/DUDIT

% Missing subjects: 

% AUDIT_missing =
% 
%         1003
%         1007
%         1013

% Nans: 

% DUDIT_missing =
% 
%         1251
% 
% AUDIT_missing =
% 
%         3140
%         3170

if make_substance == 1
    
    subjects = [1006, 1009, 1010, 1011, 1012, 1015, 1016, 1019, 1021, 1242, 1244, 1245, 1247, 1248, 1249, 1253, 1255, 1276, 1282, 1286, 1294, 1300, 1301, 1302, 1303, 3101, 3116, 3122, 3125, 3143, 3152, 3164, 3166, 3167, 3173, 3175, 3176, 3189, 3190, 3199, 3200, 3206, 3210, 3212, 3220];
    
end
%% Subjects for TEIQUE/PNR

% Missing data: 

% TEIQUE_missing =
% 
%         1244
%         1253
%         1255
%         1286
%         3101
%         3125

if make_attitudes == 1
    subjects = [1003, 1006, 1007, 1009, 1010, 1011, 1012, 1013, 1015, 1016, 1019, 1021, 1242, 1245, 1247, 1248, 1249, 1251, 1276, 1282, 1294, 1300, 1301, 1302, 1303, 3116, 3122, 3140, 3143, 3152, 3164, 3166, 3167, 3170, 3173, 3175, 3176, 3189, 3190, 3199, 3200, 3206, 3210, 3212, 3220];
end
%% Read in EI and PNR from other file

data = readtable(input);

TEIQUE_raw = [data.('participant_id'), data.('score_tei_globaltrait')];
PNR_raw = [data.('participant_id'), data.('score_pnr_total')];

% Eliminate Nans

eliminate_rows = any(isnan(TEIQUE_raw),2);
TEIQUE_temp = [];

for ii = 1:length(TEIQUE_raw)
    keep = [];
    row = TEIQUE_raw(ii,:);
    if eliminate_rows(ii) == 0
        keep = row;
    end
    TEIQUE_temp = [TEIQUE_temp; keep];
end

eliminate_rows = any(isnan(PNR_raw),2);
PNR_temp = [];

for ii = 1:length(PNR_raw)
    keep = [];
    row = PNR_raw(ii,:);
    if eliminate_rows(ii) == 0
        keep = row;
    end
    PNR_temp = [PNR_temp; keep];
end
 
TEIQUE_missing = [];
TEIQUE_final = [];
for ii = 1:length(subjects)
    subj = subjects(ii);
    subj_row = find(TEIQUE_temp==subj);
    if subj_row > 0
        test = TEIQUE_temp(subj_row,:);
        if test(2) < 100
            TEIQUE_final = [TEIQUE_final;test];
        else
            TEIQUE_missing = [TEIQUE_missing; subjects(ii)];
        end
    end
    
end

PNR_missing = [];
PNR_final = [];

for ii = 1:length(subjects)
    subj = subjects(ii);
    subj_row = find(PNR_temp==subj);
    if subj_row > 0
        test = PNR_temp(subj_row,:);
        if test(2) < 100
            PNR_final = [PNR_final;test];
        else
            PNR_missing = [PNR_missing; subjects(ii)];
        end
    end
    
end
    

% Demean TEIQUE and PNR

demeaned_TEIQUE_Output = TEIQUE_final(:,2) - mean(TEIQUE_final(:,2));
TEIQUE_final = [TEIQUE_final(:,1), demeaned_TEIQUE_Output]; 

demeaned_PNR_Output = PNR_final(:,2) - mean(PNR_final(:,2));
PNR_final = [PNR_final(:,1), demeaned_PNR_Output]; 

TEIQUE_final_output = array2table(TEIQUE_final(1:end,:),'VariableNames', {'Subject', 'TEIQUE'});
PNR_final_output = array2table(PNR_final(1:end,:),'VariableNames', {'Subject', 'PNR'});

%% Read in the tsr and means 

% Find the columns you will need.

data = readtable(motion_input);
data = table2array(data);

motion_data = [];

% tsnr is second column. motion is third column

for ii = 1:length(subjects)
    subj = subjects(ii);
    subj_row = find(data==subj);
    save = data(subj_row,:);
    motion_data = [motion_data;save];
end

motion_data_output = array2table(motion_data(1:end,:),'VariableNames', {'Subject', 'tsnr', 'fd_mean'});

%% Strategic Behavior 

% First figure out raw values, then combine into strategic behavior

% Raw DG needs to be average to account for missed/irregular number of
% trials. 

DG_P_Raw = [];

for ii = 1:length(subjects)
        save_value = [];
        name = ['Subject_' num2str(subjects(ii)) '_DGP.csv'];
        O = readtable(name);
        O = table2array(O);
        save_value = mean(O(:,3));
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
    save_value = mean(UG_P(:,3));
    UG_P_Raw = [UG_P_Raw; save_value];
    UG_P_Raw = abs(UG_P_Raw);
    
end

UG_P_2_Raw = [];

for jj = 1:length(subjects)
    save_value = [];
    
    name = ['Subject_' num2str(subjects(jj)) '_UGP2.csv'];
    
    T = readtable(name);
    UG_P_2 = table2array(T);
    save_value = mean(UG_P_2(:,3));
    UG_P_2_Raw = [UG_P_2_Raw; save_value];
    UG_P_2_Raw = abs(UG_P_2_Raw);
    
end

UG_P_Raw_use = ((UG_P_2_Raw + UG_P_Raw)/2);

Strategic_Behavior = UG_P_Raw_use - DG_P_Raw;

% Demean strategic behavior

demeaned_Strategic_Behavior = Strategic_Behavior - mean(Strategic_Behavior);

demeaned_Strategic_Behavior_output = array2table(demeaned_Strategic_Behavior(1:end,:),'VariableNames', {'Strategic Behavior'});

%% Read in AUDIT and DUDIT scores

data = readtable(input);

AUDIT_raw = [data.('participant_id'), data.('audit_1') + data.('audit_2') + data.('audit_3') + data.('audit_4') + data.('audit_5') + data.('audit_6') + data.('audit_7') + data.('audit_8') + data.('audit_9') + data.('audit_10')];
DUDIT_raw = [data.('participant_id'), data.('dudit_1')+ data.('dudit_2')+ data.('dudit_3')+ data.('dudit_4') + data.('dudit_5') + data.('dudit_6')+ data.('dudit_7')+ data.('dudit_8')+ data.('dudit_9') + data.('dudit_10') + data.('dudit_11')];

eliminate_rows = any(isnan(AUDIT_raw),2);
AUDIT_temp = [];
AUDIT_missing = [];
DUDIT_missing = [];

for ii = 1:length(AUDIT_raw)
    keep = [];
    row = AUDIT_raw(ii,:);
    if eliminate_rows(ii) == 0
        keep = row;
        AUDIT_temp = [AUDIT_temp; keep];
    else
        AUDIT_missing = [AUDIT_missing; row(1)];
    end
end

eliminate_rows = any(isnan(DUDIT_raw),2);
DUDIT_temp = [];

for ii = 1:length(DUDIT_raw)
    keep = [];
    row = DUDIT_raw(ii,:);
    if eliminate_rows(ii) == 0
        keep = row;
        DUDIT_temp = [DUDIT_temp; keep];
    else
        DUDIT_missing = [DUDIT_missing; row(1)];
    end
    
end
 
AUDIT_final = [];
for ii = 1:length(subjects)
    subj = subjects(ii);
    subj_row = find(AUDIT_temp==subj);
    if subj_row > 0
        test = AUDIT_temp(subj_row,:);
        if test(2) < 100
            AUDIT_final = [AUDIT_final;test];
        else
            AUDIT_missing = [AUDIT_missing; subjects(ii)];
        end
    end
    
end

DUDIT_final = [];
for ii = 1:length(subjects)
    subj = subjects(ii);
    subj_row = find(DUDIT_temp==subj);
    if subj_row > 0
        test = DUDIT_temp(subj_row,:);
        if test(2) < 100
            DUDIT_final = [DUDIT_final;test];
        else
            DUDIT_missing = [DUDIT_missing; subjects(ii)];
        end
    end
    
end
    
% Demean AUDIT/DUDIT

demeaned_AUDIT_Output = AUDIT_final(:,2) - mean(AUDIT_final(:,2));
AUDIT_final = [AUDIT_final(:,1), demeaned_AUDIT_Output]; 

demeaned_DUDIT_Output = DUDIT_final(:,2) - mean(DUDIT_final(:,2));
DUDIT_final = [DUDIT_final(:,1), demeaned_DUDIT_Output]; 

AUDIT_final = array2table(AUDIT_final(1:end,:),'VariableNames', {'Sub', 'audit'});
DUDIT_final = array2table(DUDIT_final(1:end,:),'VariableNames', {'Sub', 'dudit'});

%% Read in BIS/BAS and SR Scores

data = readtable(input);

Reward_raw = [data.('RealID'), data.('BISBAS_BAS'), data.('SPSRWD')];

% Eliminate duplicates
 
Reward_missing = [];
Reward_final = [];
Reward_use = Reward_raw(:,2:end);
bis_bas_subs = [];

for ii = 1:length(subjects)
    save = [];
    save2 = [];
    subj = subjects(ii);
    subj_row = find(data.('RealID')==subj);
    
    if Reward_use(subj_row,2) > -1 % eliminate the -999s.
        save = Reward_use(subj_row,:);
        save2 = [subj,save];
        Reward_final = [Reward_final;save2];
    else
        save = Reward_use(subj_row,:);
        save2 = [subj,save];
        Reward_missing = [Reward_missing; save2];
    end
end

% Demean reward

demeaned_Reward_Output = Reward_final(:,2:end) - mean(Reward_final(:,2:end));
Reward_Output = [Reward_final(:,1), demeaned_Reward_Output];
Reward_Output = array2table(Reward_Output(1:end,:),'VariableNames', {'Subs','SPSRQ', 'BAS'});

%% Combine outputs into single ID assessment

% full output for full Ns
[N,M] = size(motion_data_output);
A(1:N,1) = ones; % subject number

ones_output = array2table(A(1:end,:),'VariableNames', {'Ones'});
name = ('ones.xls');
writetable(ones_output, name); % Save as csv file

if make_full == 1

final_output = [motion_data_output(:,'Subject'), ones_output(:,'Ones'), demeaned_Strategic_Behavior_output(:,'Strategic Behavior'), motion_data_output(:,'tsnr'), motion_data_output(:,'fd_mean')];

[L] = isfile('final_output_full.xls');
if L == 1
    delete('final_output_full.xls')
end

name = ['final_output_full.xls'];
fileoutput = [output_path, name];
writetable(final_output, fileoutput); % Save as csv file

end

%% EI/PNR output

if make_attitudes == 1

final_output_attitudes = [motion_data_output(:,'Subject'), ones_output(:,'Ones'), TEIQUE_final_output(:,'TEIQUE'), PNR_final_output(:,'PNR'), demeaned_Strategic_Behavior_output(:,'Strategic Behavior'), motion_data_output(:,'tsnr'), motion_data_output(:,'fd_mean')];

[L] = isfile('final_output_attitudes.xls');
if L == 1
    delete('final_output_attitudes.xls')
end

name = ['final_output_attitudes.xls'];
fileoutput = [output_path, name];
writetable(final_output_attitudes, fileoutput); % Save as csv file

end

%% Substance use output

if make_substance == 1

final_output_substance = [motion_data_output(:,'Subject'), ones_output(:,'Ones'), demeaned_Strategic_Behavior_output(:,'Strategic Behavior'), AUDIT_final(:,'audit'), DUDIT_final(:,'dudit') motion_data_output(:,'tsnr'), motion_data_output(:,'fd_mean')];

[L] = isfile('final_output_substance.xls');
if L == 1
    delete('final_output_substance.xls')
end

name = ['final_output_substance.xls'];
fileoutput = [output_path, name];
writetable(final_output_substance, fileoutput); % Save as csv file

end

%% Reward output

if make_reward == 1

final_output_reward = [motion_data_output(:,'Subject'), ones_output(:,'Ones'), demeaned_Strategic_Behavior_output(:,'Strategic Behavior'), Reward_Output(:,'SPSRQ'), Reward_Output(:,'BAS'), motion_data_output(:,'tsnr'), motion_data_output(:,'fd_mean')];

[L] = isfile('final_output_reward.xls');
if L == 1
    delete('final_output_reward.xls')
end

name = ('final_output_reward.xls');
fileoutput = [output_path, name];
writetable(final_output_reward, fileoutput); % Save as csv file

end

    

