clear all 
close all
clc

% This script analyzes substance use measures (AUDIT, DUDIT, AADIS) in the
% istart data set 

% Temple University
% Daniel Sazhin
% Neuroeconomics Lab
% 03/14/2022

%% Read in AUDIT and DUDIT scores

% Find the columns you will need.
data = readtable('AUDIT_DUDIT.xlsx');
data_raw = table2array(data);

substance_use = [];
audit_data = [];

% audit is tenth column. motion is eleventh column

AUDIT = [data.Participant, data.audit];
AUDIT_Total = [];


for ii = 1:length(subjects)
    subj = subjects(ii);
    subj_row = find(AUDIT==subj);
    save = AUDIT(subj_row,:);
    AUDIT_Total = [AUDIT_Total;save];
end

DUDIT = [data.Participant, data.dudit];
DUDIT_Total = [];

for ii = 1:length(subjects)
    subj = subjects(ii);
    subj_row = find(DUDIT==subj);
    save = AUDIT(subj_row,:);
    DUDIT_Total = [DUDIT_Total;save];
end

for ii = 1:length(data_raw(:,1))
    save = [];
    savesubj = data_raw(ii,1);
    saveaudit = data_raw(ii,10);
    savedudit = data_raw(ii,11);
    save = [savesubj,saveaudit,savedudit];
    substance_use = [substance_use;save];
end


% adjust for desired subjects for the final output. Substance_use is used
% for preliminary analysis, substance_use_data is used in fmri analysis.

substance_use_data = [];

for ii = 1:length(subjects)
    subj = subjects(ii);
    subj_row = find(substance_use==subj);
    save = substance_use(subj_row,:);
    substance_use_data = [substance_use_data;save];
end

substance_use_output = array2table(substance_use_data(1:end,:),'VariableNames', {'Subject', 'audit','dudit'});
name = ['Substanceuse.xls'];
writetable(substance_use_output, name); % Save as csv file

% Is there a correlation between AUDIT and DUDIT?

