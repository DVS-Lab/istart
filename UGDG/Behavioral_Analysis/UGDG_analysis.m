clear all
close all
clc

% This code imports subject earnings (across conditions) and their
% individual difference measures and analyzes the data. 

% Daniel Sazhin
% 12/09/21
% DVS Lab
% Temple University

%% Rejection analysis

%values = 1002:4000;
values = [1002, 1004, 1006, 1007, 1009, 1011, 1012, 1013, 1015, 1016, 1019, 1021, 1240, 1242, 1243, 1245, 1247, 1248, 1249, 1251, 1276, 1282, 1294, 1300, 1301, 1302, 1303, 3116, 3122, 3140, 3143, 3164, 3170, 3173, 3175, 3176, 3189, 3190, 3200];
UG_Reject = [];

for ii = 1:length(values)
    
    try
        name = ['Subject_' num2str(values(ii)) '_rejected.csv'];
        
        T = readtable(name);
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

values = 1002:4000;
UG_Accept = [];

for ii = 1:length(values)
    
    try
        name = ['Subject_' num2str(values(ii)) '_accepted.csv'];
        
        T = readtable(name);
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


x = [.05,.15,.25,.35,.45]
figure

bar(x,Binsuse)
title 'Rejection rates'
xlabel 'Offers'
ylabel 'Rate of Rejection'
axis([-.0 .5 0 1])

% Bin2 = Bin2(1) / total(1);
% Bin3 = Bin3(1) / total(1);
% Bin4 = Bin4(1) / total(1);
% Bin5 = Bin5(1) / total(1);

%% UG_R


%% DG_P

values = 1002:4000;
Earnings = [];

for ii = 1:length(values);
    
    try
        name = ['Subject_' num2str(values(ii)) '_Earnings.csv'];
        
        T = readtable(name);
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

Final_save_2 = [];
values = 1002:4000;
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
        
        T = readtable(name);
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
        
        T = readtable(name);
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
values = 1002:4000;
UG_P_2 = [];

Final_save = [];
UG_P = [];
UG_P_Total = [];
Subjects = [];
Subjects_2 = [];

UG_P_Raw = [];

subjects = [1004, 1006, 1007, 1009, 1011, 1012, 1013, 1015, 1016, 1019, 1021, 1240, 1242, 1245, 1247, 1248, 1249, 1251, 1276, 1282, 1294, 1300, 1301, 1302, 1303, 3116, 3122, 3140, 3143, 3164, 3170, 3173, 3175, 3176, 3189, 3190, 3200, 3212];
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


%% Raw DG

DG_P_Raw = [];
save_value = [];

for ii = 1:length(subjects);
    
    name = ['Subject_' num2str(subjects(ii)) '_DGP.csv'];
    O = readtable(name);
    O = table2array(O);
    save_value = sum(O(:,3));
    DG_P_Raw = [DG_P_Raw; save_value];
    
end


%% UG_P earnings

figure
histogram(UG_P_Total, 10)
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


saveas(gcf,'UG_P.png')

%%


%Total_Earnings = UG_P_Raw + UG_R_Raw + DG_P_Raw;

Total_Earnings = UG_P_Raw + DG_P_Raw; % Similar to strategic behavior

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
name = ['Rejection_Behavior.csv'];
writetable(Bins_save, name); % Save as csv file
end

%% Strategic Behavior 

%Strategic_Behavior = DG_P + UG_P_Total;

% For purposes of abstract

Strategic_Behavior = UG_P_Raw - DG_P_Raw;

Strategic_Behavior_Percent = (Strategic_Behavior./abs(UG_P_Raw))*100; % percent change


%% EQ Scale

% Find the columns you will need.
t = readtable('ISTART_EI_Data_120921.xlsx');
start = 2;
finish = 31;

N = 30; % Number of questions
%IndexedColumns = round(linspace(start,finish, N));
data = table2array(t);

% define subjects

subjects_EQ = subjects';
EQ_data = [];

for ii = 1:length(subjects_EQ)
    [row,col] = find(data==subjects_EQ(ii));
    saverow = data(row,:);
    saverow = saverow(2:end);
    EQ_data = [EQ_data; saverow];
