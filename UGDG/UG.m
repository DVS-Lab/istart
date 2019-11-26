%% Initialization

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

trials= 72; % number of conditions
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

% 1 will define UG_Proposer, 2 defines DG_Proposer, 3 defines UG_Recipient

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

% Each column is a participant

%% Partner Matrix:

% Randomly select a number between 1 and 2 without replacement

% Make a vector with the number of trials.

num_partners = trials/2;

% 1 will define UG_Proposer, 2 defines DG_Proposer, 3 defines UG_Recipient

a(1:num_partners, 1) = 1;
b(1:num_partners, 1) = 2;

% Make a Partner_Matrix for all 200 participants

partners = [a;b];

Partner_Matrix= [];

for ii = 1:subjects
    partner_block = partners(randperm(length(partners))); % Shuffle the blocks.
    Partner_Matrix = [Partner_Matrix, partner_block];
end

% Each column is a participant

%% ITI Waiting Matrix

% % Make a vector that is .75 for seven trials. Then put in a number that is
% % between 8 and 12, even. Repeat this sequence so that there are 48 trials.
%         
% 
% start = repelem(.75, 7);
% even_vecs = [8,10,12];
% 
% repeat_loop = trials/(length(start)+1); % Repeat loop for selected number of trials.

% Dave's Code:

ITI_list = [repmat(2,1,round(trials*(18/36))) repmat(4,1,round(trials*(10/36))) repmat(6,1,round(trials*(5/36))) repmat(8,1,round(trials*(3/36)))];
ITI_list = ITI_list(randperm(length(ITI_list)))';

% Participant

% Participant_ITI = [];
% 
% for ii = 1: repeat_loop
%     short_vec = even_vecs(randperm(length(even_vecs))); % Randomly pic an even number
%     short_vec = short_vec(1,1); % Take the first element
%     short_vec = [start,short_vec]; % Concatenate them together.
%     Participant_ITI = [Participant_ITI, short_vec];
% end
% 
% % Now let's make a matrix size(for all participants

ITI_Matrix = [];

 for ii = 1:subjects
     Temp_ITI = ITI_list(randperm(length(ITI_list))); % take the ITI_list and shuffle
     ITI_Matrix = [ITI_Matrix, Temp_ITI]; % Add it in
 end

% for ii = 1:subjects
% 
% Shuffled_ITI = Participant_ITI(randperm(length(Participant_ITI))); % Shuffle the time
% ITI_Matrix = [ITI_Matrix; Shuffled_ITI];
% 
% end

%% ISI Waiting Matrix

% % Make a vector that is .75 for seven trials. Then put in a number that is
% % between 8 and 12, even. Repeat this sequence so that there are 48 trials.
% 
% start = repelem(.75, 7);
% even_vecs = [8,10,12];
% 
% repeat_loop = trials/(length(start)+1); % Repeat loop for selected number of trials.
% 
% % Participant
% 
% Participant_ISI = [];
% 
% for ii = 1: repeat_loop
%     short_vec = even_vecs(randperm(length(even_vecs))); % Randomly pic an even number
%     short_vec = short_vec(1,1); % Take the first element
%     short_vec = [start,short_vec]; % Concatenate them together.
%     Participant_ISI = [Participant_ISI, short_vec];
% end

% Dave's code:

ISI_list = [repmat(2,1,round(20/36*trials)) repmat(3.5,1,round(10/36*trials)) repmat(5,1,round(6/36*trials))];
ISI_list = ISI_list(randperm(length(ISI_list)));
ISI_list = (ISI_list - 1.5)'; %shaving 1.5 seconds to account for "WAITING" screen

ISI_Matrix = [];

 for ii = 1:subjects
     Temp_ISI = ISI_list(randperm(length(ISI_list))); % take the ISI_list and shuffle
     ISI_Matrix = [ISI_Matrix, Temp_ISI]; % Add it in
 end

% Now let's make a matrix for all participants

% ISI_Matrix = [];

% for ii = 1:subjects
% 
% Shuffled_ISI = Participant_ISI(randperm(length(Participant_ISI))); % Shuffle the times
% ISI_Matrix = [ISI_Matrix; Shuffled_ISI];
% 
% end
% 
% ISI_Matrix = ISI_Matrix';

%% Proposer Matrix for DG and UG

