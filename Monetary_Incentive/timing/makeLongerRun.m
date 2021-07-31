% Rather than two runs of 50 trials, let's do one run of 75 trials
% This script generates that input.

% load run1
load('run1.mat')
ntrials = length(run.isi1); % 50 trials to start
newtrials = 25; % adding 25 trials

% keep uniform distribution of conditions
cond = [1 1 1 1 1 2 2 2 2 2 3 3 3 3 3 4 4 4 4 4 5 5 5 5 5]';
cond_rand = cond(randperm(length(cond)));

% add new ISIs with same properties as original
isi1 = zeros(25,1);
isi2 = zeros(25,1);
for i = 1:length(isi1)
    rand_idx = randperm(ntrials);
    isi1(i,1) = run.isi1(rand_idx(1));
    isi2(i,1) = run.isi2(rand_idx(1));
end

% put everything together and save
run.cond = [run.cond; cond_rand];
run.isi1 = [run.isi1; isi1];
run.isi2 = [run.isi2; isi2];
save('run3.mat','run')

