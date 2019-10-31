%% 0 - Initialization

clear all
close all
clc

% 09/05/2019
% Daniel Sazhin

% The goal is to make a random order of endowments and trial orders for
% participants in the ISTART project while doing the Ultimatum Game tasks. 

% There are three main conditions- UG Proposer, UG Responder, and DG
% Proposer.

% 48 total trials per participant

% 16 trials per task (48/3)

% Endowment should be randomly selected from a uniform distribution between
% 15-25, only odd values.

% Make 200 trials.

trials= 48; % number of conditions
subjects = 200; % number of total possible subjects

%% Endowment Distribution

% The goal is to make a matrix of endowments for each subject. 

% Step 1: Define values which will be sampled.

Values = [15:2:25]; % Categories of endowments.

% Step 2: Uniformly sample from Endowments for the 48 trials.

Endowments = randsample(Values,trials,true); % Randomly sampled with replacement from a uniform distribution

% Make a matrix of endowments.

Endowment_Matrix= [];

for ii = 1:subjects
    Subject_Endowment = randsample(Values,trials,true);
    Endowment_Matrix = [Endowment_Matrix; Subject_Endowment];
end   

Endowment_Matrix = Endowment_Matrix'; % Each column is a participant. 

%% Column of number of trials

trial_vec = [1:trials]';

%% Randomly select a number between 1 and 3 without replacement

% Make a vector with the number of trials.

num_trials = trials/3;

% 1 will define UG_Proposer, 2 defines UG_Recipient, 3 defines DG_Proposer

a(1:num_trials, 1) = 1;
b(1:num_trials, 1) = 2;
c(1:num_trials, 1) = 3;

% Make a Block_Matrix for all 200 participants

blocks = [a;b;c];

Block_Matrix= [];
for ii = 1:subjects
    participant_block = blocks(randperm(length(blocks))); % Shuffle the blocks. 
    Block_Matrix = [Block_Matrix, participant_block];
end   

Block_Matrix = Block_Matrix'; % Each column is a participant


  

%% Dave's script for UG 

maindir = pwd;
outfiles = fullfile(maindir,'psychopy','params','UG_blocks');
mkdir(outfiles);

for s = [101:299 999]
    subout = fullfile(outfiles,sprintf('sub-%03d',s));
    mkdir(subout);
    
    if rand < 0.5
        block_types1 = [1:6 1 2 3];
        block_types2 = [1:6 4 5 6];
    else
        block_types2 = [1:6 1 2 3];
        block_types1 = [1:6 4 5 6];
    end
    
    for r = [1 2]
        
        % 9 blocks per run (2 runs)
        pre_block_ITI = [repmat(8,1,3) repmat(10,1,3) repmat(12,1,3)]; % some ITI jitter to estimate Fair/Unfair separately (HCP is fixed at 15 s)
        pre_block_ITI = pre_block_ITI(randperm(length(pre_block_ITI)));
        % this occurrs every 8 trials, starting with trial 1. it should come first
        % need to add at least 12 s at the end of the experiment to catch last HRF
        
        if r == 1
            block_types = block_types1;
        else
            block_types = block_types2;
        end
        block_types = block_types(randperm(length(block_types)));
        keep_checking = 1;
        while keep_checking
            repeats = 0;
            block_types = block_types(randperm(length(block_types)));
            for i = 1:length(block_types)-1
                if block_types(i) == block_types(i+1)
                    repeats = repeats + 1;
                end
            end
            if ~repeats
                keep_checking = 0;
            end
        end
        
        
        fname = fullfile(subout,sprintf('sub-%03d_run-%02d_design.csv',s,r));
        fid = fopen(fname,'w');
        fprintf(fid,'Trialn,Blockn,Partner,IsFairBlock,Offer,ITI\n');
        
        nblocks = length(block_types);
        rand_trials = randperm(nblocks);
        t = 0;
        for i = 1:nblocks
            % Partner is Friend=3, Stranger=2, Computer=1
            % "Feedback" is the offer value (out of $20)
            
            % start with 20
            fair = [10 9 8 7];
            unfair = [1 2 3 4];
            neutral = [5 6];
            
            unfair_block = [randsample(unfair,1) randsample(unfair,1) randsample(unfair,1) randsample(unfair,1) randsample(unfair,1) randsample(unfair,1) randsample(fair,1) randsample(neutral,1)];
            unfair_block = unfair_block(randperm(length(unfair_block)));
            fair_block = [randsample(fair,1) randsample(fair,1) randsample(fair,1) randsample(fair,1) randsample(fair,1) randsample(fair,1) randsample(unfair,1) randsample(neutral,1)];
            fair_block = fair_block(randperm(length(fair_block)));
            
            switch block_types(i)
                case 1 %Computer Unfair
                    partner = 1;
                    feedback_mat = unfair_block;
                    isfair = 0;
                case 2 %Computer Fair
                    partner = 1;
                    feedback_mat = fair_block;
                    isfair = 1;
                case 3 %Stranger Unfair
                    partner = 2;
                    feedback_mat = unfair_block;
                    isfair = 0;
                case 4 %Stranger Fair
                    partner = 2;
                    feedback_mat = fair_block;
                    isfair = 1;
                case 5 %Friend Unfair
                    partner = 3;
                    feedback_mat = unfair_block;
                    isfair = 0;
                case 6 %Friend Fair
                    partner = 3;
                    feedback_mat = fair_block;
                    isfair = 1;
            end
            
            %fprintf(fid,'Trialn,Blockn,Partner,IsFairBlock,Offer,ITI\n');
            for f = 1:length(feedback_mat)
                t = t + 1;
                if f == length(feedback_mat)
                    fprintf(fid,'%d,%d,%d,%d,%d,%d\n',t,i,partner,isfair,feedback_mat(f),pre_block_ITI(i));
                else
                    fprintf(fid,'%d,%d,%d,%d,%d,%f\n',t,i,partner,isfair,feedback_mat(f),0.75);
                end
            end
        end
        fclose(fid);
        
    end
end