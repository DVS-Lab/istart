clear all
close all
clc

% This code imports subject earnings (across conditions) and their
% individual difference measures and analyzes the data. 

% Daniel Sazhin
% 12/09/21
% DVS Lab
% Temple University

input_folder = ['C:\Users\danie\Documents\Github\istart\UGDG\Behavioral_Analysis\output\'];
input_behavioral = 'ISTART_CombinedDataSpreadsheet_031722.csv'; % input file  
motion_input = 'motion_data_input.xls';

make_full = 1; % Reads in all subjects. Outputs subs, ones, strategic behavior, tsnr, fd means.
make_reward = 0; % Reads in subjects with BAS and SPSRQ scores. Outputs subs, ones, strategic behavior, BAS, SPRSRQ, tsnr, fd means.
make_substance = 0; % Reads in subjects with AUDIT/DUDIT scores. Outputs subs, ones, strategic behavior, audit, dudit, tsnr, fd means. 
make_attitudes = 0; % Reads in subjects with TEIQUE/PNR scores. Outputs subs, ones, strategic behavior, TEIQUE, PNR, tsnr, fd means. 


%% Subs for SANS

% This was a limited pool of subjects used for analysis for the SANS poster
% in January. Left in case need to compare results.

% subjects = [1006, 1007, 1009, 1011, 1012, 1013, 1015, 1016, 1019, 1021, 1240, 1242, 1245, 1247, 1248, 1249, 1251, 1276, 1282, 1294, 1300, 1301, 1302, 1303, 3116, 3122, 3140, 3143, 3164, 3170, 3173, 3175, 3176, 3189, 3190, 3200, 3212];

%% Subs for full subject N, strat behavior, and motion.

% This is the full pool of subjects. 

% 1002 and 1243 excluded for now (failed preprocessing) 

if make_full == 1
    values = [1003, 1006, 1007, 1009, 1010, 1011, 1012, 1013, 1015, 1016, 1019, 1021, 1242, 1244, 1245, 1247, 1248, 1249, 1251, 1253, 1255, 1276, 1282, 1286, 1294, 1300, 1301, 1302, 1303, 3101, 3116, 3122, 3125, 3140, 3143, 3152, 3164, 3166, 3167, 3170, 3173, 3175, 3176, 3189, 3190, 3199, 3200, 3206, 3210, 3212, 3220];
end

%% Subs for reward


% Reward_missing =
% 
%         1242          40        -999

if make_reward == 1
    values = [1003, 1006, 1007, 1009, 1010, 1011, 1012, 1013, 1015, 1016, 1019, 1021, 1244, 1245, 1247, 1248, 1249, 1251, 1253, 1255, 1276, 1282, 1286, 1294, 1300, 1301, 1302, 1303, 3101, 3116, 3122, 3125, 3140, 3143, 3152, 3164, 3166, 3167, 3170, 3173, 3175, 3176, 3189, 3190, 3199, 3200, 3206, 3210, 3212, 3220];
end
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

%%

% This is the full pool of subjects. 

% 1002 and 1243 excluded for now (failed preprocessing) 

UG_Reject = [];

for ii = 1:length(values)
    
    try
        name = ['Subject_' num2str(values(ii)) '_rejected.csv'];
        input = [input_folder,name];
        T = readtable(input);
        UG_Reject = vertcat(UG_Reject,T);
        
    end
end

%% rejection rate

rejection = table2array(UG_Reject);

histogram(rejection)
title 'Rejection rates'
xlabel 'Proportion'
ylabel 'Frequency'

% Bin the rejections

Bin1 = [];
Bin2 = [];
Bin3 = [];
Bin4 = [];
Bin5 = [];


for ii = 1:length(rejection)
    proportion = rejection(ii);
    if proportion>=0 && proportion<.1
        saveme = 0.05;
        Bin1 = [Bin1; saveme];
    elseif proportion>=.1 && proportion<.2
        saveme = 0.15;
        Bin2 = [Bin2; saveme];
    elseif proportion>=.2 && proportion<.3
        saveme = 0.25;
        Bin3 = [Bin3; saveme];
    elseif proportion>=.3 && proportion<.4
        saveme = 0.35;
        Bin4 = [Bin4; saveme];
    elseif proportion>=.4 && proportion<.5
        saveme = 0.45;
        Bin5 = [Bin5; saveme];
    end
    
end

total = size(Bin1) + size(Bin2) + size(Bin3) + size(Bin4) + size(Bin5);
Bin1 = size(Bin1);
Bin2 = size(Bin2);
Bin3 = size(Bin3);
Bin4 = size(Bin4);
Bin5 = size(Bin5);

% Bin1 = Bin1(1) / total(1);
% Bin2 = Bin2(1) / total(1);
% Bin3 = Bin3(1) / total(1);
% Bin4 = Bin4(1) / total(1);
% Bin5 = Bin5(1) / total(1);

%% Accept analysis
UG_Accept = [];

for ii = 1:length(values)
    
    try
        name = ['Subject_' num2str(values(ii)) '_accepted.csv'];
        input = [input_folder,name];
        UG_Accept = vertcat(UG_Accept,T);
        
    end
end

%% Accepting rate

accepting = table2array(UG_Accept);

histogram(accepting)
title 'Accepting rates'
xlabel 'Proportion'
ylabel 'Frequency'

Bin1a = [];
Bin2a = [];
Bin3a = [];
Bin4a = [];
Bin5a = [];


for ii = 1:length(accepting)
    proportion = accepting(ii);
    if proportion>=0 && proportion<.1
        saveme = 0.05;
        Bin1a = [Bin1a; saveme];
    elseif proportion>=.1 && proportion<.2
        saveme = 0.15;
        Bin2a = [Bin2a; saveme];
    elseif proportion>=.2 && proportion<.3
        saveme = 0.25;
        Bin3a = [Bin3a; saveme];
    elseif proportion>=.3 && proportion<.4
        saveme = 0.35;
        Bin4a = [Bin4a; saveme];
    elseif proportion>=.4 && proportion<.5
        saveme = 0.45;
        Bin5a = [Bin5a; saveme];
    end
    
end

total = size(Bin1a) + size(Bin2a) + size(Bin3a) + size(Bin4a) + size(Bin5a);
Bin1a = size(Bin1a);
Bin2a = size(Bin2a);
Bin3a = size(Bin3a);
Bin4a = size(Bin4a);
Bin5a = size(Bin5a);

Bin1_rejection_rate = Bin1(1) / (Bin1(1) + Bin1a(1));
Bin2_rejection_rate = Bin2(1) / (Bin2(1) + Bin2a(1));
Bin3_rejection_rate = Bin3(1) / (Bin3(1) + Bin3a(1));
Bin4_rejection_rate = Bin4(1) / (Bin4(1) + Bin4a(1));
Bin5_rejection_rate = Bin5(1) / (Bin5(1) + Bin5a(1));

Binsuse = [Bin1_rejection_rate, Bin2_rejection_rate, Bin3_rejection_rate, Bin4_rejection_rate, Bin5_rejection_rate];


x = [.05,.15,.25,.35,.45];
figure

bar(x,Binsuse)
title 'Rejection rates';
xlabel 'Offers';
ylabel 'Rate of Rejection';
axis([-.0 .5 0 1]);

% Bin2 = Bin2(1) / total(1);
% Bin3 = Bin3(1) / total(1);
% Bin4 = Bin4(1) / total(1);
% Bin5 = Bin5(1) / total(1);


%% DG_P

Earnings = [];

for ii = 1:length(values);
    
    try
        name = ['Subject_' num2str(values(ii)) '_Earnings.csv'];
        input = [input_folder,name];
        T = readtable(input);
        Earnings = vertcat(Earnings,T);
        
    end
end

%% DG_P earnings

DG_P = table2array(Earnings(:,1));

histogram(DG_P, 10)
ylim([0 7])
title 'DG Proposer Earnings'
xlabel 'Earnings'
ylabel 'Frequency'

%% UG R1 and R2

% Manipulation (assumed rejection rates)

Final_save_2 = [];
UG_P_2 = [];

Final_save = [];
UG_P = [];
UG_P_Total = [];
Subjects = [];
Subjects_2 = [];

Final_Subjects =[];

for jj = 1:length(values)
    total_save_2= [];
    
    
    try
        name = ['Subject_' num2str(values(jj)) '_UGP2.csv'];
        input = [input_folder,name];
        T = readtable(input);
        UG_P_2 = table2array(T);
        
        total_save_2= [];
        saveme_2 = [];
        
        for ii = 1:length(UG_P_2)
            
            
            UG_P_Earnings_2 = [];
            proportion = UG_P_2(ii,3)/UG_P_2(ii,2);
            if proportion<.1
                trial_earnings = (UG_P_2(ii,2) - UG_P_2(ii,3)) * (1-Bin1_rejection_rate);
                UG_P_Earnings_2 = [UG_P_Earnings_2; trial_earnings];
            elseif proportion>=.1 && proportion<.2
                trial_earnings = (UG_P_2(ii,2) - UG_P_2(ii,3)) * (1-Bin2_rejection_rate);
                UG_P_Earnings_2 = [UG_P_Earnings_2; trial_earnings];
            elseif proportion>=.2 && proportion<.3
                trial_earnings = (UG_P_2(ii,2) - UG_P_2(ii,3)) * (1-Bin3_rejection_rate);
                UG_P_Earnings_2 = [UG_P_Earnings_2; trial_earnings];
            elseif proportion>=.3 && proportion<.4
                trial_earnings = (UG_P_2(ii,2) - UG_P_2(ii,3)) * (1-Bin4_rejection_rate);
                UG_P_Earnings_2 = [UG_P_Earnings_2; trial_earnings];
            elseif proportion>=.4 && proportion<.5
                trial_earnings = (UG_P_2(ii,2) - UG_P_2(ii,3)) * (1-Bin5_rejection_rate);
                UG_P_Earnings_2 = [UG_P_Earnings_2; trial_earnings];
            end
            
            saveme_2 = [saveme_2; UG_P_Earnings_2];
            total_save_2 = sum(saveme_2);
            Subjects_2 = values(jj);
        end
        
    end
    
    total_save= [];
    
    try
        name = ['Subject_' num2str(values(jj)) '_UGP.csv'];
        input = [input_folder,name];
        T = readtable(input);
        UG_P = table2array(T);
        
        Subjects = [];
        total_save= [];
        saveme = [];
        
        
        for ii = 1:length(UG_P)
            
            
            UG_P_Earnings = [];
            proportion = UG_P(ii,3)/UG_P_2(ii,2);
            if proportion<.1
                trial_earnings = (UG_P_2(ii,2) - UG_P(ii,3)) * (1-Bin1_rejection_rate);
                UG_P_Earnings = [UG_P_Earnings; trial_earnings];
            elseif proportion>=.1 && proportion<.2
                trial_earnings = (UG_P(ii,2) - UG_P(ii,3)) * (1-Bin2_rejection_rate);
                UG_P_Earnings = [UG_P_Earnings_2; trial_earnings];
            elseif proportion>=.2 && proportion<.3
                trial_earnings = (UG_P(ii,2) - UG_P(ii,3)) * (1-Bin3_rejection_rate);
                UG_P_Earnings = [UG_P_Earnings; trial_earnings];
            elseif proportion>=.3 && proportion<.4
                trial_earnings = (UG_P(ii,2) - UG_P(ii,3)) * (1-Bin4_rejection_rate);
                UG_P_Earnings = [UG_P_Earnings; trial_earnings];
            elseif proportion>=.4 && proportion<.5
                trial_earnings = (UG_P(ii,2) - UG_P(ii,3)) * (1-Bin5_rejection_rate);
                UG_P_Earnings = [UG_P_Earnings; trial_earnings];
            end
            
            saveme = [saveme; UG_P_Earnings];
            total_save = sum(saveme);
            Subjects = values(jj);
            
        end
        
    end
    
    a = size(total_save_2);
    b = size(total_save);
    a = a(1);
    b = b(1);
    
    if a>0 && b==0
        
        UG_P_Total = [UG_P_Total; total_save_2];
    end
    
    if b>0 && a==0
        
        UG_P_Total = [UG_P_Total; total_save];
        
    end
    
    if a>0 && b>0 
        
        UG_P_Total = [UG_P_Total; (total_save_2 + total_save)/2];
        
    end
    
end

%% Raw results UG-P

Final_save_2 = [];
UG_P_2 = [];

Final_save = [];
UG_P = [];
%UG_P_Total = [];
Subjects = [];
Subjects_2 = [];

UG_P_Raw = [];

subjects = values;
Final_Subjects =[];

for jj = 1:length(subjects)
    save_value = [];
    
    name = ['Subject_' num2str(subjects(jj)) '_UGP.csv'];
    input = [input_folder,name];
    T = readtable(input);
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
    input = [input_folder,name];
    T = readtable(input);
    UG_P_2 = table2array(T);
    save_value = sum(UG_P_2(:,2) - UG_P_2(:,3));
    UG_P_2_Raw = [UG_P_2_Raw; save_value];
    UG_P_2_Raw = abs(UG_P_2_Raw);
    
end

UG_P_Raw = round(((UG_P_2_Raw + UG_P_Raw)/2));


%% Raw DG

DG_P_Raw = [];
save_value = [];

for ii = 1:length(subjects);
    
    name = ['Subject_' num2str(subjects(ii)) '_DGP.csv'];
    input = [input_folder,name];
    O = readtable(input);;
    O = table2array(O);
    save_value = sum(O(:,3));
    DG_P_Raw = [DG_P_Raw; save_value];
    
end


%% UG_P earnings

figure
histogram(UG_P_Raw, 10)
ylim([0 7])
title 'UG Proposer Earnings'
xlabel 'Earnings'
ylabel 'Frequency'

%% UG_R earnings

UG_R_Earnings = table2array(Earnings(:,2));


figure
histogram(UG_R_Earnings, 5)
ylim([0, 7]);
ax = gca;
ax.FontSize = 9;
xlabel ('Ultimatum Game EI as Recipient','FontSize', 16)
ylabel ('Frequency','FontSize', 16)
set(gca,'box','off')
set(gcf,'color','w');


saveas(gcf,'UG_R.png')

%%


%Total_Earnings = UG_P_Raw + UG_R_Raw + DG_P_Raw;

Total_Earnings = UG_P_Total + DG_P_Raw + UG_R_Earnings; % Similar to strategic behavior

figure
histogram(Total_Earnings, 14)
ylim('auto');
ax = gca;
ax.FontSize = 9;
xlabel ('Total Earnings','FontSize', 16)
ylabel ('Frequency','FontSize', 16)
set(gca,'box','off')
set(gcf,'color','w');


saveas(gcf,'Total_Earnings.png')



%% Save 

UGDG_Data = [Final_Subjects,UG_P_Total, DG_P, UG_R_Earnings];

try 
UGDG_Data = array2table(UGDG_Data(1:end,:),'VariableNames', {'Subjects','UG_P','DG_P','UG_R',});
name = ['UGDG_Data.csv'];
writetable(UGDG_Data, name); % Save as csv file
end

%% Save 2

Bins_save = Binsuse;

try
Bins_save = array2table(Bins_save(1:end,:),'VariableNames', {'0','.1','.2','.3','.4'});
name = ('Rejection_Behavior.csv');
writetable(Bins_save, name); % Save as csv file
end

%% Strategic Behavior 

%Strategic_Behavior = DG_P + UG_P_Total;

% For purposes of abstract

Strategic_Behavior = UG_P_Raw - DG_P_Raw;

Strategic_Behavior_Percent = (Strategic_Behavior./abs(UG_P_Raw))*100; % percent change


%% Read in EI and PNR from other file

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

%% Figure 2

figure
h = histogram(UG_P_Total(:));
counts = h.Values;
h.NumBins = 11;
ax = gca;
ax.FontSize = 9;
xlabel ('Ultimatum Game Offers as Proposer','FontSize', 16);
ylabel ('Frequency','FontSize', 16);
set(gca,'box','off');
set(gcf,'color','w');

saveas(gcf,'UG_P.png')

%% Figure 3

figure
h = histogram(DG_P(:));
counts = h.Values;
h.NumBins = 11;
ax = gca;
ax.FontSize = 9;
xlabel ('Earnings as DG Proposer','FontSize', 16);
ylabel ('Frequency','FontSize', 16);
set(gca,'box','off');
set(gcf,'color','w');

saveas(gcf,'DGP.png')

%% 

%Cope7 = [2.228924845, -69.20036055, -6.422717132, -7.836157196, -6.854206813, 45.61579082, 26.75282526, 75.98362988, -16.59662775, -2.63439245 , -0.5985225, 22.40339789, 37.572792, -1.068525052]; 

% [R,P] = corrcoef(Cope7, TEIQUE_final(:,2));
% figure
% scatter(TotalEQScore, Cope7, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
% ax = gca;
% ax.FontSize = 12;
% xlabel ('EI Score', 'FontSize', 14);
% ylabel  ('UG and DG Contrast during Decision Phase', 'FontSize', 14);
% i = lsline;
% i.LineWidth = 5;
% i.Color = [0 0 0];
% set(gcf,'color','w');
% 
% saveas(gcf,'UG and dg.png')
% 
% figure
% 
% 
% B2Er = std(Cope7') / sqrt(length(Cope7'));
% B3Er = std(Cope8') / sqrt(length(Cope8'));
% 
% err = [B2Er,B3Er] * 2;
% 
% data = [mean(Cope7);  mean(Cope8)];
% x = linspace(1,2,2);
% bar(x,data)
% ax = gca;
% ax.FontSize = 12;
% box off
% xlabel ('Phases', 'FontSize', 16);
% ylabel  ('Activation', 'FontSize', 16);
% set(gcf,'color','w');
% set(gca, 'XTick', 1:2, 'XTickLabels', {'Endowment','Decision',})
% title('Mean UG and DG Contrast during Decision and Endowment Phases')
% 
% hold on
% 
% % Standard Error
% 
% er = errorbar(x,data,err); %errorbar(x,data,errlow,errhigh);
% er.Color = [0 0 0];
% er.LineStyle = 'none';
% er.LineWidth = 1;
% hold off
% 

