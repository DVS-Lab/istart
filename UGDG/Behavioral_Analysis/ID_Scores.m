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
% final_output_audit.xls

% Updated for autism 

currentdir = pwd;

input_substance = 'Composite_Substance.xls';
input_reward = 'Composite_Reward.xls';

input = 'ISTART-ALL-Combined-042122.xlsx'; % input file  %  Use PCA_and_z-score.csv for reward
motion_input = 'motion_data_input.xls';
output_path = [currentdir '/covariates/'];
strat_input = [currentdir '/output/'];

% Strategic Behavior requires using "behavioral_analysis.m script" and "behavioral_analysis_debug" to
% generate input files for Dictator and Ultimatum game decisions. 

make_full = 0; % Reads in all subjects (also autism). Outputs subs, ones, strategic behavior, tsnr, fd means.
make_reward = 0; % Reads in subjects with PCA composite BIS/SR scores. Outputs subs, ones, strategic behavior, Composite_Reward, tsnr, fd means.
make_substance = 0; % Reads in subjects with AUDIT/DUDIT scores. Outputs subs, ones, strategic behavior, audit, dudit, tsnr, fd means. 
make_attitudes = 1; % Reads in subjects with TEIQUE/PNR scores. Outputs subs, ones, strategic behavior, TEIQUE, PNR, tsnr, fd means. 

run_cov = 0; % To make a covariance matrix of all IDs, use "make_attitudes", use the second set of subjects in make attitudes, and uncomment "make_attitudes" for reward and substance inputs.
%% Subs for SANS

% This was a limited pool of subjects used for analysis for the SANS poster
% in January. Left in case need to compare results.

% subjects = [1006, 1007, 1009, 1011, 1012, 1013, 1015, 1016, 1019, 1021, 1240, 1242, 1245, 1247, 1248, 1249, 1251, 1276, 1282, 1294, 1300, 1301, 1302, 1303, 3116, 3122, 3140, 3143, 3164, 3170, 3173, 3175, 3176, 3189, 3190, 3200, 3212];

%% Subs for full subject N, strat behavior, and motion.

% This is the full pool of subjects. 

% 1002 and 1243 excluded for now (failed preprocessing) 

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
%% Subjects for AUDIT/DUDIT (substance use)

%03/19/22: Eliminate DUDIT for analysis. 1251 and 3143 put back in for
% AUDIT.

% Missing subjects: 

% AUDIT_missing =
% 
%        
%         1007
%         1013

% DUDIT_missing =
% 
%         1251
% 
% AUDIT_missing =
% 
%         3140
%         3170

% 3143 is a DUDIT outlier (for no_outlier file only).

if make_substance == 1
    
    subjects = [1003, 1006, 1009, 1010, 1011, 1012, 1015, 1016, 1019, 1021, 1242, 1244, 1245, 1247, 1248, 1249, 1251, 1253, 1255, 1276, 1282, 1286, 1294, 1300, 1301, 1302, 1303, 3101, 3116, 3122, 3125, 3143, 3152, 3164, 3166, 3167, 3173, 3175, 3176, 3189, 3190, 3199, 3200, 3206, 3210, 3212, 3220];
    
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
  % subjects = [1003, 1006, 1009, 1010, 1011, 1012, 1015, 1016, 1019, 1021, 1242, 1245, 1247, 1248, 1249, 1251, 1276, 1282, 1294, 1300, 1301, 1302, 1303, 3116, 3122, 3143, 3152, 3164, 3166, 3167, 3173, 3175, 3176, 3189, 3190, 3199, 3200, 3206, 3210, 3212, 3220];

end

% for cov assessment:

%         1007
%         1013
%         3140
%         3170

%% Read in Gender

data = readtable(input);

Gender_raw = [data.('ID'), data.('gender_f')];
 
% Eliminate Nans

eliminate_rows = any(isnan(Gender_raw),2);
Gender_temp = [];

for ii = 1:length(Gender_raw)
    keep = [];
    row = Gender_raw(ii,:);
    if eliminate_rows(ii) == 0
        keep = row;
    end
    Gender_temp = [Gender_temp; keep];
end

Gender_missing = [];
Gender_final = [];
for ii = 1:length(subjects)
    subj = subjects(ii);
    subj_row = find(Gender_temp==subj);
    if subj_row > 0
        test = Gender_temp(subj_row,:);
        if test(2) < 100
            Gender_final = [Gender_final;test];
        else
            Gender_missing = [Gender_missing; subjects(ii)];
        end
    end
    
