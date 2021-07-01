function convertUG_BIDS_Choice(subj)
maindir = pwd;

%try

for r = 0:1
    
    % sub-101_task-ultimatum_run-0_raw.csv sub-102_task-ultimatum_run-1_raw.csv
    fname = fullfile(maindir,'logs',num2str(subj),sprintf('sub-%04d_task-ultimatum_run-%d_raw.csv',subj,r)); % Psychopy taken out from Logs to make work for now.
    if exist(fname,'file')
        fid = fopen(fname,'r');
    else
        fprintf('sub-%d -- Let''s Make a Deal Game, Run %d: No data found.\n', subj, r+1)
        continue;
    end
    C = textscan(fid,repmat('%f',1,23),'Delimiter',',','HeaderLines',1,'EmptyValue', NaN);
    fclose(fid);
    
    
    % "Feedback" is the offer value (out of $20)
    
    decision_onset = C{16};
    endowment_onset = C{12};
    endowment_offset = C{13};
    onset = C{11};
    RT = C{18};
    duration = C{21};
    Block = C{3};
    Endowment = C{4};
    response = C{17};
    response = round(response);
    L_Option = C{7};
    R_Option = C{8};
    
    fname = sprintf('sub-%03d_task-ultimatum_run-%02d_events.tsv',subj,r+1); % making compatible with bids output
    output = fullfile(maindir,'bids',['sub-' num2str(subj)],'func');
    if ~exist(output,'dir')
        mkdir(output)
    end
    myfile = fullfile(output,fname);
    fid = fopen(myfile,'w');
    fprintf(fid,'onset\tduration\ttrial_type\tresponse_time\tEndowment\tDeMeaned\n');
    
    for t = 1:length(onset);
        
        %% Block level endowment means
        
        % We need to split up the endowments per the blocks. Then take the
        % mean of those blocks. We do this to generate the parametric
        % regressors, which require the demeaned endowment

        
        Block1Mean = [];
        Block2Mean = [];
        Block3Mean = [];
        
        for ii = 1:length(Block)
            
        if (Block(ii) == 1)
            Block1Mean = [Block1Mean;Endowment(ii)];
           
        elseif (Block(ii) == 2)
            Block2Mean = [Block2Mean;Endowment(ii)];
            
        elseif (Block(ii) == 3)
            Block3Mean = [Block3Mean;Endowment(ii)];
            
        end   
            
        end
        