[R,P] = corrcoef(substance_use(:,2), substance_use(:,3));
figure
scatter(substance_use(:,2), substance_use(:,3),'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5)
ax = gca;
ax.FontSize = 12;
xlabel ('AUDIT Scores', 'FontSize', 16);
ylabel  ('DUDIT Scores', 'FontSize', 16);
i = lsline;
i.LineWidth = 5;
i.Color = [0 0 0];
set(gcf,'color','w');

saveas(gcf,'AUDIT_DUDIT.png')

%% Histograms of drug use

% Total scores
% Type of drugs
% Frequency of usage per week 

data = readtable('Substance_and_Mood_data.csv');
AADIS = [data.('sub'),data.('aadis_q1'),data.('aadis_q2'),data.('aadis_q3'),data.('aadis_q4'),data.('aadis_q5'),data.('aadis_q6'),data.('aadis_q7'),data.('aadis_q8'),data.('aadis_q9'),data.('aadis_q10'),data.('aadis_q11'),data.('aadis_q12'),data.('aadis_q13')];
AUDIT_Freq_raw = [data.('sub'), data.('audit_1') + data.('audit_2') + data.('audit_3')];
AUDIT_Problematic_raw = [data.('sub'), data.('audit_4') + data.('audit_5') + data.('audit_6') + data.('audit_7') + data.('audit_8') + data.('audit_9') + data.('audit_10')];

% Q1: How often do you drink, Q2:, how many drinks?

DUDIT_Freq_raw = [data.('sub'), data.('dudit_1') + data.('dudit_2') + data.('dudit_3') + data.('dudit_4')];
DUDIT_Problematic_raw = [data.('sub'), data.('dudit_5') + data.('dudit_6') + data.('dudit_7') + data.('dudit_8') + data.('dudit_9') + data.('dudit_10') + data.('dudit_11')];


% Q1: How often do you do drugs, Q3:, how many times do you take drugs per day, Q4: how often are you heavily influenced?

% Eliminate NANS

eliminate_rows = any(isnan(AADIS),2);
AADIS_Good = [];

for ii = 1:length(AADIS)
    keep = [];
    row = AADIS(ii,:);
    if eliminate_rows(ii) == 0;
        keep = row;
    end
    AADIS_Good = [AADIS_Good; keep];
end
 
eliminate_rows = any(isnan(DUDIT_Freq_raw),2);
DUDIT_Freq = [];


for ii = 1:length(DUDIT_Freq_raw)
    keep = [];
    row = DUDIT_Freq_raw(ii,:);
    if eliminate_rows(ii) == 0;
        keep = row;
    end
    DUDIT_Freq = [DUDIT_Freq; keep];
end

eliminate_rows = any(isnan(AUDIT_Freq_raw),2);
AUDIT_Freq = [];


for ii = 1:length(AUDIT_Freq_raw)
    keep = [];
    row = AUDIT_Freq_raw(ii,:);
    if eliminate_rows(ii) == 0
        keep = row;
    end
    AUDIT_Freq = [AUDIT_Freq; keep];
end

eliminate_rows = any(isnan(AUDIT_Problematic_raw),2);
AUDIT_Problematic = [];

for ii = 1:length(AUDIT_Problematic_raw)
    keep = [];
    row = AUDIT_Problematic_raw(ii,:);
    if eliminate_rows(ii) == 0;
        keep = row;
    end
    AUDIT_Problematic = [AUDIT_Problematic; keep];
end
 
eliminate_rows = any(isnan(DUDIT_Problematic_raw),2);

DUDIT_Problematic = [];

for ii = 1:length(DUDIT_Problematic_raw)
    keep = [];
    row = DUDIT_Problematic_raw(ii,:);
    if eliminate_rows(ii) == 0;
        keep = row;
    end
    DUDIT_Problematic = [DUDIT_Problematic; keep];
end
 

figure


sgtitle('AADIS Results','FontSize', 24)

subplot(3,5,1)
h = histogram(AADIS_Good(:,2));
counts = h.Values;
h.NumBins = 6;
h.BinEdges = [0,1,2,3,4,5,6,7];
ax = gca;
ax.FontSize = 9;
xlabel ('Tobacco Usage','FontSize', 16)
ylabel ('Frequency','FontSize', 16)
set(gca,'box','off')
set(gcf,'color','w');
        

subplot(3,5,2)
h = histogram(AADIS_Good(:,3));
counts = h.Values;
h.NumBins = 6;
h.BinEdges = [0,1,2,3,4,5,6,7];
ax = gca;
ax.FontSize = 9;
xlabel ('Alcohol Usage','FontSize', 16)
ylabel ('Frequency','FontSize', 16)
set(gca,'box','off')
set(gcf,'color','w');

subplot(3,5,3)
h = histogram(AADIS_Good(:,4));
counts = h.Values;
h.NumBins = 6;
h.BinEdges = [0,1,2,3,4,5,6,7];
ax = gca;
ax.FontSize = 9;
xlabel ('Marijuana Usage','FontSize', 16)
ylabel ('Frequency','FontSize', 16)
set(gca,'box','off')
set(gcf,'color','w');

subplot(3,5,4)
h = histogram(AADIS_Good(:,5));
counts = h.Values;
h.NumBins = 6;
h.BinEdges = [0,1,2,3,4,5,6,7];
ax = gca;
ax.FontSize = 9;
xlabel ('LSD Usage','FontSize', 16)
ylabel ('Frequency','FontSize', 16)
set(gca,'box','off')
set(gcf,'color','w');

subplot(3,5,5)
h = histogram(AADIS_Good(:,6));
counts = h.Values;
h.NumBins = 6;
h.BinEdges = [0,1,2,3,4,5,6,7];
ax = gca;
ax.FontSize = 9;
xlabel ('Amphetamine Usage','FontSize', 16)
ylabel ('Frequency','FontSize', 16)
set(gca,'box','off')
set(gcf,'color','w');

subplot(3,5,6)
h = histogram(AADIS_Good(:,7));
counts = h.Values;
h.NumBins = 6;
h.BinEdges = [0,1,2,3,4,5,6,7];
ax = gca;
ax.FontSize = 9;
xlabel ('Powder Cocaine Usage','FontSize', 16)
ylabel ('Frequency','FontSize', 16)
set(gca,'box','off')
set(gcf,'color','w');

subplot(3,5,7)
h = histogram(AADIS_Good(:,8));
counts = h.Values;
h.NumBins = 6;
h.BinEdges = [0,1,2,3,4,5,6,7];
ax = gca;
ax.FontSize = 9;
xlabel ('Rock Cocaine Usage','FontSize', 16)
ylabel ('Frequency','FontSize', 16)
set(gca,'box','off')
set(gcf,'color','w');

subplot(3,5,8)
h = histogram(AADIS_Good(:,9));
counts = h.Values;
h.NumBins = 6;
h.BinEdges = [0,1,2,3,4,5,6,7];
ax = gca;
ax.FontSize = 9;
xlabel ('Barbituates Usage','FontSize', 16)
ylabel ('Frequency','FontSize', 16)
set(gca,'box','off')
set(gcf,'color','w');

subplot(3,5,9)
h = histogram(AADIS_Good(:,10));
counts = h.Values;
h.NumBins = 6;
h.BinEdges = [0,1,2,3,4,5,6,7];
ax = gca;
ax.FontSize = 9;
xlabel ('PCP Usage','FontSize', 16)
ylabel ('Frequency','FontSize', 16)
set(gca,'box','off')
set(gcf,'color','w');

subplot(3,5,10)
h = histogram(AADIS_Good(:,11));
counts = h.Values;
h.NumBins = 6;
h.BinEdges = [0,1,2,3,4,5,6,7];
ax = gca;
ax.FontSize = 9;
xlabel ('Heroin Usage','FontSize', 16)
ylabel ('Frequency','FontSize', 16)
set(gca,'box','off')
set(gcf,'color','w');

subplot(3,5,11)
h = histogram(AADIS_Good(:,12));
counts = h.Values;
h.NumBins = 6;
h.BinEdges = [0,1,2,3,4,5,6,7];
ax = gca;
ax.FontSize = 9;
xlabel ('Inhalants Usage','FontSize', 16)
ylabel ('Frequency','FontSize', 16)
set(gca,'box','off')
set(gcf,'color','w');


subplot(3,5,12)
h = histogram(AADIS_Good(:,13));
counts = h.Values;
h.NumBins = 6;
h.BinEdges = [0,1,2,3,4,5,6,7];
ax = gca;
ax.FontSize = 9;
xlabel ('Tranquilizer Usage','FontSize', 16)
ylabel ('Frequency','FontSize', 16)
set(gca,'box','off')
set(gcf,'color','w');



subplot(3,5,13)
h = histogram(AADIS_Good(:,14));
counts = h.Values;
h.NumBins = 6;
h.BinEdges = [0,1,2,3,4,5,6,7];
ax = gca;
ax.FontSize = 9;
xlabel ('Other Drugs','FontSize', 16)
ylabel ('Frequency','FontSize', 16)
set(gca,'box','off')
set(gcf,'color','w');

saveas(gcf,'AADIS.png')

%% Marijuana and Tobacco usage vs. AADIS

AADIS_smoking = [(AADIS_Good(:,1)),(AADIS_Good(:,2)) + (AADIS_Good(:,4))];

% Eliminate zeros? 

eliminate_rows = any(AADIS_smoking(:,2),2);
AADIS_Use = [];

for ii = 1:length(AADIS_smoking)
    keep = [];
    row = AADIS_smoking(ii,:);
    if eliminate_rows(ii) == 1
        keep = row;
    end
    AADIS_Use = [AADIS_Use; keep];
end

AADIS_smoking = AADIS_Use;

% First, make substance use and AADIS have same subjects

%DUDIT_substance_use = [substance_use(:,1), substance_use(:,3)]; raw scores
DUDIT_substance_use = [DUDIT_Freq(:,1), DUDIT_Freq(:,2)]; % frequency only
DUDIT_test = [];
 

% Save the rows from AADIS that mirror DUDIT subjects.

for ii = 1:length(AADIS_smoking)
    save = [];
    subj_row = [];
    subj = DUDIT_substance_use(ii,1);
    subj_row = find(DUDIT_substance_use==subj);
    save = DUDIT_substance_use(subj_row,:);
    DUDIT_test = [DUDIT_test;save];
end

% test without outlier
% subj_row = find(DUDIT_test==3143);
% DUDIT_test(subj_row,:) = []; 
% AADIS_smoking(subj_row,:) = [];

[R,P] = corrcoef(AADIS_smoking(:,2), DUDIT_test(:,2));
figure
scatter(AADIS_smoking(:,2), DUDIT_test(:,2),'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5)
ax = gca;
ax.FontSize = 12;
xlabel ('AADIS Smoking/Pot Scores', 'FontSize', 16);
ylabel  ('DUDIT', 'FontSize', 16);
i = lsline;
i.LineWidth = 5;
i.Color = [0 0 0];
set(gcf,'color','w');

saveas(gcf,'DUDIT.png')

%% Correlation between problematic substance use and frequency


AUDIT_Problematic_test = [];
AUDIT_Freq_test = [];

% Save the rows from AADIS that mirror DUDIT subjects.

for ii = 1:length(AUDIT_Freq)
    save = [];
    subj_row = [];
    subj = AUDIT_Freq(ii,1);
    subj_row = find(AUDIT_Problematic==subj);
    save = AUDIT_Problematic(subj_row,:);
    AUDIT_Problematic_test = [AUDIT_Problematic_test;save];
end

for ii = 1:length(AUDIT_Problematic_test)
    save = [];
    subj_row = [];
    subj = AUDIT_Problematic_test(ii,1);
    subj_row = find(AUDIT_Freq==subj);
    save = AUDIT_Freq(subj_row,:);
    AUDIT_Freq_test = [AUDIT_Freq_test;save];
end

[R,P] = corrcoef(AUDIT_Freq_test(:,2), AUDIT_Problematic_test(:,2));

[RHO,PVAL] = corr(AUDIT_Freq_test(:,2), AUDIT_Problematic_test(:,2),'Type','Spearman');
[R,P] = corr(AUDIT_Freq_test(:,2), AUDIT_Problematic_test(:,2),'Type','Pearson');

figure
scatter(AUDIT_Freq_test(:,2), AUDIT_Problematic_test(:,2),'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5)
ax = gca;
ax.FontSize = 12;
xlabel ('AUDIT Frequency', 'FontSize', 16);
ylabel  ('AUDIT Problematic Use', 'FontSize', 16);
i = lsline;
i.LineWidth = 5;
i.Color = [0 0 0];
set(gcf,'color','w');

saveas(gcf,'AUDIT Frequency vs. Problem.png')

DUDIT_Problematic_test = [];
DUDIT_Freq_test = [];

% Save the rows from DUDIT Freq that mirror DUDIT subjects.

for ii = 1:length(DUDIT_Freq)
    save = [];
    subj_row = [];
    subj = DUDIT_Freq(ii,1);
    subj_row = find(DUDIT_Problematic==subj);
    save = DUDIT_Problematic(subj_row,:);
    DUDIT_Problematic_test = [DUDIT_Problematic_test;save];
end

for ii = 1:length(DUDIT_Problematic_test)
    save = [];
    subj_row = [];
    subj = DUDIT_Problematic_test(ii,1);
    subj_row = find(DUDIT_Freq==subj);
    save = DUDIT_Freq(subj_row,:);
    DUDIT_Freq_test = [DUDIT_Freq_test;save];
end

[R,P] = corrcoef(DUDIT_Freq_test(:,2), DUDIT_Problematic_test(:,2));

[RHO,PVAL] = corr(DUDIT_Freq_test(:,2), DUDIT_Problematic_test(:,2),'Type','Spearman');
[R,PVAL] = corr(DUDIT_Freq_test(:,2), DUDIT_Problematic_test(:,2),'Type','Pearson');

figure
scatter(DUDIT_Freq_test(:,2), DUDIT_Problematic_test(:,2),'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5)
ax = gca;
ax.FontSize = 12;
xlabel ('DUDIT Frequency', 'FontSize', 16);
ylabel  ('DUDIT Problematic Use', 'FontSize', 16);
i = lsline;
i.LineWidth = 5;
i.Color = [0 0 0];
set(gcf,'color','w');

saveas(gcf,'DUDIT Frequency vs. Problem.png')

%% Alcohol AADIS vs Audit

AADIS_alcohol= [(AADIS_Good(:,1)),(AADIS_Good(:,3))];

% First, make substance use and AADIS have same subjects

% AUDIT_substance_use = [substance_use(:,1), substance_use(:,2)]; % raw
AUDIT_substance_use = [AUDIT_Freq(:,1), AUDIT_Freq(:,2)]; % frequency only
AUDIT_test = [];
 

% Save the rows from AADIS that mirror DUDIT subjects.

for ii = 1:length(AADIS_alcohol)
    save = [];
    subj_row = [];
    subj = AUDIT_substance_use(ii,1);
    subj_row = find(AUDIT_substance_use==subj);
    save = AUDIT_substance_use(subj_row,:);
    AUDIT_test = [AUDIT_test;save];
end




[R,P] = corrcoef(AADIS_alcohol(:,2), AUDIT_test(:,2));
figure
scatter(AADIS_alcohol(:,2), AUDIT_test(:,2),'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5)
ax = gca;
ax.FontSize = 12;
xlabel ('AADIS Alcohol', 'FontSize', 16);
ylabel  ('AUDIT', 'FontSize', 16);
i = lsline;
i.LineWidth = 5;
i.Color = [0 0 0];
set(gcf,'color','w');

saveas(gcf,'DUDIT.png')