end

Gender_final_output = array2table(Gender_final(1:end,:),'VariableNames', {'Subject', 'Gender'});

%% Read in EI and PNR from other file

if make_attitudes == 1

data = readtable(input);

TEIQUE_raw = [data.('ID'), data.('score_tei_globaltrait')];
PNR_raw = [data.('ID'), data.('pnr_q1') + data.('pnr_q2') + data.('pnr_q3') + data.('pnr_q4') + data.('pnr_q5') + data.('pnr_q6') + data.('pnr_q7') + data.('pnr_q8') + data.('pnr_q9')];
AQ_raw = [data.('ID'), data.('score_aq_total')];

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

end

%% Autism data

if make_full == 1
%if make_attitudes == 1 % only if assessing covariance

    
    data = readtable(input);
    
    AQ_raw = [data.('ID'), data.('score_aq_total')];
    eliminate_rows = any(isnan(AQ_raw),2);
    AQ_temp = [];
    
    for ii = 1:length(AQ_raw)
        keep = [];
        row = AQ_raw(ii,:);
        if eliminate_rows(ii) == 0
            keep = row;
        end
        AQ_temp = [AQ_temp; keep];
    end
    
    AQ_missing = [];
    AQ_final = [];
    
    for ii = 1:length(subjects)
        subj = subjects(ii);
        subj_row = find(AQ_temp==subj);
        if subj_row > 0
            test = AQ_temp(subj_row,:);
            if test(2) < 100
                AQ_final = [AQ_final;test];
            else
                AQ_missing = [AQ_missing; subjects(ii)];
            end
        end
    end
        demeaned_AQ_Output = AQ_final(:,2) - mean(AQ_final(:,2));
        AQ_final = [AQ_final(:,1), demeaned_AQ_Output];
        AQ_final_output = array2table(AQ_final(1:end,:),'VariableNames', {'Subject', 'AQ'});
end
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
        name = [strat_input 'Subject_' num2str(subjects(ii)) '_DGP.csv'];
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
    
    name = [strat_input 'Subject_' num2str(subjects(jj)) '_UGP.csv'];
    
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
    
    name = [strat_input 'Subject_' num2str(subjects(jj)) '_UGP2.csv'];
    
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

demeaned_Strategic_Behavior_output = array2table(demeaned_Strategic_Behavior(1:end,:),'VariableNames', {'Strategic_Behavior'});

%% Read in AUDIT and DUDIT scores (substance use)

if make_substance == 1
   
    
data = readtable(input);

AUDIT_raw = [data.('ID'), data.('audit_1') + data.('audit_2') + data.('audit_3') + data.('audit_4') + data.('audit_5') + data.('audit_6') + data.('audit_7') + data.('audit_8') + data.('audit_9') + data.('audit_10')];
DUDIT_raw = [data.('ID'), data.('dudit_1')+ data.('dudit_2')+ data.('dudit_3')+ data.('dudit_4') + data.('dudit_5') + data.('dudit_6')+ data.('dudit_7')+ data.('dudit_8')+ data.('dudit_9') + data.('dudit_10') + data.('dudit_11')];

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

end 
%% Read in Reward Scores

if make_reward ==1
    
% if make_attitudes== 1 % only for covariance assessment
    
data = readtable(input_reward);