Block1Mean = mean(Block1Mean);
Block2Mean = mean(Block2Mean);
Block3Mean = mean(Block3Mean);
        
        
        %fprintf(fid,'onset\tduration\ttrial_type\tresponse_time\tPartnerKeeps\tOffer\tResponse\n');
        if (Block(t) == 1)
            trial_type = 'dec_ug-prop';
        elseif (Block(t) == 2)
            trial_type = 'dec_dg-prop';
        elseif (Block(t) == 3)
            trial_type = 'dec_ug-resp';
        else
            keyboard
        end
        
        % 2 is reject
        % 3 is accept
        % 999 is miss
        
        % L_option
        % R_Option
        
        if response(t) == 999
            fprintf(fid,'%f\t%d\t%s\t%s\t%d\t%s\n',decision_onset(t),4,'missed_trial','n/a', Endowment(t),'n/a');
        end
        
        if Block(t) == 3
            if response(t) == 2
                if round(L_Option(t)) > 0;
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\n',decision_onset(t),RT(t),[trial_type '_choice'],RT(t),Endowment(t),'n/a');
                else
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\n',decision_onset(t),RT(t),[trial_type '_choice'],RT(t),Endowment(t),'n/a');
                end
            end
            
            if response(t) == 3
                if round(R_Option(t)) > 0;
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\n',decision_onset(t),RT(t),[trial_type '_choice'],RT(t),Endowment(t),'n/a');
                else
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\n',decision_onset(t),RT(t),[trial_type '_choice'],RT(t),Endowment(t),'n/a');
                end
            end
        end
        
        
        if Block(t) == 2
            if response(t) == 2
                if L_Option(t) > R_Option(t);
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\n',decision_onset(t),RT(t),[trial_type '_choice'],RT(t),Endowment(t),'n/a');
                else
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\n',decision_onset(t),RT(t),[trial_type '_choice'],RT(t),Endowment(t),'n/a');
                end
            end
            
            
            if response(t) == 3
                if L_Option(t) > R_Option(t);
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\n',decision_onset(t),RT(t),[trial_type '_choice'],RT(t),Endowment(t),'n/a');
                else
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\n',decision_onset(t),RT(t),[trial_type '_choice' ],RT(t),Endowment(t),'n/a');
                end
            end
        end
        
        if Block(t) == 1
            if response(t) == 2
                if L_Option(t) > R_Option(t);
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\n',decision_onset(t),RT(t),[trial_type '_choice' ],RT(t),Endowment(t),'n/a');
                else
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\n',decision_onset(t),RT(t),[trial_type '_choice'],RT(t),Endowment(t),'n/a');
                end
            end
            
            if response(t) == 3
                if L_Option(t) > R_Option(t);
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\n',decision_onset(t),RT(t),[trial_type '_choice'],RT(t),Endowment(t),'n/a');
                else
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\t%s\n',decision_onset(t),RT(t),[trial_type '_choice'],RT(t),Endowment(t),'n/a');
                end
            end
        end
        
        %% Adding in the cue onsets
        
        %cue_dict
        %cue_ug-resp
        %cue_ug-prop
        
        %fprintf(fid,'onset\tduration\ttrial_type\tresponse_time\tPartnerKeeps\tOffer\tResponse\n');
        if (Block(t) == 1)
            trial_type = 'cue_dict';
            fprintf(fid,'%f\t%d\t%s\t%s\t%d\t%s\n',onset(t),2,[trial_type],'n/a',Endowment(t),'n/a');
        elseif (Block(t) == 2)
            trial_type = 'cue_ug-resp';
            fprintf(fid,'%f\t%d\t%s\t%s\t%d\t%s\n',onset(t),2,[trial_type],'n/a',Endowment(t),'n/a');
        elseif (Block(t) == 3)
            trial_type = 'cue_ug-prop';
            fprintf(fid,'%f\t%d\t%s\t%s\t%d\t%s\n',onset(t),2,[trial_type],'n/a',Endowment(t),'n/a');
        else
            keyboard
        end
        
        
        
        %% Add in Cue Parametric regressors
       
       % These regressors play with the endowment. 1) Demean them and take
       % the difference.
       
    Endowment_Mean = mean(Endowment);
       
       if (Block(t) == 1)
            trial_type = 'cue_dict_parametric';
            fprintf(fid,'%f\t%d\t%s\t%s\t%d\t%d\n',onset(t),2,[trial_type],'n/a',Endowment(t),Endowment(t)-Block1Mean);
        elseif (Block(t) == 2)
            trial_type = 'cue_ug-resp_parametric';
            fprintf(fid,'%f\t%d\t%s\t%s\t%d\t%d\n',onset(t),2,[trial_type],'n/a',Endowment(t),Endowment(t)-Block2Mean);
        elseif (Block(t) == 3)
            trial_type = 'cue_ug-prop_parametric';
            fprintf(fid,'%f\t%d\t%s\t%s\t%d\t%d\n',onset(t),2,[trial_type],'n/a',Endowment(t),Endowment(t)-Block3Mean);
        else
            keyboard
       end
        

    end
    
    
    % for t = 1:length(onset);
    %
    %     if Block(t) == 1
    
    % catch ME
    %     disp(ME.message)
    %     msg = sprintf('check line %d', ME.stack.line);
    %     disp(msg);
    %     keyboard
    
    fopen(fid); % Changed from fclose
    
end

