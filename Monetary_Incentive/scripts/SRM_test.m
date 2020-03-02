% SRM-test task
% This script presents subjects with 2 trial types: ACTIVATE and REST
% During the ACTIVATE trials, subjects are to attempt to self-activate
% the targeted region to as great a degree as possible. 
% During the REST conditions, subjects are to simply rest. 

% Version 1.0, 11/21/2011

function SRM_test(thePath, expVars)


%%%%%%%%%%%%%%%%%%%%%%%% CONSTANT DECLARED VARIABLES %%%%%%%%%%%%%%%%%%%%

% experiment parameters
n_disdaqs = 8;                  %% number of disdaq volumes to account for
activation_window = 20;         %% length of time after cue in which to attempt activation
trial_types = [0 1];            %% trial_type: rest(0); activate(1);
text_size = 42;                 %% font size for display text
trial_reps = 5;                 %% number of repitions of each trial type
TR = 1;                         %% TR (in secs)
post_target_pause = [3.5 5.5];  %% seconds of fixation in between trials


%%%%%%%%%%%%%%%%%%%%%%%% EXPERIMENT SET UP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n_trials = (length(trial_types)*trial_reps);            %% total number of trials
trial_dur = activation_window;                          %% duration of individual trial
ITIs = [];                                              %% variable to store ITIs
while length(ITIs) < n_trials
    ITIs = [ITIs Shuffle(post_target_pause)];           %% build list of ITIs
end

trial_starts = [];                                      %% start time for each trial
cue_times = [];                                         %% cue presentation times relative to start of the run
end_times = [];                                         %% end-of-trial presentation time

if isOSX
    k = getKeyboardNumber;
end

data_dir = fullfile(thePath.data, num2str(expVars.subnum));
if ~isdir(data_dir);
    mkdir(data_dir);
end

if ~isOSX
    try
        previous_runs = ls([data_dir '/SRM_test_run*.mat']);
        n_previous_runs = size(previous_runs);
        this_run_num = n_previous_runs(1) +1;
        save_fname = [data_dir '/SRM_test_run' num2str(this_run_num) '.mat'];
    catch
        save_fname = [data_dir '/SRM_test_run1.mat'];
    end
elseif isOSX
    existing_files = dir([data_dir '/SRM_test_run*']);
    n_previous_runs = size(existing_files);
    this_run_num = n_previous_runs(1) + 1;
    save_fname = [data_dir '/SRM_test_run' num2str(this_run_num) '.mat'];
end

% Build list of trial orders
trial_order = [];
while length(trial_order) < n_trials
    trial_order = [trial_order, Shuffle(trial_types)];
end


% Initialize physio recording (if a scanner run)
if expVars.isScanner == 1
    analog_obj = recordPhysio('init');
end


%%%SET UP SCREEN
screenNumber = 0; %0 = main display
screenRes = Screen('Resolution', screenNumber);
HideCursor;

%%% USE THIS LINE FOR A SMALL POP-OUT WINDOW
%screenRect = [0 0 800 600];
%[Window, Rect] = Screen('OpenWindow', screenNumber, 0, screenRect);    %open the window

%%% USE THESE LINES FOR FULL SCREEN
[Window, Rect] = Screen('OpenWindow', screenNumber);

Screen('TextSize',Window,text_size);
Screen('FillRect', Window, 0);  % 0 = black background

%%% LOAD STIMULI
%%% reading jpg files for cues, making textures, and storing as variables
cue_0 = Screen('MakeTexture', Window, imread([thePath.cues '/rest_arrow.jpg'], 'jpg'));
cue_1 = Screen('MakeTexture', Window, imread([thePath.cues '/activate_arrow.jpg'], 'jpg'));



%%%%%%%%%%%%%%%%%%%%%%%% INTRO INSTRUCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DrawFormattedText(Window, 'Welcome to the SRM task - Test Run', 'center', Rect(4)*.3, 255);
if expVars.isScanned == 1
    DrawFormattedText(Window, 'Waiting for scanner to begin...', 'center', Rect(4)*.6, 255);
else
   DrawFormattedText(Window, 'Press (t) to begin', 'center', Rect(4)*.6, 255);
end
Screen('Flip', Window);

%%%%%%%%%%%%%%%%%%%%%%%% BEGIN TRIAL LOOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if expVars.isScanned == 1
    % wait for scanner trigger
    waitForScanner()                                % call the waitForScanner function, to wait until scanner is trigger before continuing 
else
    % wait for button press
    if IsOSX
        getKey('t', k);                             % wait for 't' key before continuing
    else
        getKey('t');    
    end
end
 
% record scanner start time
scanST = GetSecs;                                  

% pause for disdaqs
DrawFormattedText(Window, '+', 'center', 'center', 255);
DrawFormattedText(Window, 'Get Ready!', 'center', .65*Rect(4), 255);
Screen('Flip', Window);
WaitSecs(n_disdaqs*TR);

% record run start time (post disdaqs)
runST = GetSecs;                                   

% start recording the physio signals (if a scanner run)
if expVars.isScanner == 1
    analog_obj = recordPhysio('start', analog_obj);
end


for t = 1:n_trials
    
    % record starttime
    trialST = GetSecs-runST;
    trial_starts(t) = trialST;

    
    %%% present cue
    if trial_order(t) == 0
        Screen('DrawTexture', Window, cue_0);
    elseif trial_order(t) == 1
        Screen('DrawTexture', Window, cue_1);
    end
    
    Screen('Flip', Window);
    cue_times(t) = GetSecs-runST;
    
    %%% display cue for entire duration of activation period
    
    %%% begin activation period
    WaitSecs(activation_window);

        
    %%% Wait trial to complete full duration plus the ITI
    elapsed_time = GetSecs - runST - trialST;
    while elapsed_time < (trial_dur + ITIs(t))
        elapsed_time = GetSecs - runST - trialST;
        DrawFormattedText(Window, '+', 'center', 'center', 255);
        Screen('Flip', Window);
    end
    
end

% record the total scan duration
scan_dur = GetSecs - scanST

% stop recording physio signals, and collect all of the data (if a scanner run)
if expVars.isScanner == 1
    analog_obj = recordPhysio('stop', analog_obj);      % stop recording
    physio = recordPhysio('getData', analog_obj);       % retrieve recorded data and timestamps from all channels
    clear analog_obj                                    % delete the analog input object (objects don't save properly)
end

% save all workspace variables
save(save_fname);

%%%%% write timing files for FSL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% empty matrix
FSL_rest = ones(n_trials/length(trial_types), 3);
FSL_activate = ones(n_trials/length(trial_types), 3);
 
% insert trial starts
FSL_rest(:,1) = trial_starts(trial_order == 0)';
FSL_activate(:,1) = trial_starts(trial_order == 1)';

% set duration
FSL_rest(:,2) = trial_dur;
FSL_activate(:,2) = trial_dur;

% write to file
dlmwrite([data_dir '/SRM_test_' num2str(this_run_num) '_REST.txt'], FSL_rest, 'delimiter', '\t');
dlmwrite([data_dir '/SRM_test_' num2str(this_run_num) '_ACTIVATE.txt'], FSL_activate, 'delimiter', '\t');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


DrawFormattedText(Window, 'Run has finished', 'center', 'center', 255);
DrawFormattedText(Window, 'Press (t) to exit', 'center', Rect(4)*.6, 255);
Screen('Flip', Window);

if IsOSX
    getKey('t', k);                                 % wait for 't' key before continuing
else
    getKey('t');
end

ShowCursor;
clear screen

end


