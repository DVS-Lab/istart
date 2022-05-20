function MID2(isscan, subnum)
Screen('Preference', 'SkipSyncTests', 1);
global thePath; rand('state',sum(100*clock));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%subnum - subject number is 0 for practice, real number if it is a run
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subnum = input('subnumber: ');
isscan = input('is scan(practice = 0 scan = 1): ');
whichrun = input('which run (just enter 1):'); 


% Add this at top of new scripts for maximum portability due to unified names on all systems:
KbName('UnifyKeyNames');
Screen('Preference','VisualDebuglevel', 0);

thePath.start = pwd;                                % starting directory
thePath.data = fullfile(thePath.start, 'data');     % path to Data directory
thePath.scripts = fullfile(thePath.start, 'scripts');
thePath.stims = fullfile(thePath.start, 'stimuli');
thePath.timing = fullfile(thePath.start, 'timing');

addpath(thePath.scripts)
addpath(thePath.stims)
addpath(genpath(thePath.data))
addpath(thePath.timing)

% set up device number
if IsOSX
    k = GetKeyboardIndices;
else
    k = 1;
end

%%%%%% CONSTANT DECLARED VARIABLES %%%%%%%%%%%%%%%

text_size = 40;
ms=0.06;                    %duration of time post-target until responses are accepted (no keys accepted)
cue_time = 1;
target_time = 1;
feedback_time = 1;

load([ thePath.start '/timing/run' num2str(whichrun) '.mat'])

%define intertrial fixation
fix_isi = run.isi2;
fix_iti = run.isi1;
trial_cond = run.cond;

backtick = '=';
mkdir([thePath.data '/sub-' num2str(subnum)]);

RTs  =[];

try
    practice_files = ls([fullfile(thePath.data ,num2str(subnum)),'/practice_array.mat']);
catch
    practice_files = [];
end

if ~isempty(practice_files)                             % checks to see whether there is practice data or not. Overwrite if there is
    load(practice_files(end,1:end),'RTs'); % practice_files has an extra space character added to the string name, hence the 1:end-1 in the code
end

for i=1:length(unique(trial_cond))                     % sets starting RT_thresh for each condition
    if isempty(practice_files)
        [RT_thresh(i)] = set_MID_threshold([]);
    else
        [RT_thresh(i)] = set_MID_threshold(RTs(:,trial_cond(i)));
    end
end

Screen('CloseAll')

%%%SET UP SCREEN PARAMETERS FOR PTB

%PsychDefaultSetup(2);


screens = Screen('Screens');
screenNumber = max(screens);
HideCursor;
[Screen_X, Screen_Y]=Screen('WindowSize',screenNumber);

%USE THESE LINES FOR SET SCREEN
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;

%[w, rect] = PsychImaging('OpenWindow', 0, 0.5);

screenRect = [ 0 0 1024 768];
[Window, Rect] =PsychImaging('OpenWindow', screenNumber, grey);
Hcenter=Rect(3)/2
Vcenter=Rect(4)/2

Screen('TextFont', Window, 'Arial');
Screen('TextSize',Window,text_size);
Screen('FillRect', Window, grey);  % 0 = black background



trial_starts = []; %trial starts not including saturation scans

% LOAD STIMULI
%DrawFormattedText(Window, 'loading stimuli....', 'center', 'center', 255);


[normBoundsRect, notused] = Screen('TextBounds', Window, 'loading stimuli....');
Screen('DrawText',Window, 'loading stimuli....', Hcenter-normBoundsRect(3)/2, Vcenter-normBoundsRect(4)/2, [255 255 255]);
Screen('Flip', Window);
WaitSecs(3)

%LOAD IN FIXATIONS
fix1 = Screen('MakeTexture', Window, imread(fullfile(thePath.stims,'cross'), 'png'));
fix2 = Screen('MakeTexture', Window, imread(fullfile(thePath.stims,'dot'), 'png'));

% LOAD MID STIMULI
high_cue_gain = Screen('MakeTexture', Window, imread(fullfile(thePath.stims,'mid_high_gain'), 'png'));
high_cue_loss = Screen('MakeTexture', Window, imread(fullfile(thePath.stims,'mid_high_loss'), 'png'));
low_cue_gain = Screen('MakeTexture', Window, imread(fullfile(thePath.stims,'mid_low_gain'), 'png'));
low_cue_loss = Screen('MakeTexture', Window, imread(fullfile(thePath.stims,'mid_low_loss'), 'png'));
neutral_cue = Screen('MakeTexture', Window, imread(fullfile(thePath.stims,'mid_neutral'), 'png'));
target = Screen('MakeTexture', Window, imread(fullfile(thePath.stims,'target'), 'png'));

