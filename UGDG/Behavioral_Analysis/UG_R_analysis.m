clear all
close all
clc

%% Rejection analysis

values = 1003:1021;
UG_Reject = [];

for ii = 1:length(values);
    
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
    if proportion>=0 && proportion<.1;
        saveme = 0.05;
        Bin1 = [Bin1; saveme];
    elseif proportion>=.1 && proportion<.2;
        saveme = 0.15;
        Bin2 = [Bin2; saveme];
    elseif proportion>=.2 && proportion<.3;
        saveme = 0.25;
        Bin3 = [Bin3; saveme];
    elseif proportion>=.3 && proportion<.4;
        saveme = 0.35;
        Bin4 = [Bin4; saveme];
    elseif proportion>=.4 && proportion<.5;
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

values = 1002:1021;
UG_Accept = [];

for ii = 1:length(values);
    
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
    if proportion>=0 && proportion<.1;
        saveme = 0.05;
        Bin1a = [Bin1a; saveme];
    elseif proportion>=.1 && proportion<.2;
        saveme = 0.15;
        Bin2a = [Bin2a; saveme];
    elseif proportion>=.2 && proportion<.3;
        saveme = 0.25;
        Bin3a = [Bin3a; saveme];
    elseif proportion>=.3 && proportion<.4;
        saveme = 0.35;
        Bin4a = [Bin4a; saveme];
    elseif proportion>=.4 && proportion<.5;
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

Bins = [Bin1_rejection_rate, Bin2_rejection_rate, Bin3_rejection_rate, Bin4_rejection_rate, Bin5_rejection_rate];


x = [.05,.15,.25,.35,.45]
figure

bar(x,Bins)
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

values = 1002:1021;
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
values = 1002:1021;
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
            elseif proportion>=.1 && proportion<.2;
                trial_earnings = (UG_P_2(ii,2) - UG_P_2(ii,3)) * (1-Bin2_rejection_rate);
                UG_P_Earnings_2 = [UG_P_Earnings_2; trial_earnings];
            elseif proportion>=.2 && proportion<.3;
                trial_earnings = (UG_P_2(ii,2) - UG_P_2(ii,3)) * (1-Bin3_rejection_rate);
                UG_P_Earnings_2 = [UG_P_Earnings_2; trial_earnings];
            elseif proportion>=.3 && proportion<.4;
                trial_earnings = (UG_P_2(ii,2) - UG_P_2(ii,3)) * (1-Bin4_rejection_rate);
                UG_P_Earnings_2 = [UG_P_Earnings_2; trial_earnings];
            elseif proportion>=.4 && proportion<.5;
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
            elseif proportion>=.1 && proportion<.2;
                trial_earnings = (UG_P(ii,2) - UG_P(ii,3)) * (1-Bin2_rejection_rate);
                UG_P_Earnings = [UG_P_Earnings_2; trial_earnings];
            elseif proportion>=.2 && proportion<.3;
                trial_earnings = (UG_P(ii,2) - UG_P(ii,3)) * (1-Bin3_rejection_rate);
                UG_P_Earnings = [UG_P_Earnings; trial_earnings];
            elseif proportion>=.3 && proportion<.4;
                trial_earnings = (UG_P(ii,2) - UG_P(ii,3)) * (1-Bin4_rejection_rate);
                UG_P_Earnings = [UG_P_Earnings; trial_earnings];
            elseif proportion>=.4 && proportion<.5;
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
    
    if a>0 && b==0;
        
        UG_P_Total = [UG_P_Total; total_save_2];
    end
    
    if b>0 && a==0;
        
        UG_P_Total = [UG_P_Total; total_save];
        
    end
    
    if a>0 && b>0;
        
        UG_P_Total = [UG_P_Total; (total_save_2 + total_save)/2];
        
    end
    
end


 %% Subjects
 

 values = 1002:1021;
 
 Subjects = [];
 Subjects_2 = [];
 
 Final_Subjects =[];
 
 for jj = 1:length(values)
     try
         Subjects = [];
         name = ['Subject_' num2str(values(jj)) '_UGP2.csv'];
         
         T = readtable(name);
         UG_P_2 = table2array(T);
         Subjects = values(jj);
         
     end
     
     try
         Subjects_2 = [];
         name = ['Subject_' num2str(values(jj)) '_UGP.csv'];
         
         T = readtable(name);
         UG_P = table2array(T);
         
         T = readtable(name);
         UG_P = table2array(T);
         Subjects = values(jj);
     end
     
     
     
     c = size(Subjects_2);
     d = size(Subjects);
     c = c(1);
     d = d(1);
     
     if c>0 && d == 0
         
         Final_Subjects = [Final_Subjects; Subjects_2];
     end
     
     if d>0 && c == 0
         
         Final_Subjects = [Final_Subjects; Subjects];
         
     end
     
     if d>0 && c>0
         
         Final_Subjects = [Final_Subjects; Subjects_2];
         
     end
 end
%% UG_P earnings

histogram(UG_P_Total, 10)
ylim([0 7])
title 'UG Proposer Earnings'
xlabel 'Earnings'
ylabel 'Frequency'

%% UG_R earnings

UG_R_Earnings = table2array(Earnings(:,2));


figure
histogram(UG_R_Earnings)
title 'UG Recipient Earnings'
xlabel 'Earnings'
ylabel 'Frequency'

%% Save 

UGDG_Data = [Final_Subjects,UG_P_Total, DG_P, UG_R_Earnings];

try 
UGDG_Data = array2table(UGDG_Data(1:end,:),'VariableNames', {'Subjects','UG_P','DG_P','UG_R',});
name = ['UGDG_Data.csv'];
writetable(UGDG_Data, name); % Save as csv file
end

%% Save 2

Bins_save = Bins;

try
Bins_save = array2table(Bins_save(1:end,:),'VariableNames', {'0','.1','.2','.3','.4'});
name = ['Rejection_Behavior.csv'];
writetable(Bins_save, name); % Save as csv file
end