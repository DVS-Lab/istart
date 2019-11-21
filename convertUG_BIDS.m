function convertUG_BIDS(subj)
maindir = pwd;

try
    

    for r = 0:1

        % sub-101_task-ultimatum_run-0_raw.csv sub-102_task-ultimatum_run-1_raw.csv
        fname = fullfile(maindir,'psychopy','logs',num2str(subj),sprintf('sub-%03d_task-ultimatum_run-%d_raw.csv',subj,r));
        if exist(fname,'file')
            fid = fopen(fname,'r');
        else
            fprintf('sub-%d -- Let''s Make a Deal Game, Run %d: No data found.\n', subj, r+1)
            continue;
        end
        C = textscan(fid,repmat('%f',1,17),'Delimiter',',','HeaderLines',1,'EmptyValue', NaN);
        fclose(fid);

        
        % "Feedback" is the offer value (out of $20)
        
        onset = C{10};
        RT = C{12};
        duration = C{15};
        IsFairBlock = C{2};
        Partner = C{5};
        Offer = C{4};
        response = C{11};
        
        fname = sprintf('sub-%03d_task-ultimatum_run-%02d_events.tsv',subj,r+1); % making compatible with bids output
        output = fullfile(maindir,'bids',['sub-' num2str(subj)],'func');
        if ~exist(output,'dir')
            mkdir(output)
        end
        myfile = fullfile(output,fname);
        fid = fopen(myfile,'w');
        fprintf(fid,'onset\tduration\ttrial_type\tresponse_time\tOffer\n');
        
        for t = 1:length(onset);

            %{
  if subj_gen==0 and subj_eth==0 and subj_age > 35:
    stim_map = {
    '3': 'olderadultMale_C', --> IN-GROUP
    '2': 'youngadultMale_C', --> OUT-GROUP
    '1': 'computer',
    }
        
            %}
            
            
            %fprintf(fid,'onset\tduration\ttrial_type\tresponse_time\tPartnerKeeps\tOffer\tResponse\n');
            if (IsFairBlock(t) == 1) && (Partner(t) == 1)
                trial_type = 'computer_fair';
            elseif (IsFairBlock(t) == 1) && (Partner(t) == 2)
                trial_type = 'ingroup_fair';
            elseif (IsFairBlock(t) == 1) && (Partner(t) == 3)
                trial_type = 'outgroup_fair';
            elseif (IsFairBlock(t) == 0) && (Partner(t) == 1)
                trial_type = 'computer_unfair';
            elseif (IsFairBlock(t) == 0) && (Partner(t) == 2)
                trial_type = 'ingroup_unfair';
            elseif (IsFairBlock(t) == 0) && (Partner(t) == 3)
                trial_type = 'outgroup_unfair';
            else
                keyboard
            end
            
            % 2 is reject
            % 3 is accept
            
            if response(t) == 2
                fprintf(fid,'%f\t%f\t%s\t%f\t%d\n',onset(t),duration(t),['event_reject_' trial_type],RT(t),Offer(t));
            elseif response(t) == 3
                fprintf(fid,'%f\t%f\t%s\t%f\t%d\n',onset(t),duration(t),['event_accept_' trial_type],RT(t),Offer(t));
            elseif response(t) == 999
                fprintf(fid,'%f\t%f\t%s\t%s\t%d\n',onset(t),duration(t),'missed_trial','n/a', Offer(t));
            end
            
            block_starts = [1 9 17 25 33 41 49 57 65];
            if ismember(t,block_starts)
                fprintf(fid,'%f\t%f\t%s\t%s\t%s\n',onset(t),33.5,['block_' trial_type],'n/a','n/a');
            end
            
        end
        fclose(fid);
        
        %display payment information
        rand_trial = randsample(1:72,1);
        if response(rand_trial) == 2
            fprintf('sub-%d -- Let''s Make a Deal Game, Run %d: On trial %d, Participant REJECTED the deal and walks away with $0.\n', subj, r+1, rand_trial);
        elseif response(rand_trial) == 3
            fprintf('sub-%d -- Let''s Make a Deal Game, Run %d: On trial %d, Participant ACCEPTED the deal and walks away with $%.2f.\n', subj, r+1, rand_trial, Offer(rand_trial));
        elseif response(rand_trial) == 999
            fprintf('sub-%d -- Let''s Make a Deal Game, Run %d: On trial %d, Participant did not respond and walks away with $0.\n', subj, r+1, rand_trial);
        end
    end
    
    
catch ME
    disp(ME.message)
    msg = sprintf('check line %d', ME.stack.line);
    disp(msg);
    keyboard
end