[normBoundsRect, notused] = Screen('TextBounds', Window,'Get Ready for the Experiment!' );
Screen('DrawText',Window, 'Get Ready for the Experiment!', Hcenter-normBoundsRect(3)/2,Vcenter-normBoundsRect(4)/2,[255 255 255]);
Screen('Flip', Window);

%%%%%%%%%%%%%%%%%%%%%%%% BEGIN TRIAL LOOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% record run start time (post disdaqs) CHECK ON WHEN IT SENDS TRIGGER

if IsOSX
    getKey(backtick, k);                             % wait for backtick before continuing
else
    getKey(backtick);
end

runST = GetSecs;
Screen('DrawTexture', Window, fix1);
Screen('Flip', Window);
WaitSecs(4);


for t = 1:length(trial_cond)

    if trial_cond(t) == 1
        Screen('DrawTexture', Window, high_cue_gain);
    elseif trial_cond(t) == 2
        Screen('DrawTexture', Window, high_cue_loss);
    elseif trial_cond(t) == 3
        Screen('DrawTexture', Window, low_cue_gain);
    elseif trial_cond(t) == 4
        Screen('DrawTexture', Window, low_cue_loss);
    elseif trial_cond(t) == 5
        Screen('DrawTexture', Window, neutral_cue);
    end

    stimST = Screen('Flip', Window);
    WaitSecs(cue_time)

    Screen('DrawTexture', Window, fix2);
    Screen('Flip', Window);
    WaitSecs(fix_isi(t))

    Screen('DrawTexture', Window, target);
    targetST = Screen('Flip', Window);
    RT =[999];
    [keys, RT] = recordKeysNoBT(GetSecs, target_time, k, backtick);

    %Present Feedback
    if RT(1) == 0;
         if trial_cond(t)==1
                text_feedback = 'You DID NOT EARN a triangle.';
            elseif trial_cond(t)==2
                text_feedback = 'You LOST a triangle.';
            elseif trial_cond(t)==3
                text_feedback = 'You DID NOT EARN a square.';
            elseif trial_cond(t)==4
                text_feedback = 'You LOST a square.';
            elseif trial_cond(t)==5
                text_feedback = 'Your bank is the same.';
            end


    elseif RT(1) < RT_thresh(trial_cond(t))

            output.outcome(t) = 1;

            if trial_cond(t)==1
                text_feedback = 'You EARNED a triangle!';
            elseif trial_cond(t)==2
                text_feedback = 'You DID NOT LOSE a triangle!';
            elseif trial_cond(t)==3
                text_feedback = 'You EARNED a square!';
            elseif trial_cond(t)==4
                text_feedback = 'You DID NOT LOSE a square!';
            elseif trial_cond(t)==5
                text_feedback= 'Your bank is the same';
            end
       else
            output.outcome(t) = 0;

            if trial_cond(t)==1
                text_feedback = 'You DID NOT EARN a triangle.';
            elseif trial_cond(t)==2
                text_feedback = 'You LOST a triangle.';
            elseif trial_cond(t)==3
                text_feedback = 'You DID NOT EARN a square.';
            elseif trial_cond(t)==4
                text_feedback = 'You LOST a square.';
            elseif trial_cond(t)==5
                text_feedback = 'Your bank is the same.';
            end
        end
        [normBoundsRect, notused] = Screen('TextBounds', Window,text_feedback);
        Screen('DrawText',Window, text_feedback, Hcenter-normBoundsRect(3)/2,Vcenter-normBoundsRect(4)/2,[255 255 255]);
        Screen('Flip', Window);
        WaitSecs(feedback_time)

        %Update Thresholds
        RTs(end+1, trial_cond(t)) = RT(1);
        [RT_thresh(trial_cond(t))] = set_MID_threshold(RTs(:,trial_cond(t)));
        output.trial_starts(t) = stimST-runST;
        output.target_starts(t) = targetST-runST;
        output.RT(t) = RT(1);
        output.thresh(t) = RT_thresh(trial_cond(t));

        Screen('DrawTexture', Window, fix1);
        Screen('Flip', Window);
        WaitSecs(fix_iti(t))
end
WaitSecs(6)
if isscan == 0
    save([thePath.data '/sub-' num2str(subnum) '/practice_array.mat'], 'RTs')
elseif isscan == 1
  save([thePath.data '/sub-' num2str(subnum) '/run-' num2str(whichrun) '_output.mat'], 'output')
end

sca;