%% Cope 8

%Cope8 = [-1.238865074, -28.61567736,  -15.02178652,  -15.54505961,  -9.324916225,  42.9214861,  44.3428182,  -36.82699058,  -10.59545914, -18.05904204,  53.6336315,  -26.17917893,  83.02145275, 22.16178178];  
%  
% [R,P] = corrcoef(Cope8, TEIQUE_final(:,2));
% figure
% scatter(TotalEQScore, Cope8, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
% ax = gca;
% ax.FontSize = 12;
% xlabel ('EI Score', 'FontSize', 14);
% ylabel  ('UG and DG Contrast during Endowment Phase', 'FontSize', 14);
% i = lsline;
% i.LineWidth = 5;
% i.Color = [0 0 0];
% set(gcf,'color','w');
% 
% saveas(gcf,'UG and dg.png')

%% DG/UG proportions


values = subjects;
DG_P_Proportions = [];

for ii = 1:length(values)
    
    try
        name = ['Subject_' num2str(values(ii)) '_DGP.csv'];
        input = [input_folder,name];
        O = readtable(input);
        DG_P_Proportions = vertcat(DG_P_Proportions,O);
        
    end
end

DG_P_Proportions = table2array(DG_P_Proportions);

Proportion_DG = DG_P_Proportions(:,3) ./ DG_P_Proportions(:,2);

figure
h = histogram(Proportion_DG(:));
counts = h.Values;
h.NumBins = 5;
ax = gca;
ax.FontSize = 9;
xlabel ('Dictator Game Offers as Proposer','FontSize', 16);
ylabel ('Frequency','FontSize', 16);
set(gca,'box','off');
set(gcf,'color','w');

saveas(gcf,'DGProportions.png')

bin1 = [];
bin2 = [];
bin3 = [];
bin4 = [];
bin5 = [];

for jj = 1:length(Proportion_DG)
    
    ii = Proportion_DG(jj);
    
    if ii > 0 && ii <= .1
        saveme = .05;
        bin1 = [bin1,saveme];
    end
    
    if ii > .1 && ii <= .2
        saveme = .15;
        bin2 = [bin2,saveme];
    end
    if ii > .2 && ii <= .3
        saveme = .25;
        bin3 = [bin3,saveme];
    end
    if ii > .3 && ii <= .4
        saveme = .35;
        bin4 = [bin4,saveme];
    end
    if ii > .4 && ii <= .5
        saveme = .45;
        bin5 = [bin5,saveme];
    end

end
figure

x = [.05,.15,.25,.35,.45];

bin511 = size(bin5);
bin511 = bin511(2);
bin411 = size(bin4);
bin411 = bin411(2);
bin311 = size(bin3);
bin311 = bin311(2);
bin211 = size(bin2);
bin211 = bin211(2);
bin111 = size(bin1);
bin111 = bin111(2);

total = bin511 + bin411+ bin311 + bin211 + bin111;
Binsuse = [(bin111/total), (bin211/total), (bin311/total), (bin411/total), (bin511/total)];

figure
bar(x,Binsuse);
title 'Offers as Proposer in Dictator Game';
xlabel 'Offers';
ylabel 'Rate Offered';
axis([-.0 .5 0 .6]);

%% DG/UG proportions


values = subjects;
UG_P_Proportions_1 = [];
UG_P_Proportions_2 = [];
for ii = 1:length(values)
    
    try
        name = ['Subject_' num2str(values(ii)) '_UGP.csv'];
        input = [input_folder,name];
        N = readtable(input);
        UG_P_Proportions_1 = vertcat(UG_P_Proportions_1,N);
        
    end
end

for ii = 1:length(values);
    
    try
        name = ['Subject_' num2str(values(ii)) '_UGP2.csv'];
        input = [input_folder,name];
        M = readtable(input);
        UG_P_Proportions_2 = vertcat(UG_P_Proportions_2,M);
        
    end
end


UG_P_Proportions_1 = table2array(UG_P_Proportions_1);
UG_P_Proportions_2 = table2array(UG_P_Proportions_2);

Proportion_UG1 = UG_P_Proportions_1(:,3) ./ UG_P_Proportions_1(:,2);
Proportion_UG2 = UG_P_Proportions_2(:,3) ./ UG_P_Proportions_2(:,2);

Proportion_UG = [Proportion_UG1; Proportion_UG2];

figure
h = histogram(Proportion_UG(:));
counts = h.Values;
h.NumBins = 5;
ax = gca;
ax.FontSize = 9;
xlabel ('Ultimatum Game Offers as Proposer','FontSize', 16)
ylabel ('Frequency','FontSize', 16)
set(gca,'box','off')
set(gcf,'color','w');

saveas(gcf,'UGProportions.png')

bin1 = [];
bin2 = [];
bin3 = [];
bin4 = [];
bin5 = [];

for ii = 1:length(Proportion_UG)
    
    jj = Proportion_UG(ii);
    
    if jj > 0 && jj <= .1
        saveme = .05;
        bin1 = [bin1,saveme];
    end
    
    if jj > .1 && jj <= .2
        saveme = .15;
        bin2 = [bin2,saveme];
    end
    if jj > .2 && jj <= .3
        saveme = .25;
        bin3 = [bin3,saveme];
    end
    if jj > .3 && jj <= .4
        saveme = .35;
        bin4 = [bin4,saveme];
    end
    if jj > .4 && jj <= .5
        saveme = .45;
        bin5 = [bin5,saveme];
    end

end
figure

x = [.05,.15,.25,.35,.45];

bin51 = size(bin5);
bin51 = bin51(2);
bin41 = size(bin4);
bin41 = bin41(2);
bin31 = size(bin3);
bin31 = bin31(2);
bin21 = size(bin2);
bin21 = bin21(2);
bin11 = size(bin1);
bin11 = bin11(2);

total2 = bin51 + bin41+ bin31 + bin21 + bin11;
Binsuse2 = [(bin11/total2), (bin21/total2), (bin31/total2), (bin41/total2), (bin51/total2)];


bar(x,Binsuse2)
title 'Offers as Proposer in Ultimatum Game'
xlabel 'Offers'
ylabel 'Rate Offered'
axis([-.0 .5 0 .6])

%% UG rejection rate

UG_Reject_Rate = [];

for ii = 1:length(values)
        name = ['Subject_' num2str(values(ii)) '_rejected.csv'];
        input = [input_folder,name];
        T = readtable(input);
        [N,M] = size(T);
        UG_Reject_Rate = [UG_Reject_Rate;(N/24)]; % Proportion of rejections relative to total UG-R trials
end

%% Figure out if there is a ceiling effect

% Defined as always choosing max in DG and min in UG.
% First, we will regenerate the participant pool

trials = 36;
A = combnk(0.06:0.13:0.48,2); % 6 possible combinations we will use for proposers
B = fliplr(A); % To counterbalance.
Proposer_Options = [A;B;A;B;A;B;]; % Now the options are counterbalanced
% We now have a pool of 36 combinations to choose from.

% ((((DVS: No, should be 36 or 24 rows? No choosing and nothing left to
% chance. )))
% (((DS: Fixed)))

% We need to randomly select 48 of these rows.

rows =[1:(trials)]; % Number of desired rows
shuffled_rows = rows(randperm(length(rows))); % Randomly select a number from 1 through 48.

%shuffled_rows = shuffled_rows(1:2)'; % We need two items

% Take those elements from Proposer_Options and add in six randomly chosen
% combinations.

Proposer_Pool = [];

for ii = 1:length(rows)
    % Index from shuffled_row
    Take = Proposer_Options(shuffled_rows(ii),:); % Take a random number from 1 through 48 and use that as the row
    Proposer_Pool = [Proposer_Pool; Take];
end

% The proposer pool randomly generates the proportions which are presented
% to the participant. So, if we find the max values between the two
% options, we can determine what are the most fair offers a participant can
% make. Opposite for min.

max_rows = [];
min_rows = [];
for ii = 1:length(Proposer_Pool)
    max_row = max(Proposer_Pool(ii,:));
    min_row = min(Proposer_Pool(ii,:)); 
    max_rows = [max_rows; max_row];
    min_rows = [min_rows; min_row];
end

% If a participant always chooses high, they would consistently split .3633
% of the endowment. If they always choose low, they would split .1467 of
% the endowment. 


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

%% Read in AUDIT and DUDIT scores (substance use)

if make_substance == 1

data = readtable(input_behavioral);

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
    
end 
%% Read in BIS/BAS and SR Scores

if make_reward == 1

data = readtable(input_behavioral);

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

end

%% Attitudes analysis

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
end
%% Do people with higher EI reject less often?

% For this analysis, we will take the number of rejections per subject and
% compare if that mean is different across EI.

if make_attitudes == 1

% Is there a correlation between rejection rates and emotional
% intelligence?

[R,P] = corrcoef(UG_Reject_Rate, TEIQUE_final(:,2));
figure
scatter(PNR_final(:,2), UG_Reject_Rate, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
ax = gca;
ax.FontSize = 12;
xlabel ('PNR Score', 'FontSize', 16);
ylabel  ('Rejection Rate in UG-R', 'FontSize', 16);
i = lsline;
i.LineWidth = 5;
i.Color = [0 0 0];
set(gcf,'color','w');

saveas(gcf,'DGPEQ.png')


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

[R,P] = corrcoef(DG_P,TEIQUE_final(:,2))
[R,P] = corrcoef(UG_P_Raw,TEIQUE_final(:,2))
[R,P] = corrcoef(UG_P_Total,TEIQUE_final(:,2))
[R,P] = corrcoef(UG_R_Earnings,TEIQUE_final(:,2))
[R,P] = corrcoef(UG_Reject_Rate,TEIQUE_final(:,2))
[R,P] = corrcoef(Total_Earnings,TEIQUE_final(:,2))
[R,P] = corrcoef(Strategic_Behavior,TEIQUE_final(:,2))

[R,P] = corrcoef(UG_R_Earnings, TEIQUE_final(:,2));

% PNR
[R,P] = corrcoef(DG_P,PNR_final(:,2))
[R,P] = corrcoef(UG_P_Raw,PNR_final(:,2))
[R,P] = corrcoef(UG_P_Total,PNR_final(:,2))
[R,P] = corrcoef(UG_R_Earnings,PNR_final(:,2))
[R,P] = corrcoef(UG_Reject_Rate,PNR_final(:,2))
[R,P] = corrcoef(Total_Earnings,PNR_final(:,2))
[R,P] = corrcoef(Strategic_Behavior,PNR_final(:,2))

figure

scatter(UG_R_Earnings,UG_Reject_Rate, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
ax = gca;
ax.FontSize = 12;
xlabel ('UGR Reject Rate', 'FontSize', 16);
ylabel  ('PNR Score', 'FontSize', 16);
i = lsline;
i.LineWidth = 5;
i.Color = [0 0 0];
set(gcf,'color','w');

saveas(gcf,'DGPEQ.png')

end

%% Reward analysis

if make_reward == 1
       
% BAS

[R,P] = corrcoef(DG_P,Reward_final(:,2))
[R,P] = corrcoef(UG_P_Raw,Reward_final(:,2))
[R,P] = corrcoef(UG_P_Total,Reward_final(:,2))
[R,P] = corrcoef(UG_R_Earnings,Reward_final(:,2))
[R,P] = corrcoef(UG_Reject_Rate,Reward_final(:,2))
[R,P] = corrcoef(Total_Earnings,Reward_final(:,2))
[R,P] = corrcoef(Strategic_Behavior,Reward_final(:,2))

% SPSRQ

[R,P] = corrcoef(DG_P,Reward_final(:,3))
[R,P] = corrcoef(UG_P_Raw,Reward_final(:,3))
[R,P] = corrcoef(UG_P_Total,Reward_final(:,3))
[R,P] = corrcoef(UG_R_Earnings,Reward_final(:,3))
[R,P] = corrcoef(UG_Reject_Rate,Reward_final(:,3))
[R,P] = corrcoef(Total_Earnings,Reward_final(:,3))
[R,P] = corrcoef(Strategic_Behavior,Reward_final(:,3))

end

%% Substance analysis

if make_substance == 1
       
% AUDIT

[R,P] = corrcoef(DG_P,AUDIT_final(:,2))
[R,P] = corrcoef(UG_P_Raw,AUDIT_final(:,2))
[R,P] = corrcoef(UG_P_Total,AUDIT_final(:,2))
[R,P] = corrcoef(UG_R_Earnings,AUDIT_final(:,2))
[R,P] = corrcoef(UG_Reject_Rate,AUDIT_final(:,2))
[R,P] = corrcoef(Strategic_Behavior,AUDIT_final(:,2))

% DUDIT

% [R,P] = corrcoef(DG_P,DUDIT_final(:,2))
% [R,P] = corrcoef(UG_P_Raw,DUDIT_final(:,2))
% [R,P] = corrcoef(UG_P_Total,DUDIT_final(:,2))
% [R,P] = corrcoef(UG_R_Earnings,DUDIT_final(:,2))
% [R,P] = corrcoef(UG_Reject_Rate,DUDIT_final(:,2))
% [R,P] = corrcoef(Strategic_Behavior,DUDIT_final(:,2))

end

figure

h = histogram(UG_Reject_Rate(:));
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
[B,DEV,STATS] = glmfit(save_X,save_Y,'binomial','link','logit') %mnrfit(save_X,save_Y)
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
    
    X = [subject_DGP.Endowment,(subject_DGP.More_Prop-subject_DGP.Less_Prop)];
    X = zscore(X);
    save_X = [save_X; X];
    save_Y = [save_Y; Y];
    
    [B,DEV,STATS] = glmfit(X,Y,'binomial','link','logit');
    coeff=STATS.coeffcorr;
    Cor_Endow_DeltaP=[Cor_Endow_DeltaP; coeff(2,3)];
    Cor_Endow_Intercept=[Cor_Endow_Intercept; coeff(1,2)];
    Cor_DeltaP_Intercept= [Cor_DeltaP_Intercept; coeff(1,3)];
    
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
set(gca, 'XTick', 1:3, 'XTickLabels', {'Intercept', 'Endowment', 'Delta P'})
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
            T = readtable(input);
            name = ['Subject_' num2str(values(ii)) '_UGP2.csv'];
            input = [input_folder,name];
            S = readtable(input);
            subject_UGP = [S;T];
            Y = subject_UGP.Decision;
        catch
            missing_data = [missing_data, values(ii)];
        end
      
        X = [subject_UGP.Endowment,(subject_UGP.More_Prop-subject_UGP.Less_Prop)];
        X = zscore(X);
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
set(gca, 'XTick', 1:3, 'XTickLabels', {'Intercept', 'Endowment', 'Delta P'})
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
    

%% Figure 4
% 
% [R,P] = corrcoef(Total_Earnings, TEIQUE_final(:,2));
% figure
% scatter(TEIQUE_final(:,2), Total_Earnings,'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
% ax = gca;
% ax.FontSize = 12;
% xlabel ('EI Score', 'FontSize', 16);
% ylabel  ('Total Earnings', 'FontSize', 16);
% i = lsline;
% i.LineWidth = 5;
% i.Color = [0 0 0];
% set(gcf,'color','w');
% 
% saveas(gcf,'TotalEarnings.png')
% 
% %% Figure 7
% 
% %[R,P] = corrcoef(DG_P, TEIQUE_final(:,2)); %
% [R,P] = corrcoef(DG_P, PNR_final(:,2));
% figure
% scatter(PNR_final(:,2), DG_P, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
% %scatter(TEIQUE_final(:,2), DG_P, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
% ax = gca;
% ax.FontSize = 12;
% xlabel ('EI Score', 'FontSize', 16);
% ylabel  ('Earnings as Proposer in DG Task', 'FontSize', 16);
% i = lsline;
% i.LineWidth = 5;
% i.Color = [0 0 0];
% set(gcf,'color','w');
% 
% saveas(gcf,'DGPEQ.png')
% 
% %% Figure 7
% 
% %[R,P] = corrcoef(UG_P_Total, TEIQUE_final(:,2));
% [R,P] = corrcoef(UG_P_Total, PNR_final(:,2));
% figure
% %scatter(TEIQUE_final(:,2), UG_P_Total, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
% scatter(PNR_final(:,2), UG_P_Total, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
% ax = gca;
% ax.FontSize = 12;
% xlabel ('EI Score', 'FontSize', 16);
% ylabel  ('Earnings as Proposer in UGP Task', 'FontSize', 16);
% i = lsline;
% i.LineWidth = 5;
% i.Color = [0 0 0];
% set(gcf,'color','w');
% 
% saveas(gcf,'DGPEQ.png')
% 
% %% Figure 8
% 
% [R,P] = corrcoef(UG_R_Earnings, TEIQUE_final(:,2));
% figure
% scatter(TEIQUE_final(:,2), UG_R_Earnings, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
% ax = gca;
% ax.FontSize = 12;
% xlabel ('EI Score', 'FontSize', 16);
% ylabel  ('Earnings as Proposer in UGR Task', 'FontSize', 16);
% i = lsline;
% i.LineWidth = 5;
% i.Color = [0 0 0];
% set(gcf,'color','w');
% 
% saveas(gcf,'DGPEQ.png')