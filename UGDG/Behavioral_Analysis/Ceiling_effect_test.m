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

maindir = 'C:\Users\danie\Documents\Github\istart\UGDG\Behavioral_Analysis'; % set on computer doing the analysis
subjects = [1004, 1006, 1007, 1009, 1011, 1012, 1013, 1015, 1016, 1019, 1021, 1240, 1242, 1245, 1247, 1248, 1249, 1251, 1276, 1282, 1294, 1300, 1301, 1302, 1303, 3116, 3122, 3140, 3143, 3164, 3170, 3173, 3175, 3176, 3189, 3190, 3200, 3212];
%% Input data

% Probably one for each possibility: DG More, DG Less, UG More, UG Less, UG
% Accept, UG Reject.

DG_Less = [];

for ii = 1:length(subjects)
    for rr = 1:2
        try
        name = [maindir,'\EVfiles\','sub-' num2str(subjects(ii)),'\ugdg\','run-0' num2str(rr) '_dec_dg-prop_less.txt']
        file = convertCharsToStrings(name);
        T = readtable(file);
        [N,M] = size(T);
        saveme = [subjects(ii),rr, N]
        DG_Less = [DG_Less; saveme]
        end
    end
end
        
        % After file is inputed, count the number of hits in a column.
        
        % Save that number