Reward_raw = [data.('ID'), data.('Composite_Reward', data.('Composite_Reward_Squared')];

% % Eliminate duplicates
%  
% Reward_missing = [];
% Reward_final = [];
% Reward_use = Reward_raw(:,2:end);
% bis_bas_subs = [];
% 
% for ii = 1:length(subjects)
%     save = [];
%     save2 = [];
%     subj = subjects(ii);
%     subj_row = find(data.('ID')==subj);
%     
%     save = Reward_use(subj_row,:);
%     Reward_final = [Reward_final; save];
% end
% 
% Reward_final = Reward_final(:) - mean(Reward_final);
Reward_Output = array2table(Reward_final(1:end,:),'VariableNames', {'Composite_Reward', 'Composite_Reward_Squared'});

end

%% Combine outputs into single ID assessment

% full output for full Ns
[N,M] = size(motion_data_output);
A(1:N,1) = ones; % subject number

ones_output = array2table(A(1:end,:),'VariableNames', {'Ones'});
name = ('ones.xls');
writetable(ones_output, name); % Save as csv file

if make_full == 1

final_output = [motion_data_output(:,'Subject'), ones_output(:,'Ones'), demeaned_Strategic_Behavior_output(:,'Strategic_Behavior'), motion_data_output(:,'tsnr'), motion_data_output(:,'fd_mean')];

dest_path = [output_path, 'final_output_full.xls'];
[L] = isfile(dest_path);
if L == 1
    delete(dest_path)
end

name = ['final_output_full.xls'];
fileoutput = [output_path, name];
writetable(final_output, fileoutput); % Save as csv file

end

if make_full == 1

final_output = [motion_data_output(:,'Subject'), ones_output(:,'Ones'), demeaned_Strategic_Behavior_output(:,'Strategic_Behavior'), AQ_final_output(:,'AQ'), motion_data_output(:,'tsnr'), motion_data_output(:,'fd_mean')];

dest_path = [output_path, 'final_output_autism.xls'];
[L] = isfile(dest_path);
if L == 1
    delete(dest_path)
end

name = ['final_output_autism.xls'];
fileoutput = [output_path, name];
writetable(final_output, fileoutput); % Save as csv file

end

%% EI/PNR output

if make_attitudes == 1

final_output_attitudes = [motion_data_output(:,'Subject'), ones_output(:,'Ones'), TEIQUE_final_output(:,'TEIQUE'), PNR_final_output(:,'PNR'), demeaned_Strategic_Behavior_output(:,'Strategic_Behavior'), motion_data_output(:,'tsnr'), motion_data_output(:,'fd_mean')];

dest_path = [output_path, 'final_output_attitudes.xls'];
[L] = isfile(dest_path);
if L == 1
    delete(dest_path)
end

name = ['final_output_attitudes.xls'];
fileoutput = [output_path, name];
writetable(final_output_attitudes, fileoutput); % Save as csv file

end

%% Substance use output

% Eliminating DUDIT for now (03/19/22)

if make_substance == 1

    % DUDIT_final(:,'dudit')
final_output_substance = [motion_data_output(:,'Subject'), ones_output(:,'Ones'), demeaned_Strategic_Behavior_output(:,'Strategic_Behavior'), AUDIT_final(:,'audit'), motion_data_output(:,'tsnr'), motion_data_output(:,'fd_mean')];

dest_path = [output_path, 'final_output_substance_AUDIT.xls'];
[L] = isfile(dest_path);
if L == 1
    delete(dest_path)
end

name = ['final_output_substance_AUDIT.xls'];
fileoutput = [output_path, name];
writetable(final_output_substance, fileoutput); % Save as csv file

end

%% Reward output

if make_reward == 1

final_output_reward = [motion_data_output(:,'Subject'), ones_output(:,'Ones'), demeaned_Strategic_Behavior_output(:,'Strategic_Behavior'), Reward_Output(:,'Composite_Reward'), motion_data_output(:,'tsnr'), motion_data_output(:,'fd_mean')];

dest_path = [output_path, 'final_output_reward.xls'];
[L] = isfile(dest_path);
if L == 1
    delete(dest_path)
end

name = ('final_output_reward.xls');
fileoutput = [output_path, name];
writetable(final_output_reward, fileoutput); % Save as csv file

end

    
%% Covariate assessment

% Use limited subject base (ATTITUDES)

% Run all subjects.

% Run covariance across all ID measures. 

if run_cov == 1
    
all_IDs = [demeaned_Strategic_Behavior_output(:,'Strategic_Behavior'), AUDIT_final(:,'audit'), TEIQUE_final_output(:,'TEIQUE'), PNR_final_output(:,'PNR'), AQ_final_output(:,'AQ'), Reward_Output(:,'Composite_Reward'), motion_data_output(:,'tsnr'), motion_data_output(:,'fd_mean')];
cormat = table2array(all_IDs);
[R,P] = corrcoef(cormat)

figure

imagesc(R); % Display correlation matrix as an image
set(gca, 'XTick', 1:8); % center x-axis ticks on bins
set(gca, 'YTick', 1:8); % center y-axis ticks on bins
set(gca, 'XTickLabel', {'Strat', 'Audit', 'EI', 'PNR', 'AQ', 'Reward', 'Tsnr', 'Fd'}); % set x-axis labels
set(gca, 'YTickLabel', {'Strat', 'Audit', 'EI', 'PNR', 'AQ', 'Reward', 'Tsnr', 'Fd'}); % set y-axis labels
title('Correlation Matrix of IDs in UGDG', 'FontSize', 10); % set title
colormap('GRAY'); % Choose jet or any other color scheme

end