end


%EQ_data = data(:,IndexedColumns);


%EQ_data = EQ_data(2:end,:); % Eliminating 1001 and 1002, which had bad data.
Total_Subjects = size(EQ_data);
Total_Subjects = Total_Subjects(1);

WellbeingScore = [];
SelfcontrolScore = [];
EmotionalityScore = [];
SociabilityScore = [];
TotalEQScore = [];
max_EQ = 7;
min_EQ = 1;
add_EQ = max_EQ + min_EQ;

for ii = 1:Total_Subjects % ii is the subject
    EQ1 = EQ_data(ii,1);
    EQ2 = add_EQ+(-1*(EQ_data(ii,2)));% Reverse code
    EQ3 = EQ_data(ii,3);
    EQ4 = add_EQ+(-1*(EQ_data(ii,4)));% Reverse code
    EQ5 = add_EQ+(-1*(EQ_data(ii,5)));% Reverse code
    EQ6 = EQ_data(ii,6);
    EQ7 = add_EQ+(-1*(EQ_data(ii,7)));% Reverse code
    EQ8 = add_EQ+(-1*(EQ_data(ii,8)));% Reverse code
    EQ9 = EQ_data(ii,9);
    EQ10 = add_EQ+(-1*(EQ_data(ii,10)));% Reverse code
    EQ11 = EQ_data(ii,11);
    EQ12 = add_EQ+(-1*(EQ_data(ii,12)));% Reverse code
    EQ13 = add_EQ+(-1*(EQ_data(ii,13)));% Reverse code
    EQ14 = add_EQ+(-1*(EQ_data(ii,14)));% Reverse code
    EQ15 = EQ_data(ii,15);
    EQ16 = add_EQ+(-1*(EQ_data(ii,16)));% Reverse code
    EQ17 = EQ_data(ii,17);
    EQ18 = add_EQ+(-1*(EQ_data(ii,18)));% Reverse code
    EQ19 = EQ_data(ii,19);
    EQ20 = EQ_data(ii,20);
    EQ21 = EQ_data(ii,21);
    EQ22 = add_EQ+(-1*(EQ_data(ii,22)));% Reverse code 
    EQ23 = EQ_data(ii,23); 
    EQ24 = EQ_data(ii,24);
    EQ25 = add_EQ+(-1*(EQ_data(ii,25)));% Reverse code
    EQ26 = add_EQ+(-1*(EQ_data(ii,26)));% Reverse code
    EQ27 = EQ_data(ii,27);
    EQ28 = add_EQ+(-1*(EQ_data(ii,28)));% Reverse code
    EQ29 = EQ_data(ii,29); 
    EQ30 = EQ_data(ii,30); 
    
    total = EQ1+EQ2+EQ3+EQ4+EQ5+EQ6+EQ7+EQ8+EQ9+EQ10+EQ11+EQ12+EQ13+EQ14+EQ15+EQ16+EQ17+EQ18+EQ19+EQ20+EQ21+EQ22+EQ23+EQ24+EQ25+EQ26+EQ27+EQ28+EQ29+EQ30;
    TotalEQScore = [TotalEQScore, total];
    
    % Subscales are calculated from Deshawn's code

    WS = EQ5 + EQ20 + EQ9 + EQ24 + EQ12 + EQ27;
    WellbeingScore = [WellbeingScore, WS]; 
    
    SC = EQ4 + EQ19 + EQ7 +EQ22 + EQ15 + EQ30;
    SelfcontrolScore = [SelfcontrolScore, SC];
    
    ES = EQ1 + EQ16 + EQ2 + EQ17 + EQ8 + EQ23 + EQ13 + EQ28;
    EmotionalityScore = [EmotionalityScore, ES];
    
    SS = EQ6 + EQ21 + EQ10 + EQ25 + EQ11 + EQ26;
    SociabilityScore = [SociabilityScore, SS]; 
end 

%% Personal Norm Scale

% Find the columns you will need.
t = readtable('ISTART_PNR_Data_122321.xlsx');
start = 2;
finish = 10;

N = 9; % Number of questions
IndexedColumns = [1,round(linspace(start,finish, N))];
data = t(:,IndexedColumns);
data = table2array(data(2:end,:));

