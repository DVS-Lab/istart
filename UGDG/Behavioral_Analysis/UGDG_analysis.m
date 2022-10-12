clear all
close all
clc

% This code imports subject earnings (across conditions) and their
% individual difference measures and analyzes the data. 

% Daniel Sazhin
% 12/09/21
% DVS Lab
% Temple University

input_folder = ['C:\Users\tul03789\Documents\GitHub\istart\UGDG\Behavioral_Analysis\output\'];
input_covariates = 'covariates\final_output_composite.xls';
input_behavioral = 'ISTART_CombinedDataSpreadsheet_031722.csv'; % input file  
motion_input = 'motion_data_input.xls';

make_full = 0; % Reads in all subjects. Outputs subs, ones, strategic behavior, tsnr, fd means.
make_reward = 0; % Reads in subjects with BAS and SPSRQ scores. Outputs subs, ones, strategic behavior, BAS, SPRSRQ, tsnr, fd means.
make_substance = 0; % Reads in subjects with AUDIT/DUDIT scores. Outputs subs, ones, strategic behavior, audit, dudit, tsnr, fd means. 
make_attitudes = 1; % Reads in subjects with TEIQUE/PNR scores. Outputs subs, ones, strategic behavior, TEIQUE, PNR, tsnr, fd means. 


%% Subs for SANS

% This was a limited pool of subjects used for analysis for the SANS poster
% in January. Left in case need to compare results.

% subjects = [1006, 1007, 1009, 1011, 1012, 1013, 1015, 1016, 1019, 1021, 1240, 1242, 1245, 1247, 1248, 1249, 1251, 1276, 1282, 1294, 1300, 1301, 1302, 1303, 3116, 3122, 3140, 3143, 3164, 3170, 3173, 3175, 3176, 3189, 3190, 3200, 3212];

%% Subs for full subject N, strat behavior, and motion.

% This is the full pool of subjects. 

% 1002 and 1243 excluded for now (failed preprocessing) 

if make_full == 1
    values = [1003
1004
1006
1009
1010
1011
1012
1013
1015
1016
1019
1021
1242
1243
1244
1245
1247
1248
1249
1251
1253
1255
1276
1282
1286
1294
1300
1301
1302
1303
3101
3116
3122
3125
3140
3143
3152
3164
3166
3167
3170
3173
3175
3176
3189
3190
3199
3200
3206
3210
3212
3218
3220
3223];
end

%% Subs for reward


% Reward_missing =
% 
%         1242          40        -999

if make_reward == 1
    values = [1003
1004
1006
1009
1010
1011
1012
1013
1015
1016
1019
1021
1242
1243
1244
1245
1247
1248
1249
1251
1253
1255
1276
1282
1286
1294
1300
1301
1302
1303
3101
3116
3122
3125
3140
3143
3152
3164
3166
3167
3170
3173
3175
3176
3189
3190
3199
3200
3206
3210
3212
3218
3220
3223
]; end
%% Subjects for AUDIT/DUDIT (substance use)

%03/19/22: Eliminate DUDIT for analysis. 1251 and 3143 put back in for
% AUDIT.

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

% 3143 is a DUDIT outlier (for no_outlier file only).

if make_substance == 1
    
    values = [1006, 1009, 1010, 1011, 1012, 1015, 1016, 1019, 1021, 1242, 1244, 1245, 1247, 1248, 1249, 1251, 1253, 1255, 1276, 1282, 1286, 1294, 1300, 1301, 1302, 1303, 3101, 3116, 3122, 3125, 3143, 3152, 3164, 3166, 3167, 3173, 3175, 3176, 3189, 3190, 3199, 3200, 3206, 3210, 3212, 3220];
    
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
    values = [1003, 1006, 1007, 1009, 1010, 1011, 1012, 1013, 1015, 1016, 1019, 1021, 1242, 1245, 1247, 1248, 1249, 1251, 1276, 1282, 1294, 1300, 1301, 1302, 1303, 3116, 3122, 3140, 3143, 3152, 3164, 3166, 3167, 3170, 3173, 3175, 3176, 3189, 3190, 3199, 3200, 3206, 3210, 3212, 3220];
end

%% Raw DG

subjects = values;
DG_P_Earnings = [];
DG_P_Offers=[];
DG_P_Prop = [];

for ii = 1:length(subjects);
    
    name = ['Subject_' num2str(subjects(ii)) '_DGP.csv'];
    input = [input_folder,name];
    O = readtable(input);
    DG_Part = [];
    for kk = 1:length(O.Trial)
        if O.Decision(kk) == 1
            save = O.More_Prop(kk);
        else
            save = O.Less_Prop(kk);
        end
        DG_Part = [DG_Part; save];
    end
    DG_P_Prop = [DG_P_Prop; mean(DG_Part)];
    DG_P_Offers = [DG_P_Offers; mean(O.Choice)]; % AMOUNT OFFERED!!!
    DG_P_Earnings = [DG_P_Earnings; sum(O.Endowment)-sum(O.Choice)]; % AMOUNT SAVED for self.
    
end

%% Raw results UG-P

Final_save_2 = [];
UG_P_2 = [];

Final_save = [];
UG_P = [];
%UG_P_Total = [];
Subjects = [];
Subjects_2 = [];
UG_P_Offers = [];
UG_P_Offers_2 = [];
UG_P_Earnings  = [];
UG_P_Earnings_2 = [];

subjects = values;
Final_Subjects =[];
UG_P_Prop = [];

for jj = 1:length(subjects)
    save_value = [];
    
    name = ['Subject_' num2str(subjects(jj)) '_UGP.csv'];
    input = [input_folder,name];
    T = readtable(input);
    UG_P_Offers = [UG_P_Offers; mean(T.Choice)]; % AMOUNT OFFERED!!!
    UG_P_Offers_Prop = [UG_P_Offers; mean(T.Choice)];
    
    UG_Part = [];
    
    for kk = 1:length(T.Trial)
        if T.Decision(kk) == 1
            save = T.More_Prop(kk);
        else
            save = T.Less_Prop(kk);
        end
        UG_Part = [UG_Part; save];
        
    end
    UG_P_Prop = [UG_P_Prop; mean(UG_Part)];
    UG_P_Earnings = [UG_P_Earnings; sum(T.Endowment)-sum(T.Choice)]; % AMOUNT SAVED for self, uncorrected for rejections.
  
end

UG_P_Prop_2 = [];

for jj = 1:length(subjects)
    save_value = [];
    name = ['Subject_' num2str(subjects(jj)) '_UGP2.csv'];
    input = [input_folder,name];
    S = readtable(input);
    
    UG_Part = [];
    
    for kk = 1:length(T.Trial)
        if T.Decision(kk) == 1
            save = T.More_Prop(kk);
        else
            save = T.Less_Prop(kk);
        end
        UG_Part = [UG_Part; save];
        
    end
    
    UG_P_Prop_2 = [UG_P_Prop_2; mean(UG_Part)];
    UG_P_Offers_2 = [UG_P_Offers_2;mean(S.Choice)]; % AMOUNT OFFERED!!!
    UG_P_Earnings_2 = [UG_P_Earnings_2; sum(S.Endowment)-sum(S.Choice)]; % AMOUNT SAVED for self, uncorrected for rejections.
    
end

UG_P_Raw_Props = ((UG_P_Prop+UG_P_Prop_2)/2);
UG_P_Raw_Offers = (UG_P_Offers+UG_P_Offers_2/2); % Sum offers
UG_P_Raw_Earnings = UG_P_Earnings + UG_P_Earnings_2; % Uncorrected

%% UG_R earnings

UG_R_Earnings = [];
UG_R_reject = [];
UG_R_accept = [];
missing_subject  = [];
UG_R_reject_rate = [];

for jj = 1:length(subjects)
    
    try
    save_value = [];
    UG_R_reject_rate_part = [];
    name = ['Subject_' num2str(subjects(jj)) '_accept_analysis.csv'];
    input = [input_folder,name];
    U = readtable(input);
    UG_R_Earnings = [UG_R_Earnings; sum(U.Earned)]; % Sum acceptances.
    UG_R_accept = [UG_R_accept; mean(U.Offer./U.Endowment)]; % Average accepted
    
    catch 
        missing_subject = [missing_subject, subjects(jj)];
    end
        
    try
    name = ['Subject_' num2str(subjects(jj)) '_reject_analysis.csv'];
    input = [input_folder,name];
    V = readtable(input);
    
    UG_R_reject = [UG_R_reject; mean(V.Offer./V.Endowment)]; % Average rejected
    UG_R_reject_rate_part = sum(U.Choice)/24; % reject rate
    
    catch
        UG_R_reject_rate_part = 1; % reject rate
        missing_subject = [missing_subject, subjects(jj)];
    end
    
    UG_R_reject_rate = [UG_R_reject_rate;UG_R_reject_rate_part];
end



%% Plot earnings

data = [mean(DG_P_Earnings), mean(UG_P_Raw_Earnings), mean(UG_R_Earnings)]; 
x = linspace(1,3,3);
figure
bar(x,data)
ax = gca;
ax.FontSize = 12;
box off
xlabel ('Tasks', 'FontSize', 16);
ylabel  ('Earnings', 'FontSize', 16);
set(gcf,'color','w');
set(gca, 'XTick', 1:3, 'XTickLabels', {'DG-P', 'UG-P', 'UG-R'})

hold on

% Standard Error

B1Er = std(DG_P_Earnings) / sqrt(length(DG_P_Earnings));
B2Er = std(UG_P_Raw_Earnings) / sqrt(length(UG_P_Raw_Earnings));
B3Er = std(UG_R_Earnings) / sqrt(length(UG_R_Earnings));


err = [B1Er,B2Er,B3Er] * 2;

er = errorbar(x,data,err); 
er.Color = [0 0 0];
er.LineStyle = 'none';
er.LineWidth = 1;
hold off

saveas(gcf,'Bar_Earnings')

%% Plot offers

data = [mean(DG_P_Offers), mean(UG_P_Raw_Offers)]; 
x = linspace(1,2,2);
fig = figure
x1 = bar(x(1),data(1));
x1.LineWidth= 2.5
hold on
x2 = bar(x(2),data(2));
x2.LineWidth= 2.5
colormap('jet')

ax = gca;
ax.FontSize = 12;
box off
xlabel ('Tasks', 'FontSize', 16);
ylabel  ('Average Offers Made Across Subjects', 'FontSize', 16);
set(gcf,'color','w');
set(gca, 'XTick', 1:2, 'XTickLabels', {'DG-P', 'UG-P'})

hold on

% Standard Error

B1Er = std(DG_P_Offers) / sqrt(length(DG_P_Offers));
B2Er = std(UG_P_Raw_Offers) / sqrt(length(UG_P_Raw_Offers));


err = [B1Er,B2Er] * 2;

er = errorbar(x,data,err); 
er.Color = [0 0 0];
er.LineStyle = 'none';
er.LineWidth = 2.5;
hold off

saveas(gcf,'Bar_Offers.tif')

%% Plot proportions chosen

data = [mean(DG_P_Prop), mean(UG_P_Raw_Props)]; 
x = linspace(1,2,2);
fig = figure
x1 = bar(x(1),data(1));
x1.LineWidth= 2.5
hold on
x2 = bar(x(2),data(2));
x2.LineWidth= 2.5
colormap('jet')

ax = gca;
ax.FontSize = 12;
box off
xlabel ('Tasks', 'FontSize', 16);
ylabel  ('Offers', 'FontSize', 16);
title ('Mean Endowment Offered By Participants')
set(gcf,'color','w');
set(gca, 'XTick', 1:2, 'XTickLabels', {'DG-P', 'UG-P'})

hold on

% Standard Error

B1Er = std(DG_P_Prop) / sqrt(length(DG_P_Prop));
B2Er = std(UG_P_Raw_Props) / sqrt(length(UG_P_Raw_Props));


err = [B1Er,B2Er] * 2;

er = errorbar(x,data,err); 
er.Color = [0 0 0];
er.LineStyle = 'none';
er.LineWidth = 2.5;
hold off

saveas(gcf,'Bar_Props.tif')

%% UGR Offers accepted/rejected

data = [mean(UG_R_accept), mean(UG_R_reject)]; 
x = linspace(1,2,2);
fig = figure
x1 = bar(x(1),data(1));
x1.LineWidth= 2.5
hold on
x2 = bar(x(2),data(2));
x2.LineWidth= 2.5
bar(x,data)
ax = gca;
ax.FontSize = 12;
box off
xlabel ('Decisions', 'FontSize', 16);
ylabel  ('Offered Proportion', 'FontSize', 16);
title ('Mean Endowment Accepted/Rejected in UG-R')
set(gcf,'color','w');
set(gca, 'XTick', 1:2, 'XTickLabels', {'Accepted', 'Rejected'})

hold on

% Standard Error

B1Er = std(UG_R_accept) / sqrt(length(UG_R_accept));
B2Er = std(UG_R_reject) / sqrt(length(UG_R_reject));


err = [B1Er,B2Er] * 2;

er = errorbar(x,data,err); 
er.Color = [0 0 0];
er.LineStyle = 'none';
er.LineWidth = 2.5;
hold off

saveas(gcf,'Bar_Props.tif')

%% Strategic Behavior

% We will define this as the difference in offers between UG and DG.

Strategic_Behavior = UG_P_Raw_Props- DG_P_Prop;

Total_Earnings = DG_P_Earnings + UG_P_Raw_Earnings + UG_R_Earnings;
% 
% Total_Earnings = DG_P_Earnings + UG_P_Raw_Earnings + UG_R_Earnings; % Similar to strategic behavior
% 
% figure
% histogram(Total_Earnings, 14)
% ylim('auto');
% ax = gca;
% ax.FontSize = 9;
% xlabel ('Total Earnings','FontSize', 16)
% ylabel ('Frequency','FontSize', 16)
% set(gca,'box','off')
% set(gcf,'color','w');
% 
% 
% saveas(gcf,'Total_Earnings.png')
% 
%% Read in EI and PNR 

if make_attitudes == 1
    
data = readtable(input_behavioral);

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



%% Histogram of EQ scores

figure
h = histogram(TEIQUE_final(:,2));
counts = h.Values;
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;
xlabel ('Emotional Intelligence','FontSize', 16);
ylabel ('Frequency','FontSize', 16);
set(gca,'box','off')
set(gcf,'color','w');

saveas(gcf,'EQ_Scores.png')

%% Histogram of PNR scores

figure
h = histogram(PNR_final(:,2));
counts = h.Values;
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;
xlabel ('Negative Personal Norms of Reciprocity','FontSize', 16);
ylabel ('Frequency','FontSize', 16);
set(gca,'box','off');
set(gcf,'color','w');

saveas(gcf,'PNR_Scores.png')

end

%% Read in Reward Scores

if make_reward == 1

data = readtable(input_covariates);

Composite_Reward = [data.('Composite_Reward')];
Composite_Aberrant_Reward = [data.('Composite_Reward_Squared')];
Composite_Substance = [data.('Composite_Substance')];
SubstanceXReward = [data.('Composite_SubstanceXReward')];
SubstanceXAberrant_Reward = [data.('Composite_SubstanceXReward_Squared')];

end

%% Attitudes analysis

if make_attitudes == 1
    
%% Do people with higher EI reject less often?

% For this analysis, we will take the number of rejections per subject and
% compare if that mean is different across EI.

%% Correlation with EQ and Strategic Behavior

[R,P] = corrcoef(Strategic_Behavior,TEIQUE_final(:,2));

figure
%subplot(2,4,2)
scatter(TEIQUE_final(:,2), Strategic_Behavior)
title 'Strategic Behavior and EQ';
ylabel 'Strategic Behavior';
xlabel 'EQ';


% Hypothesis 

figure
[R,P] = corrcoef(Strategic_Behavior,PNR_final(:,2));

%subplot(2,4,3)
scatter(Strategic_Behavior, PNR_final(:,2));
title 'Proportion and PNR';

%% Histogram of EQ scores

figure
h = histogram(TEIQUE_final(:,2));
counts = h.Values;
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;
xlabel ('Emotional Intelligence','FontSize', 16);
ylabel ('Frequency','FontSize', 16);
set(gca,'box','off')
set(gcf,'color','w');

saveas(gcf,'EQ_Scores.png')

%% Histogram of PNR scores

figure
h = histogram(PNR_final(:,2));
counts = h.Values;
h.NumBins = 12;
ax = gca;
ax.FontSize = 12;
xlabel ('Negative Personal Norms of Reciprocity','FontSize', 16);
ylabel ('Frequency','FontSize', 16);
set(gca,'box','off');
set(gcf,'color','w');

saveas(gcf,'PNR_Scores.png')

end

%% ATTITUDE analysis

if make_attitudes == 1
       
% TEQUIE

[R,P] = corrcoef(DG_P_Prop,TEIQUE_final(:,2))
[R,P] = corrcoef(UG_P_Raw_Props,TEIQUE_final(:,2)) % Significant
[R,P] = corrcoef(UG_R_reject_rate, TEIQUE_final(:,2))
[R,P] = corrcoef(Strategic_Behavior, TEIQUE_final(:,2))
[R,P] = corrcoef(Total_Earnings,TEIQUE_final(:,2))
[R,P] = corrcoef(UG_R_Earnings, TEIQUE_final(:,2))
[R,P] = corrcoef(UG_P_Earnings, TEIQUE_final(:,2))
[R,P] = corrcoef(DG_P_Earnings, TEIQUE_final(:,2))

% PNR
[R,P] = corrcoef(DG_P_Prop,PNR_final(:,2))
[R,P] = corrcoef(UG_P_Raw_Props, PNR_final(:,2)) 
[R,P] = corrcoef(UG_R_reject_rate, PNR_final(:,2))
[R,P] = corrcoef(Strategic_Behavior, PNR_final(:,2))
[R,P] = corrcoef(Total_Earnings, PNR_final(:,2))
[R,P] = corrcoef(UG_R_Earnings, PNR_final(:,2))
[R,P] = corrcoef(UG_P_Earnings, PNR_final(:,2))
[R,P] = corrcoef(DG_P_Earnings, PNR_final(:,2))

figure

scatter(UG_R_Earnings,UG_R_reject_rate, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
ax = gca;
ax.FontSize = 12;
xlabel ('UGR Reject Rate', 'FontSize', 16);
ylabel  ('PNR Score', 'FontSize', 16);
i = lsline;
i.LineWidth = 5;
i.Color = [0 0 0];
set(gcf,'color','w');

saveas(gcf,'DGPEQ.png')

figure

scatter(UG_P_Raw_Props,TEIQUE_final(:,2), 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
ax = gca;
ax.FontSize = 12;
xlabel ('UG-P Proportion of Offers', 'FontSize', 16);
ylabel  ('TEIQUE', 'FontSize', 16);
i = lsline;
i.LineWidth = 5;
i.Color = [0 0 0];
set(gcf,'color','w');

saveas(gcf,'UG Propositions.png')

end

%% Reward analysis

if make_reward == 1

    
% Composite_Reward 
% Composite_Aberrant_Reward 
% Composite_Substance 
% SubstanceXReward 
% SubstanceXAberrant_Reward 

% Composite_Reward 

testme = Composite_Reward; 
[R,P] = corrcoef(DG_P_Prop,testme)
[R,P] = corrcoef(UG_P_Raw_Props,testme) 
[R,P] = corrcoef(UG_R_reject_rate, testme)
[R,P] = corrcoef(Strategic_Behavior, testme)
[R,P] = corrcoef(Total_Earnings,testme)
[R,P] = corrcoef(UG_R_Earnings, testme)
[R,P] = corrcoef(UG_P_Earnings, testme)
[R,P] = corrcoef(DG_P_Earnings, testme)

testme = Composite_Aberrant_Reward; 
[R,P] = corrcoef(DG_P_Prop,testme)
[R,P] = corrcoef(UG_P_Raw_Props,testme) 
[R,P] = corrcoef(UG_R_reject_rate, testme)
[R,P] = corrcoef(Strategic_Behavior, testme)
[R,P] = corrcoef(Total_Earnings,testme)
[R,P] = corrcoef(UG_R_Earnings, testme)
[R,P] = corrcoef(UG_P_Earnings, testme)
[R,P] = corrcoef(DG_P_Earnings, testme)

testme = Composite_Substance; 
[R,P] = corrcoef(DG_P_Prop,testme)
[R,P] = corrcoef(UG_P_Raw_Props,testme) 
[R,P] = corrcoef(UG_R_reject_rate, testme)
[R,P] = corrcoef(Strategic_Behavior, testme)
[R,P] = corrcoef(Total_Earnings,testme)
[R,P] = corrcoef(UG_R_Earnings, testme)
[R,P] = corrcoef(UG_P_Earnings, testme)
[R,P] = corrcoef(DG_P_Earnings, testme)

testme = SubstanceXReward; 
[R,P] = corrcoef(DG_P_Prop,testme)
[R,P] = corrcoef(UG_P_Raw_Props,testme) 
[R,P] = corrcoef(UG_R_reject_rate, testme)
[R,P] = corrcoef(Strategic_Behavior, testme)
[R,P] = corrcoef(Total_Earnings,testme)
[R,P] = corrcoef(UG_R_Earnings, testme)
[R,P] = corrcoef(UG_P_Earnings, testme)
[R,P] = corrcoef(DG_P_Earnings, testme)

testme = SubstanceXAberrant_Reward; 
[R,P] = corrcoef(DG_P_Prop,testme)
[R,P] = corrcoef(UG_P_Raw_Props,testme) 
[R,P] = corrcoef(UG_R_reject_rate, testme)
[R,P] = corrcoef(Strategic_Behavior, testme)
[R,P] = corrcoef(Total_Earnings,testme)
[R,P] = corrcoef(UG_R_Earnings, testme)
[R,P] = corrcoef(UG_P_Earnings, testme)
[R,P] = corrcoef(DG_P_Earnings, testme)

end

%% Substance analysis

if make_substance == 1
       
% AUDIT

[R,P] = corrcoef(DG_P_Prop,AUDIT_final(:,2))
[R,P] = corrcoef(UG_P_Raw_Props,AUDIT_final(:,2)) 
[R,P] = corrcoef(UG_R_reject_rate, AUDIT_final(:,2))
[R,P] = corrcoef(Strategic_Behavior, AUDIT_final(:,2))
[R,P] = corrcoef(Total_Earnings,AUDIT_final(:,2))
[R,P] = corrcoef(UG_R_Earnings, AUDIT_final(:,2))
[R,P] = corrcoef(UG_P_Earnings, AUDIT_final(:,2))
[R,P] = corrcoef(DG_P_Earnings, AUDIT_final(:,2))


% DUDIT

% [R,P] = corrcoef(DG_P,DUDIT_final(:,2))
% [R,P] = corrcoef(UG_P_Raw,DUDIT_final(:,2))
% [R,P] = corrcoef(UG_P_Total,DUDIT_final(:,2))
% [R,P] = corrcoef(UG_R_Earnings,DUDIT_final(:,2))
% [R,P] = corrcoef(UG_Reject_Rate,DUDIT_final(:,2))
% [R,P] = corrcoef(Strategic_Behavior,DUDIT_final(:,2))

end

%% How often do participants reject offers?

figure

h = histogram(UG_R_reject_rate(:));
counts = h.Values;
h.NumBins = 5;
ax = gca;
ax.FontSize = 9;
xlabel ('Rate of Rejections as a Recipient','FontSize', 16);
ylabel ('Frequency','FontSize', 16);
set(gca,'box','off');
set(gcf,'color','w');


%% Do subjects reject unfair offers?

% Collect all the UG-R offers
% Define level of endowment
% Define proportion of endowment offered
% Define decision (1 = accept, 0 = reject)

subject_combined_rejections = [];
missing_reject = [];
subject_combined_acceptances = [];
missing_accept = [];
missing_subject = [];
badsubject = [];
Betas = [];
Pvals = [];
save_X = [];
save_Y = [];
sub_prop = [];
for ii = 1:length(values)
    S = [];
    T = [];
    try
        name = ['Subject_' num2str(values(ii)) '_reject_analysis.csv'];
        input = [input_folder,name];
        T = readtable(input);
        subject_combined_rejections = [subject_combined_rejections;  T.Endowment, T.Prop_Endowment];
    catch
        missing_reject = [missing_reject, values(ii)];
    end
    try
        name = ['Subject_' num2str(values(ii)) '_accept_analysis.csv'];
        input = [input_folder,name];
        S = readtable(input);
        subject_combined_acceptances = [subject_combined_acceptances; S.Endowment, S.Prop_Endowment];
    catch
        missing_accept = [missing_accept, values(ii)];
    end
    try
        subject_UGR = [S;T];
        sub_p = [values(ii), mean(T.Prop_Endowment)];
        sub_prop = [sub_prop; sub_p]; % sub 3125 rejects high P of offers. sub 1294 rejections low P offers
        
        
    catch
        missing_subject = [missing_subject, values(ii)];
    end
    try
        %Y = categorical(subject_UGR.Choice);
        Y = subject_UGR.Choice;
        
    end
    
    X = [subject_UGR.Endowment, subject_UGR.Prop_Endowment];
    X = zscore(X);
    save_X = [save_X; X];
    save_Y = [save_Y; Y];
    try
    %[B,dev,stats] = mnrfit(X, Y); % Given the Endowment, proportion of endowment, can we predict accept/reject?
%     b = glmfit(X,Y,'binomial','link','logit');
%     Betas = [Betas, b];
%     Pvals = [Pvals, stats.p];
    catch
        badsubject = [badsubject,values(ii)];
    end
end


save = [];
dump = [];
%save_Y=categorical(save_Y);
[B,DEV,STATS] = glmfit(save_X,save_Y,'binomial','link','logit'); %mnrfit(save_X,save_Y)
se=STATS.se;

data = [mean(B(1,:));  mean(B(2,:));  mean(B(3,:))];
x = linspace(1,3,3);
figure
bar(x,data)
ax = gca;
ax.FontSize = 12;
box off
xlabel ('Regressors', 'FontSize', 16);
ylabel  ('Z-standardized Beta Weight', 'FontSize', 16);
set(gcf,'color','w');
set(gca, 'XTick', 1:3, 'XTickLabels', {'Intercept', 'Endowment', 'Proportion'});
title('Does Endowment Predict UG-R Accept/Reject Choices?')

hold on

% Standard Error

B1Er = se(1);
B2Er = se(2);
B3Er = se(3);

err = [B1Er,B2Er,B3Er] * 2;

er = errorbar(x,data,err); %errorbar(x,data,errlow,errhigh);
er.Color = [0 0 0];
er.LineStyle = 'none';
er.LineWidth = 1;
hold off

saveas(gcf,'Bar_UGR.png')

%% UGR High/low analysis.

subject_combined_rejections = [];
missing_reject = [];
subject_combined_acceptances = [];
missing_accept = [];
missing_subject = [];
badsubject = [];
Betas = [];
Pvals = [];
save_X = [];
save_Y = [];
sub_prop = [];

subs = [3125] % Subject 1294 ACCEPTS almost all offers.  Subject 3125 REJECTS almost all offers. 
for ii = 1:length(subs)
    S = [];
    T = [];
    try
        name = ['Subject_' num2str(subs(ii)) '_reject_analysis.csv']
        input = [input_folder,name];
        T = readtable(input);
        subject_combined_rejections = [subject_combined_rejections;  ([T.Endowment, T.Prop_Endowment])];
    catch
        missing_reject = [missing_reject, subs(ii)];
    end
    try
        name = ['Subject_' num2str(subs(ii)) '_accept_analysis.csv'];
        input = [input_folder,name];
        S = readtable(input);
        subject_combined_acceptances = [subject_combined_acceptances; S.Endowment, S.Prop_Endowment];
    catch
        missing_accept = [missing_accept, subs(ii)];
    end
    try
        subject_UGR = [S;T];
        sub_p = [subs(ii), mean(T.Prop_Endowment)];
        sub_prop = [sub_prop; sub_p]; % sub 3125 rejects high P of offers. sub 1294 rejections low P offers
        
        
    catch
        missing_subject = [missing_subject, subs(ii)];
    end
    try
        Y = categorical(subject_UGR.Choice);
    end
    
     
    X = [subject_UGR.Endowment, subject_UGR.Prop_Endowment];
    X = zscore(X);
    save_X = [save_X; X];
    save_Y = [save_Y; Y];
    try
    %[B,dev,stats] = mnrfit(X, Y); % Given the Endowment, proportion of endowment, can we predict accept/reject?
%     b = glmfit(X,Y,'binomial','link','logit');
%     Betas = [Betas, b];
%     Pvals = [Pvals, stats.p];
    catch
        badsubject = [badsubject,values(ii)];
    
end
    
   save = [];
   dump = [];
   save_Y=categorical(save_Y);
   %[B,DEV,STATS] = glmfit(X,Y,'binomial','link','logit');
   se=STATS.se;
   
   data = [mean(B(1,:));  mean(B(2,:));  mean(B(3,:))];
   x = linspace(1,3,3);
   figure
   bar(x,data)
   ax = gca;
   ax.FontSize = 12;
   box off
   xlabel ('Regressors', 'FontSize', 16);
   ylabel  ('Z-standardized Beta Weight', 'FontSize', 16);
   set(gcf,'color','w');
   set(gca, 'XTick', 1:3, 'XTickLabels', {'Intercept', 'Endowment', 'Proportion'})
   title('Does Endowment Predict UG-R Accept/Reject Choices?')
   
   hold on
   
   % Standard Error
   
   B1Er = se(1)
   B2Er = se(2)
   B3Er = se(3)
   
   err = [B1Er,B2Er,B3Er] * 2;
   
   er = errorbar(x,data,err); %errorbar(x,data,errlow,errhigh);
   er.Color = [0 0 0];
   er.LineStyle = 'none';
   er.LineWidth = 1;
   hold off
   
   saveas(gcf,'Bar_UGR.png')
    
    [R,P] = corrcoef(subject_UGR.Endowment, subject_UGR.Choice);
    figure
    scatter(subject_UGR.Endowment, subject_UGR.Choice,'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
    ax = gca;
    ax.FontSize = 12;
    title (['Subject ' num2str(subs(ii))])
    xlabel ('Endowment', 'FontSize', 16);
    ylabel  ('Choice', 'FontSize', 16);
    i = lsline;
    i.LineWidth = 5;
    i.Color = [0 0 0];
    set(gcf,'color','w');
    
    [R,P] = corrcoef(subject_UGR.Prop_Endowment, subject_UGR.Choice);
    figure
    scatter(subject_UGR.Prop_Endowment, subject_UGR.Choice,'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
    ax = gca;
    ax.FontSize = 12;
    title (['Subject ' num2str(subs(ii))])
    xlabel ('Proportion', 'FontSize', 16);
    ylabel  ('Choice', 'FontSize', 16);
    i = lsline;
    i.LineWidth = 5;
    i.Color = [0 0 0];
    set(gcf,'color','w');
    
    
end
    
%% DG-P logistic regression

subject_combined_rejections = [];
missing_reject = [];
subject_combined_acceptances = [];
missing_accept = [];
missing_data=[];
badsubject = [];
Betas = [];
Pvals = [];
save_X = [];
save_Y = [];
sub_prop = [];
Cor_Endow_DeltaP=[];
Cor_Endow_Intercept=[];
Cor_DeltaP_Intercept= [];

for ii = 1:length(values)
    S = [];
    T = [];
    try
        name = ['Subject_' num2str(values(ii)) '_DGP.csv'];
        input = [input_folder,name];
        T = readtable(input);
    catch
        missing_data = [missing_data, values(ii)];
    end
    try
        subject_DGP = [T];
        Y = subject_DGP.Decision;
        
    end
    
    %X = [subject_DGP.Endowment,subject_DGP.More_Prop-subject_DGP.Less_Prop,((subject_DGP.More_Prop+subject_DGP.Less_Prop)/2)];
    X = [subject_DGP.Endowment,((subject_DGP.More_Prop+subject_DGP.Less_Prop)/2)];
    X = zscore(X);
    %endowprop = X(:,1).*X(:,2);
    %X = [X, endowprop];
    save_X = [save_X; X];
    save_Y = [save_Y; Y];
    
    [B,DEV,STATS] = glmfit(X,Y,'binomial','link','logit');
    coeff=STATS.coeffcorr;
    Cor_Endow_DeltaP=[Cor_Endow_DeltaP; coeff(2,3)];
    Cor_Endow_Intercept=[Cor_Endow_Intercept; coeff(1,2)];
    Cor_DeltaP_Intercept= [Cor_DeltaP_Intercept; coeff(1,3)];
    

    Betas = [Betas, B];
    
  
end


save = [];
dump = [];
% [B,DEV,STATS] = glmfit(save_X,save_Y,'binomial','link','logit');
%save_Y=categorical(save_Y);
[B,DEV,STATS] = glmfit(save_X,save_Y,'binomial','link','logit');
se=STATS.se;

data = [B(1), B(2), B(3)]; %, B(4), B(5)];
x = linspace(1,3,3);
figure
bar(x,data)
ax = gca;
ax.FontSize = 12;
box off
xlabel ('Regressors', 'FontSize', 16);
ylabel  ('Z-standardized Beta Weight', 'FontSize', 16);
set(gcf,'color','w');
set(gca, 'XTick', 1:3, 'XTickLabels', {'Intercept', 'Endowment', 'Average between offers'})
title('Does Endowment and Offers Predict DG-P More/Less Choices?')

hold on

% Standard Error

B1Er = se(1);
B2Er = se(2);
B3Er = se(3);
%B4Er = se(4);
%B5Er = se(5);

err = [B1Er,B2Er,B3Er] * 2;

er = errorbar(x,data,err); %errorbar(x,data,errlow,errhigh);
er.Color = [0 0 0];
er.LineStyle = 'none';
er.LineWidth = 1;
hold off

saveas(gcf,'Bar_DGP.png')

%% Correlation DGP bar plot.

data = [mean(Cor_Endow_DeltaP), mean(Cor_Endow_Intercept), mean(Cor_DeltaP_Intercept)];
x = linspace(1,3,3);
figure
bar(x,data)
ax = gca;
ax.FontSize = 12;
box off
xlabel ('Regressors', 'FontSize', 16);
ylabel  ('R Values', 'FontSize', 16);
set(gcf,'color','w');
set(gca, 'XTick', 1:3, 'XTickLabels', {'Endowment & DeltaP', 'Endowment & Intercept', 'Delta P & Intercept'})
title('Correlation Between DGP Regressors')

hold on

% Standard Error

B1Er = std(Cor_Endow_DeltaP(:,1)) / sqrt(length((Cor_Endow_DeltaP(:,1))));
B2Er = std(Cor_Endow_Intercept(:,1)) / sqrt(length((Cor_Endow_Intercept(:,1))));
B3Er = std(Cor_DeltaP_Intercept(:,1)) / sqrt(length((Cor_DeltaP_Intercept(:,1))));
%B4Er = se(4);
%B5Er = se(5);

err = [B1Er,B2Er,B3Er] * 2;

er = errorbar(x,data,err); %errorbar(x,data,errlow,errhigh);
er.Color = [0 0 0];
er.LineStyle = 'none';
er.LineWidth = 1;
hold off

saveas(gcf,'Bar_DGP_corrs.png')

%% DGP High/low analysis

subject_combined_rejections = [];
missing_reject = [];
subject_combined_acceptances = [];
missing_accept = [];
missing_subject = [];
badsubject = [];
Betas = [];
Pvals = [];
save_X = [];
save_Y = [];
sub_prop = [];

subs = [1300]; %Subject 1300 chooses More a lot. Subject 3200 chooses less ALL the time. 
for ii = 1:length(subs)
    S = [];
    T = [];
   try
        name = ['Subject_' num2str(subs(ii)) '_DGP.csv'];
        input = [input_folder,name];
        T = readtable(input);
    catch
        missing_data = [missing_data, subs(ii)];
    end
    try
        subject_DGP = [T];
        sub_p = [subs(ii), mean(T.Less_Prop)];
        sub_prop = [sub_prop; sub_p]; % sub 3200 chooses more for greatest average of low offers. sub 1300 chooses more for the lowest average of low offers.
        
        
    catch
        missing_subject = [missing_subject, subs(ii)];
    end
    try
        Y = categorical(subject_DGP.Decision);
    end
    
     
    X = [subject_DGP.Endowment, subject_DGP.More_Prop, subject_DGP.Less_Prop];
    X = zscore(X);
    save_X = [save_X; X];
    save_Y = [save_Y; Y];
%     try
    
    %[B,dev,stats] = mnrfit(X, Y); % Given the Endowment, proportion of endowment, can we predict accept/reject?
    %Betas = [Betas, B];
    %Pvals = [Pvals, stats.p];
%     catch
%         badsubject = [badsubject,values(ii)];
%     
%     end

%[B,dev,stats] = mnrfit(save_X, save_Y); % Given the Endowment, proportion of endowment, can we predict accept/reject?
   %b = glmfit(X,Y,'binomial','link','logit'); 
   save = [];
   dump = [];
   [B,DEV,STATS] = glmfit(save_X,save_Y,'binomial','link','logit');
   se=STATS.se;
   
   data = [B(1),B(2),B(3),B(4)];
   x = linspace(1,4,4);
   figure
   bar(x,data)
   ax = gca;
   ax.FontSize = 12;
   box off
   xlabel ('Regressors', 'FontSize', 16);
   ylabel  ('Z-standardized Beta Weight', 'FontSize', 16);
   set(gcf,'color','w');
   set(gca, 'XTick', 1:4, 'XTickLabels', {'Intercept', 'Endowment', 'More Proportion', 'Less Proportion'})
   title('Does Endowment/Prop Predict DGP Accept/Reject Choices?')
   
   hold on
   
   % Standard Error
   
   B1Er = se(1);
   B2Er = se(2);
   B3Er = se(3);
   B4er = se(4);
   
   err = [B1Er,B2Er,B3Er,B4er] * 2;
   
   er = errorbar(x,data,err); %errorbar(x,data,errlow,errhigh);
   er.Color = [0 0 0];
   er.LineStyle = 'none';
   er.LineWidth = 1;
   hold off
   
   saveas(gcf,'Bar_DGP.png')
    
   
   [R,P] = corrcoef(subject_DGP.Endowment, subject_DGP.Decision);
   figure
   scatter(subject_DGP.Endowment, subject_DGP.Decision,'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
   ax = gca;
   ax.FontSize = 12;
   title (['Subject ' num2str(subs(ii))])
   xlabel ('Endowment', 'FontSize', 16);
   ylabel  ('Choice', 'FontSize', 16);
   i = lsline;
   i.LineWidth = 5;
   i.Color = [0 0 0];
   set(gcf,'color','w');
   
   [R,P] = corrcoef(subject_DGP.Endowment, subject_DGP.Less_Prop);
   figure
   scatter(subject_DGP.Endowment, subject_DGP.Decision,'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
   ax = gca;
   ax.FontSize = 12;
   title (['Subject ' num2str(subs(ii))])
   xlabel ('Less Proportion', 'FontSize', 16);
   ylabel  ('Choice', 'FontSize', 16);
   i = lsline;
   i.LineWidth = 5;
   i.Color = [0 0 0];
   set(gcf,'color','w');
   
end


    

    

% %% UG-P logistic regression
% 
% subject_combined_rejections = [];
% missing_reject = [];
% subject_combined_acceptances = [];
% missing_accept = [];
% missing_data=[];
% badsubject = [];
% Betas = [];
% Pvals = [];
% save_X = [];
% save_Y = [];
% sub_prop = [];
% 
% for ii = 1:length(values)
%     S = [];
%     T = [];
%     try
%         name = ['Subject_' num2str(values(ii)) '_UGP.csv'];
%         input = [input_folder,name];
%         T = readtable(input);
%         
%         name = ['Subject_' num2str(values(ii)) '_UGP_2.csv'];
%         input = [input_folder,name];
%         S = readtable(input);
%         
%     catch
%         missing_data = [missing_data, values(ii)];
%     end
%     try
%         subject_UGP = [S;T];
%         Y = subject_UGP.Decision;
%         
%     end
%     
%     X = [subject_UGP.Endowment, subject_UGP.More_Prop-subject_UGP.Less_Prop];
%     X = zscore(X);
%     save_X = [save_X; X];
%     save_Y = [save_Y; Y];
%     try
%     %[b,dev,stats] = mnrfit(X, Y); % Given the Endowment, proportion of endowment, can we predict accept/reject?
%     %b = glmfit(X,Y,'binomial','link','logit');
%     Betas = [Betas, b];
%     Pvals = [Pvals, stats.p];
%     catch
%         badsubject = [badsubject,values(ii)];
%     end
% end
% 
% 
% save = [];
% dump = [];
% [B,DEV,STATS] = glmfit(save_X,save_Y,'binomial','link','logit');
% se=STATS.se;
% 
% data = [B(1), B(2), B(3)];
% x = linspace(1,3,3);
% figure
% bar(x,data)
% ax = gca;
% ax.FontSize = 12;
% box off
% xlabel ('Regressors', 'FontSize', 16);
% ylabel  ('Z-standardized Beta Weight', 'FontSize', 16);
% set(gcf,'color','w');
% set(gca, 'XTick', 1:3, 'XTickLabels', {'Intercept', 'Endowment', 'Delta P'})
% title('Does Endowment and Offers Predict UG-P More/Less Choices?')
% 
% hold on
% 
% % Standard Error
% 
% B1Er = se(1);
% B2Er = se(2);
% B3Er = se(3);
% %B4Er = se(4);
% 
% err = [B1Er,B2Er,B3Er] * 2;
% 
% er = errorbar(x,data,err); %errorbar(x,data,errlow,errhigh);
% er.Color = [0 0 0];
% er.LineStyle = 'none';
% er.LineWidth = 1;
% hold off
% 
% saveas(gcf,'Bar_UGP.png')

%% UG-P logistic regression

subject_combined_rejections = [];
missing_reject = [];
subject_combined_acceptances = [];
missing_accept = [];
missing_data=[];
badsubject = [];
Betas = [];
Pvals = [];
save_X = [];
save_Y = [];
sub_prop = [];
Cor_Endow_DeltaP=[];
Cor_Endow_Intercept=[];
Cor_DeltaP_Intercept= [];

for ii = 1:length(values)
    S = [];
    T = [];
        try
            name = ['Subject_' num2str(values(ii)) '_UGP.csv'];
            input = [input_folder,name];
            S = readtable(input);
            name = ['Subject_' num2str(values(ii)) '_UGP2.csv'];
            input = [input_folder,name];
            T = readtable(input);
            subject_UGP = [S;T];
         
        catch
            missing_data = [missing_data, values(ii)];
        end

        X = [subject_UGP.Endowment,((subject_UGP.More_Prop+subject_UGP.Less_Prop)/2)];
        X = zscore(X);
        
        Y = subject_UGP.Decision;
        save_X = [save_X; X];
        save_Y = [save_Y; Y];
        
        [B,DEV,STATS] = glmfit(X,Y,'binomial','link','logit');
        coeff=STATS.coeffcorr;
        Cor_Endow_DeltaP=[Cor_Endow_DeltaP; coeff(2,3)];
        Cor_Endow_Intercept=[Cor_Endow_Intercept; coeff(1,2)];
        Cor_DeltaP_Intercept= [Cor_DeltaP_Intercept; coeff(1,3)];
    
end


save = [];
dump = [];
[B,DEV,STATS] = glmfit(save_X,save_Y,'binomial','link','logit');
se=STATS.se;

data = [B(1), B(2), B(3)]; %, B(4), B(5)];
x = linspace(1,3,3);
figure
bar(x,data)
ax = gca;
ax.FontSize = 12;
box off
xlabel ('Regressors', 'FontSize', 16);
ylabel  ('Z-standardized Beta Weight', 'FontSize', 16);
set(gcf,'color','w');
set(gca, 'XTick', 1:3, 'XTickLabels', {'Intercept', 'Endowment', 'Average Offers'})
title('Does Endowment and Offers Predict UG-P More/Less Choices?')

hold on

% Standard Error

B1Er = se(1);
B2Er = se(2);
B3Er = se(3);
%B4Er = se(4);
%B5Er = se(5);

err = [B1Er,B2Er,B3Er] * 2;

er = errorbar(x,data,err); %errorbar(x,data,errlow,errhigh);
er.Color = [0 0 0];
er.LineStyle = 'none';
er.LineWidth = 1;
hold off

saveas(gcf,'Bar_UGP.png')

%% Correlation UGP bar plot.

data = [mean(Cor_Endow_DeltaP), mean(Cor_Endow_Intercept), mean(Cor_DeltaP_Intercept)];
x = linspace(1,3,3);
figure
bar(x,data)
ax = gca;
ax.FontSize = 12;
box off
xlabel ('Regressors', 'FontSize', 16);
ylabel  ('R Values', 'FontSize', 16);
set(gcf,'color','w');
set(gca, 'XTick', 1:3, 'XTickLabels', {'Endowment & DeltaP', 'Endowment & Intercept', 'Delta P & Intercept'})
title('Correlation Between UGP Regressors')

hold on

% Standard Error

B1Er = std(Cor_Endow_DeltaP(:,1)) / sqrt(length((Cor_Endow_DeltaP(:,1))));
B2Er = std(Cor_Endow_Intercept(:,1)) / sqrt(length((Cor_Endow_Intercept(:,1))));
B3Er = std(Cor_DeltaP_Intercept(:,1)) / sqrt(length((Cor_DeltaP_Intercept(:,1))));
%B4Er = se(4);
%B5Er = se(5);

err = [B1Er,B2Er,B3Er] * 2;

er = errorbar(x,data,err); %errorbar(x,data,errlow,errhigh);
er.Color = [0 0 0];
er.LineStyle = 'none';
er.LineWidth = 1;
hold off

saveas(gcf,'Bar_UGP_corrs.png')
    
%% Combine tasks in model.

% Import results.
% Combine into single matrix
% Add +1 for DG and -1 for UG
% Generate interaction effects. 

% Import data:

missing_data=[];
save_X = [];
save_Y = [];
Cor_Endow_DeltaP=[];
Cor_Endow_Intercept=[];
Cor_DeltaP_Intercept= [];
Main_Effects = [];
subject_regressor = [];

for ii = 1:length(values)
    S = [];
    T = [];

        try
            name = ['Subject_' num2str(values(ii)) '_UGP.csv'];
            input = [input_folder,name];
            S = readtable(input);
            name = ['Subject_' num2str(values(ii)) '_UGP2.csv'];
            input = [input_folder,name];
            T = readtable(input);
            subject_UGP=[S;T];
            
            name = ['Subject_' num2str(values(ii)) '_DGP.csv'];
            input = [input_folder,name];
            U = readtable(input);
            subject_DGP = [U];
            
        catch
            missing_data = [missing_data, values(ii)];
        end
        
        % Generate regressors
        
        UG_X = [subject_UGP.Endowment,(subject_UGP.More_Prop-subject_UGP.Less_Prop)]; % Generate endowment and delta P.
        DG_X = [subject_DGP.Endowment,(subject_DGP.More_Prop-subject_DGP.Less_Prop)];
        X = zscore([UG_X;DG_X]); % z scores demeans
        
        % Add Task regressor and Interaction of Task/Endowment, Task/Delta
        % P. DG is 1 and UG is -1.
        
        [N,M]= size(UG_X);
        UG_mat = 0*(ones(N,1)); % UG is coded as 0
        
        [N,M]= size(DG_X);
        DG_mat = ones(N,1); % DG is coded as 0
        
        task_regressor = [UG_mat; DG_mat];
        
        [N,M]= size(task_regressor);
        
        regessor_mat = ones(N,1);
        regessor_mat = regessor_mat*values(ii);

        subject_regressor = [subject_regressor; regessor_mat];
        
        % Generate interaction of task regressor and endowment and delta p.
        
        endow_int = task_regressor.*X(:,1);
        deltaP_int = task_regressor.*X(:,2);
        %mean_int = task_regressor.*X(:,3);
        
        % Concatenate into regressor matrix.
        Main_Effects_part = [task_regressor, X];
        X = [task_regressor, X, endow_int, deltaP_int]; 
        Y = [subject_UGP.Decision;subject_DGP.Decision];
        
        % Loop over all of the participants.
        save_X = [save_X; X];
        save_Y = [save_Y; Y];
        Main_Effects = [Main_Effects; Main_Effects_part];
        
%         % Save correlations of regressors across participants.

%         [B,DEV,STATS] = glmfit(X,Y,'binomial','link','logit');
%         coeff=STATS.coeffcorr;
%         Cor_Endow_DeltaP=[Cor_Endow_DeltaP; coeff(2,3)];
%         Cor_Endow_Intercept=[Cor_Endow_Intercept; coeff(1,2)];
%         Cor_DeltaP_Intercept= [Cor_DeltaP_Intercept; coeff(1,3)];
end


% Run logistic regression.

[B,DEV,STATS] = glmfit(save_X,save_Y,'binomial','link','logit');
%Y=categorical(save_Y)
%[B,dev,stats] = mnrfit(save_X,Y);
se=STATS.se; 
data = [B(1), B(2), B(3), B(4), B(5), B(6)]; % Intercept, Task, Endowment, Delta P, Endow Interaction, Delta P interaction.
x = linspace(1,6,6);
figure
bar(x,data)
ax = gca;
ax.FontSize = 12;
box off
xlabel ('Regressors', 'FontSize', 16);
ylabel  ('Z-standardized Beta Weight', 'FontSize', 16);
set(gcf,'color','w');
set(gca, 'XTick', 1:6, 'XTickLabels', {'Intercept', 'Task', 'Endowment', 'Delta P', 'Task*Endow', 'Task*DeltaP'})
title('Does Endowment and Offers Predict Proposer More/Less Choices?')

hold on

% Standard Error

B1Er = se(1);
B2Er = se(2);
B3Er = se(3);
B4Er = se(4);
B5Er = se(5);
B6Er = se(6);
%B7Er = se(7);
%B8Er = se(8);


err = [B1Er,B2Er,B3Er,B4Er,B5Er,B6Er] * 2;

er = errorbar(x,data,err); 
er.Color = [0 0 0];
er.LineStyle = 'none';
er.LineWidth = 1;
hold off

saveas(gcf,'Bar_proposer.png')

%% Mixed effects model


tb1 = array2table(Main_Effects(1:end,:),'VariableNames', {'x1','x2','x3'}); %x1 is Task, x2 is Endowment, and x3 is Delta P. 
tb2 = array2table(save_Y,'VariableNames', {'y'});
tb3 = array2table(subject_regressor,'VariableNames', {'subject'});
mixed_effects = [tb2, tb3, tb1];

% xs are fixed effects
% () are random effects 

% Subjects are a random effect. Need a different intercept for each subject
% due to different tastes. 

% Add a subj number column to mixed effects and use as a random effect.
% Use a random intercept first. Then random slope. 

% Use * for interactions. Check syntax. 

% y ~ x1 + x2 + x3 + intA + intB + (1 | subject) % Random intercept. Shift
% in preferences from less to more? Controls individual differences across.

% Null model.

% y ~ 1 + (1 | subject) vs. model. Is there a difference? 

% Run an ANOVA between the outputs. 

% Maybe add counterbalance order as a random effect

% Slope is how quick change in attitude.

% y ~ x1 + x2 + x3 + intA + intB + (x1 | subject) + (x2 | subject) + (x3 | subject)


% Where y is "predictor", x1 is Task, x2 is Endowment, and x3 is Delta P. 


random_intercept_model = fitlme(mixed_effects,'y ~ x1 + x2 + x3 + x1:x2 + x1:x3 + (1 | subject)');
null_intercept = fitlme(mixed_effects,'y ~ 1 + (1 | subject)');

[TABLE,SIMINFO] = compare(null_intercept, random_intercept_model)

random_slope_model = fitlme(mixed_effects,'y ~ x1 + x2 + x3 + x1:x2 + x1:x3 + (x1 | subject) + (x2 | subject) + (x3 | subject)');
null_slope = fitlme(mixed_effects,'y ~ 1 + (x1 | subject) + (x2 | subject) + (x3 | subject)');

[TABLE,SIMINFO] = compare(null_slope, random_slope_model)
