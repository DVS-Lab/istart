function convertSharedReward_BIDS(subj)
maindir = pwd;

try
    
    
    for r = 0:1
        fname = fullfile(maindir,'psychopy','logs',num2str(subj),sprintf('sub-%03d_task-sharedreward_run-%d_raw.csv',subj,r));
        if exist(fname,'file')
            fid = fopen(fname,'r');
        else
            fprintf('sub-%d -- Gambling Game, Run %d: No data found.\n', subj, r+1)
            continue;
        end
        C = textscan(fid,repmat('%f',1,19),'Delimiter',',','HeaderLines',1,'EmptyValue', NaN);
        fclose(fid);
        
        % Partner is Friend=3, Stranger=2, Computer=1
        % Feedback is Reward=3, Neutral=2, Punishment=1
        
        
        onset = C{10};
        RT = C{13};
        duration = C{17};
        block_types = C{6};
        Partner = C{5};
        feedback = C{3};
        
        
        fname = sprintf('sub-%03d_task-sharedreward_run-%02d_events.tsv',subj,r+1); % need to make fMRI run number consistent with this?
        output = fullfile(maindir,'bids',['sub-' num2str(subj)],'func');
        if ~exist(output,'dir')
            mkdir(output)
        end
        myfile = fullfile(output,fname);
        fid = fopen(myfile,'w');
        
        fprintf(fid,'onset\tduration\ttrial_type\tresponse_time\n');
        
        for t = 1:length(onset);
            
            %fprintf(fid,'onset\tduration\ttrial_type\tresponse_time\n');
            if (feedback(t) == 1) && (Partner(t) == 1)
                trial_type = 'computer_punish';
            elseif (feedback(t) == 1) && (Partner(t) == 2)
                trial_type = 'stranger_punish';
            elseif (feedback(t) == 1) && (Partner(t) == 3)
                trial_type = 'friend_punish';
            elseif (feedback(t) == 2) && (Partner(t) == 1)
                trial_type = 'computer_neutral';
            elseif (feedback(t) == 2) && (Partner(t) == 2)
                trial_type = 'stranger_neutral';
            elseif (feedback(t) == 2) && (Partner(t) == 3)
                trial_type = 'friend_neutral';
            elseif (feedback(t) == 3) && (Partner(t) == 1)
                trial_type = 'computer_reward';
            elseif (feedback(t) == 3) && (Partner(t) == 2)
                trial_type = 'stranger_reward';
            elseif (feedback(t) == 3) && (Partner(t) == 3)
                trial_type = 'friend_reward';
            end
            
            switch block_types(t)
                case 1, block_type = 'computer_punish';
                case 2, block_type = 'computer_reward';
                case 3, block_type = 'stranger_punish';
                case 4, block_type = 'stranger_reward';
                case 5, block_type = 'friend_punish';
                case 6, block_type = 'friend_reward';
            end
            
            if RT(t) == 999 %missed response
                fprintf(fid,'%f\t%f\t%s\t%s\n',onset(t),duration(t),'missed_trial','n/a');
            else
                fprintf(fid,'%f\t%f\t%s\t%f\n',onset(t),duration(t),['event_' trial_type],RT(t));
            end
            
            
            block_starts = [1 9 17 25 33 41 49 57 65];
            if ismember(t,block_starts)
                fprintf(fid,'%f\t%f\t%s\t%s\n',onset(t),33.5,['block_' block_type],'n/a');
            end
            
        end
        fclose(fid);
        
        rand_trial = randsample(1:72,1);
        if (Partner(rand_trial) == 1)
            trial_type = 'Computer';
        elseif (Partner(rand_trial) == 2)
            trial_type = 'Stranger';
        elseif (Partner(rand_trial) == 3)
            trial_type = 'Friend';
        end
        if feedback(rand_trial) == 1 %punish
            fprintf('sub-%d -- Gambling Game, Run %d: On trial %d, Participant LOSES $5 and %s LOSES $5.\n', subj, r+1, rand_trial, trial_type);
        elseif feedback(rand_trial) == 2 %neutral
            fprintf('sub-%d -- Gambling Game, Run %d: On trial %d, Participant sees a card with a 5 on it.\n', subj, r+1, rand_trial);
        elseif feedback(rand_trial) == 3 %reward
            fprintf('sub-%d -- Gambling Game, Run %d: On trial %d, Participant WINS $5 and %s WINS $5.\n', subj, r+1, rand_trial, trial_type);
        end
        
    end
    
    
catch ME
    disp(ME.message)
    msg = sprintf('check line %d', ME.stack.line);
    disp(msg);
    keyboard
end