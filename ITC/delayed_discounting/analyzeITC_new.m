% script to load in rej files and return discount parameters
% steps:  cd to subject directory, load file (dlmread), set variables, call
% ITC hyperbolic.m, write out file


% script to load in rej files and return discount parameters
% steps:  cd to subject directory, load file (dlmread), set variables, call
% ITChyperbolic.m, write out file
%%%%%

% ITChyperbolic.m needs 4 columns of data: choseDelayed,ImmedAmt,DelAmt,Delay
% choseDelayed: 0 = immediate reward, 1 = delayed reward
% ImmedAmt: magnitude of immediate reward option
% DelAmt: magnitude of delayed reward option
% Delay: Delay in days associated with delayed reward amount

% ITChyperbolic.m will output a .csv file with columns 
% containing the following information for each subject:
    % percentNow: percent of trials subjects chose the immediate option
    % percentDelayed: percent of trials subjects chose the delayed option
    % percentMissed: percent of missed trials per subject
    % k: discount factor
    % noise: self explanatory
    % LL, LL0, r2: estimates of model fit
    % percentPredicted: percentage of choices predicted by hyperbolic
    % function

clear;
maindir = pwd;

% open output files
fname = fullfile(maindir,'ITC_summary_6_2019.csv');     
fid_run = fopen(fname,'w');
fprintf(fid_run,'subnum,run,percentNow,percentDelayed,percentMissed,k,noise,LL,LL0,r2,percentPredicted\n'); %this sets up what the ITChyperbolic.m script will output

sublist = [01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17];
%sublist = [01];
for s = 1:length(sublist)
    subj = sublist(s);
    runs = 2;   %if there is only one run of trials, change to 1; 
    tmp_data = zeros(runs,9);
    for r = 1:runs
        fname = fullfile(maindir,'logs','Rej',sprintf('%02d',subj),sprintf('sub-Rej_%02d_task-intertemporalchoice_run%d_raw.csv',subj,r-1));
        fid = fopen(fname,'r');
        C = textscan(fid,[repmat('%f',1,14) '%s' repmat('%f',1,9)],'Delimiter',',','HeaderLines',1,'EmptyValue', NaN); %reads in data from .csv 
        fclose(fid);
        
        %create variables from data file to be used in ITChyperbolic.m
        choseDelayed = C{9}; 
        tmp = choseDelayed(:) == 1;
        choseDelayed(tmp) = 0;
        tmp = choseDelayed(:) == 2;
        choseDelayed(tmp) = 1;
        ImmedAmt = C{3};
        DelAmt = C{2};
        Delay = C{4};
        
        data = [choseDelayed ImmedAmt DelAmt Delay];
        [out] = ITChyperbolic(choseDelayed,ImmedAmt,DelAmt,Delay);
        
        tmp_data(r,:) = [out.percentNow,out.percentDelayed,out.percentMissed,out.k,out.noise,out.LL,out.LL0,out.r2,out.percentPredicted];
        fprintf(fid_run,'%d,%d,%f,%f,%f,%f,%f,%f,%f,%f,%f\n',subj,r,tmp_data(r,:));
    end
end
%fclose(fid_subj);
fclose(fid_run);
