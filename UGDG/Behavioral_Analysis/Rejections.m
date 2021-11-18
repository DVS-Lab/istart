%%

clear all
close all
clc

%% Rejections

values = 1002:1021;
Rejections_analyze = [];
saveme = [];
Subjects= [];

for ii = 1:length(values);
    
    try
        saveme = [];
        subj = [];
        name = ['Subject_' num2str(values(ii)) '_rejected.csv'];
        
        T = readtable(name);
        saveme = table2array(T);
        saveme = mean(table2array(T));
        subj = values(ii);
        
        
    end
    
    Rejections_analyze = [Rejections_analyze; saveme];
    Subjects = [Subjects; subj];
    
end

Rejections_final = [Subjects, Rejections_analyze];

%% DG/More

values = 1002:1021;
Accepted_analyze = [];
saveme = [];
Subjects= [];

for ii = 1:length(values);
    
    try
        saveme = [];
        subj = [];
        name = ['Subject_' num2str(values(ii)) '_more.csv'];
        
        T = readtable(name);
        saveme = table2array(T);
        saveme = mean(table2array(T));
        subj = values(ii);
        
        
    end
    
    Accepted_analyze = [Accepted_analyze; saveme];
    Subjects = [Subjects; subj];
    
end

Accepted_final = [Subjects, Accepted_analyze];