% prune data

PNR_data = [];

for ii = 1:length(subjects_EQ) % same subj numbers as EQ scale
    [row,col] = find(data==subjects_EQ(ii));
    saverow = data(row,:);
    saverow = saverow(2:end);
    PNR_data = [PNR_data; saverow];
end

Total_Subjects = size(PNR_data);
Total_Subjects = Total_Subjects(1);

% PNR Scale

PNRScore = [];
max_pnr = 7;
min_pnr = 1;
add_pnr = max_pnr + min_pnr;

for ii = 1:Total_Subjects % ii is the subject
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
end 

%% Correlation with EQ and Strategic Behavior

[R,P] = corrcoef(Strategic_Behavior,TotalEQScore);

figure
%subplot(2,4,2)
scatter(TotalEQScore, Strategic_Behavior)
title 'Strategic Behavior and EQ'
ylabel 'Strategic Behavior'
xlabel 'EQ'


% Hypothesis 

figure
[R,P] = corrcoef(Strategic_Behavior,PNRScore);

%subplot(2,4,3)
scatter(Strategic_Behavior, PNRScore)
title 'Proportion and PNR'

%% Histogram of EQ scores

figure
h = histogram(TotalEQScore);
counts = h.Values;
h.NumBins = 12
ax = gca
ax.FontSize = 12
xlabel ('Emotional Intelligence','FontSize', 16)
ylabel ('Frequency','FontSize', 16)
set(gca,'box','off')
set(gcf,'color','w');

saveas(gcf,'EQ_Scores.png')

%% Histogram of PNR scores

figure
h = histogram(PNRScore);
counts = h.Values;
h.NumBins = 12
ax = gca
ax.FontSize = 12
xlabel ('Negative Personal Norms of Reciprocity','FontSize', 16)
ylabel ('Frequency','FontSize', 16)
set(gca,'box','off')
set(gcf,'color','w');

saveas(gcf,'PNR_Scores.png')

%% Figure 2

figure
h = histogram(UG_P_Total(:));
counts = h.Values;
h.NumBins = 11
ax = gca
ax.FontSize = 9
xlabel ('Ultimatum Game Offers as Proposer','FontSize', 16)
ylabel ('Frequency','FontSize', 16)
set(gca,'box','off')
set(gcf,'color','w');

saveas(gcf,'UG_P.png')

%% Figure 3

figure
h = histogram(DG_P(:));
counts = h.Values;
h.NumBins = 11
ax = gca
ax.FontSize = 9
xlabel ('Earnings as DG Proposer','FontSize', 16)
ylabel ('Frequency','FontSize', 16)
set(gca,'box','off')
set(gcf,'color','w');

saveas(gcf,'DGP.png')

%% Figure 4

