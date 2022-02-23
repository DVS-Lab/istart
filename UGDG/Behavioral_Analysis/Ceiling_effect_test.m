clear all
close all
clc

% This script reads in EVfiles from the ISTART project and counts the
% number of high/low, accept/reject we have for each participant.

% Daniel Sazhin
% DVS Lab
% 01/26/2022
% Temple University

%% Set path and subjects
% 3199 rerun bids
maindir = 'C:\Users\danie\Documents\Github\istart\UGDG\Behavioral_Analysis'; % set on computer doing the analysis
subjects = [1002, 1003, 1004, 1006, 1007, 1009, 1010, 1011, 1012, 1013, 1015, 1016, 1019, 1021, 1240, 1242, 1243, 1244, 1245, 1247, 1248, 1249, 1251, 1253, 1255, 1276, 1282, 1286, 1294, 1300, 1301, 1302, 1303, 3101, 3116, 3122, 3125, 3140, 3143, 3152, 3164, 3166, 3170, 3173, 3175, 3176, 3189, 3190, 3200, 3212, 3218, 3220, 3223];
%% Input data

% Probably one for each possibility: DG More, DG Less, UG More, UG Less, UG
% Accept, UG Reject.

DG_Less = [];

for ii = 1:length(subjects)
    saveme = [];
    saveme2 = [0];
    for rr = 1:2
        
      try
        name = [maindir,'\EVfiles\','sub-' num2str(subjects(ii)),'\ugdg\','run-0' num2str(rr) '_dec_dg-prop_less.txt'];
        file = convertCharsToStrings(name);
        T = readtable(file);
        [N,M] = size(T);
        saveme = [subjects(ii),rr, N];
        saveme2 = [subjects(ii),saveme(3)+saveme];
        DG_Less = [DG_Less; saveme];
      
      
      catch 
       saveme = [subjects(ii),rr, 0];
       
       DG_Less = [DG_Less; saveme];
      end
    end
end


DG_More = [];

for ii = 1:length(subjects)
    for rr = 1:2
        saveme = [];
      try
        name = [maindir,'\EVfiles\','sub-' num2str(subjects(ii)),'\ugdg\','run-0' num2str(rr) '_dec_dg-prop_more.txt'];
        file = convertCharsToStrings(name);
        T = readtable(file);
        [N,M] = size(T);
        saveme = [subjects(ii),rr, N];
        DG_More = [DG_More; saveme];
      
      
      catch 
       saveme = [subjects(ii),rr, 0];
       DG_More = [DG_More; saveme];
      end
    end
end

UG_More = [];

for ii = 1:length(subjects)
    for rr = 1:2
        saveme = [];
      try
        name = [maindir,'\EVfiles\','sub-' num2str(subjects(ii)),'\ugdg\','run-0' num2str(rr) '_dec_ug-prop_more.txt'];
        file = convertCharsToStrings(name);
        T = readtable(file);
        [N,M] = size(T);
        saveme = [subjects(ii),rr, N];
        UG_More = [UG_More; saveme];
      
      
      catch 
       saveme = [subjects(ii),rr, 0];
       UG_More = [UG_More; saveme];
      end
    end
end

UG_Less = [];

for ii = 1:length(subjects)
    for rr = 1:2
        saveme = [];
      try
        name = [maindir,'\EVfiles\','sub-' num2str(subjects(ii)),'\ugdg\','run-0' num2str(rr) '_dec_ug-prop_less.txt'];
        file = convertCharsToStrings(name);
        T = readtable(file);
        [N,M] = size(T);
        saveme = [subjects(ii),rr, N];
        UG_Less = [UG_Less; saveme];
      
      
      catch 
       saveme = [subjects(ii),rr, 0];
       UG_Less = [UG_Less; saveme];
      end
    end
end

UG_Accept = [];

for ii = 1:length(subjects)
    for rr = 1:2
        saveme = [];
      try
        name = [maindir,'\EVfiles\','sub-' num2str(subjects(ii)),'\ugdg\','run-0' num2str(rr) '_dec_ug-resp_accept.txt'];
        file = convertCharsToStrings(name);
        T = readtable(file);
        [N,M] = size(T);
        saveme = [subjects(ii),rr, N];
        UG_Accept = [UG_Accept; saveme];
      
      
      catch 
       saveme = [subjects(ii),rr, 0];
       UG_Accept = [UG_Accept; saveme];
      end
    end
end

UG_Reject = [];

for ii = 1:length(subjects)
    for rr = 1:2
        saveme = [];
      try
        name = [maindir,'\EVfiles\','sub-' num2str(subjects(ii)),'\ugdg\','run-0' num2str(rr) '_dec_ug-resp_reject.txt'];
        file = convertCharsToStrings(name);
        T = readtable(file);
        [N,M] = size(T);
        saveme = [subjects(ii),rr, N];
        UG_Reject = [UG_Reject; saveme];
      
      
      catch 
       saveme = [subjects(ii),rr, 0];
       UG_Reject = [UG_Reject; saveme];
      end
    end
end

%% Plot results

% We will take proportion of More vs. Less and make a histogram

DG_Less_Proportion = DG_Less(:,3)./12;
DG_More_Proportion = DG_More(:,3)./12;
UG_Less_Proportion = UG_Less(:,3)./12;
UG_More_Proportion = UG_More(:,3)./12;
UG_Accept_Proportion = UG_Accept(:,3)./12;
UG_Reject_Proportion = UG_Reject(:,3)./12;

% Find Ns of useful EVs

[N,M] = size(find(DG_Less(:,3)==0));
DG_Less_N = 76-N;

[N,M] = size(find(DG_More(:,3)==0));
DG_More_N = 76-N;

[N,M] = size(find(UG_Less(:,3)==0));
UG_Less_N = 76-N;

[N,M] = size(find(UG_More(:,3)==0));
UG_More_N = 76-N;

[N,M] = size(find(UG_Accept(:,3)==0));
UG_Accept_N = 76-N;

[N,M] = size(find(UG_Reject(:,3)==0));
UG_Reject_N = 76-N;


