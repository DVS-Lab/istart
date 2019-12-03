%% Initialization

clear all
close all
clc

% This script analyzes the Pilot Data for ISTART

% Daniel Sazhin
% 11/22/2019

%% Read in the data

% Path is from BIDS WIP in Github- ISTART

tdfread('sub-999_task-ultimatum_run-0_events.tsv');

% Seperate results into seperate games

%% Turn Cell Array into Matrix

% It's easier for me to work with matrices. 

% Take Endowment and turn into matrix

BlockMat = [];
for ii = 1:length(Block)
    row = str2num(Block(ii,:));
    BlockMat = [BlockMat; row];
end   


EndowmentMat = [];
for ii = 1:length(Endowment)
    row = str2num(Endowment(ii,:));
    EndowmentMat = [EndowmentMat; row];
end   

% Take Onset and turn into matrix

OnsetMat = [];
for ii = 1:length(Onset)
    row = str2num(Onset(ii,:));
    OnsetMat = [OnsetMat; row];
end  

% Take R_Option and turn into matrix

R_OptionMat = [];
for ii = 1:length(R_Option)
    row = str2num(R_Option(ii,:));
    R_OptionMat = [R_OptionMat; row];
end   

% Take L_Option and turn into matrix

L_OptionMat = [];
for ii = 1:length(L_Option)
    row = str2num(L_Option(ii,:));
    L_OptionMat = [L_OptionMat; row];
end   


% Take Trial and turn into matrix

TrialMat = [];
for ii = 1:length(Trial)
    row = str2num(Trial(ii,:));
    TrialMat = [TrialMat; row];
end

% Take Response and turn into matrix

% ResponseMat is a bit trickier because the rows do not line up exactly due
% to some weird Trials. We will line this matrix up with the rest by:

% Go through each row of Trial.

% If there is an integer in the row, save the corresponding row in
% Response.

ResponseMat = [];

for ii = 1:length(Trial)
    testrow = str2num(Trial(ii,:));
    if testrow > 0;
        saverow = str2num(Response(ii,:));  
        ResponseMat = [ResponseMat; saverow];
    end

end

% Same deal with Response time.

% Take Response_Time and turn into matrix

Response_TimeMat = [];
for ii = 1:length(Trial)
    testrow = str2num(Trial(ii,:));
    if testrow > 0;
        saverow = str2num(Response_Time(ii,:));  
        Response_TimeMat = [Response_TimeMat; saverow];
    end

end

% Onset Matrix (We will leave for later.
% 
% % Onset has a lot of missing values. We will put in zero for the reasonable
% % rows.
% 
% OnsetMat = [];
% for ii = 1:length(Trial)
%     testrow = str2num(Trial(ii,:));
%     if testrow > 0;
%         saverow = str2num(OnsetMat(ii,:));
%         catch
%             saverow == 0;
%         end    
%         OnsetMat = [OnsetMat; saverow];
%     end
% 
% end

%% Concatenate into one matrix

Sub1 = ones(72,1);
Sub2 = 2*(ones(72,1));
Sub3 = 3*(ones(72,1));
Sub4 = 4*(ones(72,1));

SubColumn = [Sub1;Sub2;Sub3;Sub4];

AnalysisMat = [TrialMat, BlockMat, EndowmentMat, L_OptionMat, R_OptionMat, ResponseMat, Response_TimeMat,SubColumn]; % Onset Matrix is left out for now.

% Columns are- 1: Trial, 2: Block, 3: Endowment, 4: LOption, 5: ROption, 6: Response,
% 7: Response time, 8: Subject Number];

% Let's save subject number % Hard coded for now. But easier to do pilot
% analysis.
    



%% Eliminate misses

% Go through the rows. Get rid of 999s.

AnalysisMat2 = [];

for ii = 1:length(AnalysisMat)
    row = AnalysisMat(ii,:);
    if row(6) == 2
        AnalysisMat2 = [AnalysisMat2; row];
    end    
    if row(6) == 3
        AnalysisMat2 = [AnalysisMat2; row];
    end    
end   

%% Blocks split for analysis

% 1 will define UG_Proposer, 2 defines DG_Proposer, 3 defines UG_Recipient

UG_Proposer = [];
DG_Proposer = [];
UG_Recipient = [];
    
for ii = 1:length(AnalysisMat2)
    row = AnalysisMat2(ii,:);
    if row(2) == 1
        UG_Proposer = [UG_Proposer; row];
    end    
    if row(2) == 2
        DG_Proposer = [DG_Proposer; row];
    end    
    if row(2) == 3
        UG_Recipient = [UG_Recipient; row];
    end    
end   


%% Figure out the total earnings for DG_Proposer

% If subject selected option 2, then save value.
% If subject selected option 3, then save that value.
% Sum the column for the subject. 

DG_Proposer_Earnings = [];

for ii = 1:length(DG_Proposer)
    row = DG_Proposer(ii,:);
    if row(6) == 2; % If you selected left option
        ProportionEndowment = row(4)/row(3);
        saveme = [row(4),ProportionEndowment,row(8)]; % Save value and subject number
        DG_Proposer_Earnings = [DG_Proposer_Earnings; saveme];
    end
    
    if row(6) == 3; % If you selected right option
        ProportionEndowment = row(4)/row(3);
        saveme = [row(5),ProportionEndowment,row(8)]; % Save value
        DG_Proposer_Earnings = [DG_Proposer_Earnings; saveme];
    end
end    


%% Figure out the total earnings for UG_Recipient

% This is easy. This is all accepted offers.

% If subject selected option 2, then save value.
% If subject selected option 3, then save that value.
% Sum the column for the subject. 

UG_Recipient_Earnings = [];

for ii = 1:length(UG_Recipient)
    row = UG_Recipient(ii,:);
    if row(6) == 2; % If you selected left option
        ProportionEndowment = row(4)/row(3);
        saveme = [row(4),ProportionEndowment,row(8)]; % Save value and subject number
        UG_Recipient_Earnings = [UG_Recipient_Earnings; saveme];
    end
    
    if row(6) == 3; % If you selected right option
        ProportionEndowment = row(4)/row(3);
        saveme = [row(5),ProportionEndowment,row(8)];
        UG_Recipient_Earnings = [UG_Recipient_Earnings; saveme];
    end
end    

%% Figure out the RAW earnings for UG_Recipient

% This does not include the likelihood of getting rejected.

% If subject selected option 2, then save value.
% If subject selected option 3, then save that value.
% Sum the column for the subject. 

UG_Proposer_Earnings = [];

for ii = 1:length(UG_Proposer)
    row = UG_Proposer(ii,:);
    if row(6) == 2; % If you selected left option
        ProportionEndowment = row(4)/row(3);
        saveme = [row(4),ProportionEndowment,row(8)]; % Save value and subject number
        UG_Proposer_Earnings = [UG_Proposer_Earnings; saveme];
    end
    
    if row(6) == 3; % If you selected right option
        ProportionEndowment = row(4)/row(3);
        saveme = [row(5),ProportionEndowment,row(8)]; % Save value
        UG_Proposer_Earnings = [UG_Proposer_Earnings; saveme];
    end
end    