[R,P] = corrcoef(Total_Earnings, TotalEQScore)
figure
scatter(TotalEQScore, Total_Earnings,'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5)
ax = gca
ax.FontSize = 12
xlabel ('EI Score', 'FontSize', 16);
ylabel  ('Total Earnings', 'FontSize', 16);
i = lsline;
i.LineWidth = 5;
i.Color = [0 0 0];
set(gcf,'color','w');

saveas(gcf,'TotalEarnings.png')

%% Figure 7

[R,P] = corrcoef(DG_P, TotalEQScore);
figure
scatter(TotalEQScore, DG_P, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
ax = gca;
ax.FontSize = 12;
xlabel ('EI Score', 'FontSize', 16);
ylabel  ('Earnings as Proposer in DG Task', 'FontSize', 16);
i = lsline;
i.LineWidth = 5;
i.Color = [0 0 0];
set(gcf,'color','w');

saveas(gcf,'DGPEQ.png')

%% Figure 7

[R,P] = corrcoef(UG_R_Earnings, TotalEQScore);
figure
scatter(TotalEQScore, UG_P_Total, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
ax = gca;
ax.FontSize = 12;
xlabel ('EI Score', 'FontSize', 16);
ylabel  ('Earnings as Proposer in UG Task', 'FontSize', 16);
i = lsline;
i.LineWidth = 5;
i.Color = [0 0 0];
set(gcf,'color','w');

saveas(gcf,'DGPEQ.png')


%% 

Cope7 = [2.228924845, -69.20036055, -6.422717132, -7.836157196, -6.854206813, 45.61579082, 26.75282526, 75.98362988, -16.59662775, -2.63439245 , -0.5985225, 22.40339789, 37.572792, -1.068525052]; 

[R,P] = corrcoef(Cope7, TotalEQScore);
figure
scatter(TotalEQScore, Cope7, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
ax = gca;
ax.FontSize = 12;
xlabel ('EI Score', 'FontSize', 14);
ylabel  ('UG and DG Contrast during Decision Phase', 'FontSize', 14);
i = lsline;
i.LineWidth = 5;
i.Color = [0 0 0];
set(gcf,'color','w');

saveas(gcf,'UG and dg.png')

figure


B2Er = std(Cope7') / sqrt(length(Cope7'));
B3Er = std(Cope8') / sqrt(length(Cope8'));

err = [B2Er,B3Er] * 2;

data = [mean(Cope7);  mean(Cope8)];
x = linspace(1,2,2);
bar(x,data)
ax = gca;
ax.FontSize = 12;
box off
xlabel ('Phases', 'FontSize', 16);
ylabel  ('Activation', 'FontSize', 16);
set(gcf,'color','w');
set(gca, 'XTick', 1:2, 'XTickLabels', {'Endowment','Decision',})
title('Mean UG and DG Contrast during Decision and Endowment Phases')

hold on

% Standard Error

er = errorbar(x,data,err); %errorbar(x,data,errlow,errhigh);
er.Color = [0 0 0];
er.LineStyle = 'none';
er.LineWidth = 1;
hold off


%% Cope 8

Cope8 = [-1.238865074, -28.61567736,  -15.02178652,  -15.54505961,  -9.324916225,  42.9214861,  44.3428182,  -36.82699058,  -10.59545914, -18.05904204,  53.6336315,  -26.17917893,  83.02145275, 22.16178178];  
 
[R,P] = corrcoef(Cope8, TotalEQScore);
figure
scatter(TotalEQScore, Cope8, 'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
ax = gca;
ax.FontSize = 12;
xlabel ('EI Score', 'FontSize', 14);
ylabel  ('UG and DG Contrast during Endowment Phase', 'FontSize', 14);
i = lsline;
i.LineWidth = 5;
i.Color = [0 0 0];
set(gcf,'color','w');

saveas(gcf,'UG and dg.png')

%% DG/UG proportions


values = 1002:4000;
DG_P_Proportions = [];

for ii = 1:length(values);
    
    try
        name = ['Subject_' num2str(values(ii)) '_DGP.csv'];
        
       
        O = readtable(name);
        DG_P_Proportions = vertcat(DG_P_Proportions,O);
        
    end
end

DG_P_Proportions = table2array(DG_P_Proportions);

Proportion_DG = DG_P_Proportions(:,3) ./ DG_P_Proportions(:,2)

figure
h = histogram(Proportion_DG(:));
counts = h.Values;
h.NumBins = 5
ax = gca
ax.FontSize = 9
xlabel ('Dictator Game Offers as Proposer','FontSize', 16)
ylabel ('Frequency','FontSize', 16)
set(gca,'box','off')
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
bar(x,Binsuse)
title 'Offers as Proposer in Dictator Game'
xlabel 'Offers'
ylabel 'Rate Offered'
axis([-.0 .5 0 .6])

%% DG/UG proportions


values = 1002:4000;
UG_P_Proportions_1 = [];
UG_P_Proportions_2 = [];
for ii = 1:length(values);
    
    try
        name = ['Subject_' num2str(values(ii)) '_UGP.csv'];
        
       
        N = readtable(name);
        UG_P_Proportions_1 = vertcat(UG_P_Proportions_1,N);
        
    end
end

for ii = 1:length(values);
    
    try
        name = ['Subject_' num2str(values(ii)) '_UGP2.csv'];
        
       
        M = readtable(name);
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
h.NumBins = 5
ax = gca
ax.FontSize = 9
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
    
    ii = Proportion_UG(ii);
    
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