% We are hard coding, assuming 48 trials.

A = combnk(0.06:0.13:0.48,2); % Combinations we will use for proposers
B = fliplr(A); % To counterbalance.
Proposer_Options = [A; B;A;B;A;B;A;B;A;B;A;B;]; % Now the options are counterbalanced 

% We now have a pool of 50 combinations to choose from.

% We need to randomly select 48 of these rows.

rows =[1:(trials*(2/3))]; % Number of desired rows
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


%% Recipient Matrix for UG

Recipient_Options = [0.05 0.15 0.25 0.35 0.45]; % Pool of options
Recipient_Options = [Recipient_Options,Recipient_Options,Recipient_Options,Recipient_Options,Recipient_Options]; % Repeated five times.

% Shuffle the recipient options

rows =[1:(trials*(1/3))]; % Number of desired rows
shuffled_rows = rows(randperm(length(rows))); % Randomly select a number from 1 through rows

% Pick a random number between 1 and 24. Index that number from
% Recipient_Options. Add it in to that vector.

Recipient_Pool = [];
for ii = 1:length(rows)
    % Index from shuffled_row
    Take = Recipient_Options(shuffled_rows(ii)); % Take a random number from 1 through 24 and use that as the row
    Recipient_Pool = [Recipient_Pool; Take];
end


%% Combine all information for each Subject and save it as a CSV file.

% This is a convoluted set of for loops.

% We are taking all the matrices and merging them in for a chosen
% participant.

% Once we have identified a participant, we do a set of operations.

% The operations take the endowment and assign it according to a randomly
% selected proportion to split between a binary choice.

% This is added to the participant matrix and then saved as an array and
% exported as a CSV file.

for jj=1:subjects

    % Pick a participant

        participant = [trial_vec, Block_Matrix(:,jj), Endowment_Matrix(:,jj), ITI_Matrix(:,jj), ISI_Matrix(:,jj)]; % Trial, Partner, Task type, Endowment Amount

            % Now we want to make the UG and DG proposer amounts.
            % Logically index 1 and 2 on the second column as Proposers
            % 3 indexes Recipient

            Proposer_Ind = find(participant(:,2) < 3);
            Recipient_Ind = find(participant(:,2) == 3);

            % Now lets shuffle the proposer and recipient distributions.

             shuffled_proposer = [];
             shuffled = randperm(length(Proposer_Pool));

             for ii = 1:length(shuffled)
                 Proportions = Proposer_Pool(shuffled(ii),:); % Take a shuffled number to index from the proposer_pool
                 shuffled_proposer = [shuffled_proposer; Proportions];
             end

             % We now have a shuffled proposer distribution to sample from.

            shuffled_recipient = Recipient_Pool(randperm(length(Recipient_Pool)));

            proposer = [];

            % Let's take the shuffled proposer distribution and apply it to
            % the UG/DG endowments to make binary choices.

            for ii = 1:length(Proposer_Ind)
                 % Take the row corresponding to the index
                 row = participant((Proposer_Ind(ii)),:);
                 % Now we take the shuffled_proposer for the ii row. And multiply by the endowment.
                 options = row(3) * shuffled_proposer(ii,:);
                 options = [row,options];
                 proposer = [proposer; options]; % Concatenate
            end

             recipient = [];
            for ii = 1:length(Recipient_Ind);
                 % Take the row corresponding to the index
                 row = participant((Recipient_Ind(ii)),:);
                 % Now we take the shuffled_proposer for the ii row. And multiply by the endowment.
                 options = row(3) * shuffled_recipient(ii,:);
                 options = [row,options, 0]; % The right option will be zero. If you refuse, you get nothing.
                 recipient = [recipient; options]; % Concatenate
            end

            % Now we have both proposer and recipient binary choices for a
            % given participant. % test

    participant = [proposer; recipient]; % Concatenated
    participant = sortrows(participant); % Sorted along trials.

    % Convert the file into an array. Put a header for each column.

    participant = array2table(participant(1:end,:),'VariableNames', {'nTrial', 'Block', 'Endowment', 'ITI', 'ISI', 'L_Option', 'R_Option' });
    %name = 'Subject_jj.csv';
    name = "Subject_" + jj + '.csv';

    % Save array as a CSV file

    writetable(participant, name); % Save as csv file
end
