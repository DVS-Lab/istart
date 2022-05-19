function convertUG_BIDS_2021_debug(subj)
maindir = pwd;
usedir = '/data/projects/istart-data/';

%try

% 11-18-21 | This is the code I am using  for the bids converter.

% Plan now is to use the BIDs converter for only the simple regressors. Ie:
% Export the endowments (cue onsets) and the decision phases
% (accept/reject), choices, and missed trials.


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
    Block = C{8};
    Endowment = C{5};
    response = C{17};
    response = round(response);
    L_Option = C{4};
    R_Option = C{6};
    
    fname = sprintf('sub-%03d_task-ugdg_run-%02d_events.tsv',subj,r+1); % making compatible with bids output
    output = fullfile(usedir,'bids',['sub-' num2str(subj)],'func');
    %output = fullfile(maindir,'bids',['sub-' num2str(subj)],'func')
    
    
    if ~exist(output,'dir')
        mkdir(output)
    end
    myfile = fullfile(output,fname);
    fid = fopen(myfile,'w');
    fprintf(fid,'onset\tduration\ttrial_type\tresponse_time\tEndowment\n');
    
%     % We need to split up the endowments per the blocks. Then take the
%         % mean of those blocks. We do this to generate the parametric
%         % regressors, which require the demeaned endowment.
% 
%         
%         Block1Mean = [];
%         Block2Mean = [];
%         Block3Mean = [];
%         
%         for ii = 1:length(Block)
%             
%         if (Block(ii) == 1)
%             Block1Mean = [Block1Mean;Endowment(ii)];
%            
%         elseif (Block(ii) == 2)
%             Block2Mean = [Block2Mean;Endowment(ii)];
%             
%         elseif (Block(ii) == 3)
%             Block3Mean = [Block3Mean;Endowment(ii)];
%             
%         end   
%             
%         end
%         
%         Block1Mean = mean(Block1Mean);
%         Block2Mean = mean(Block2Mean);
%         Block3Mean = mean(Block3Mean);
        
        %% Populate the regressors.
    
    for t = 1:length(onset);
        
        
        
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
            fprintf(fid,'%f\t%d\t%s\t%s\t%d\n',decision_onset(t),4,'missed_trial','n/a', Endowment(t));
        end
        
        if Block(t) == 3
            if response(t) == 2
                if round(L_Option(t)) > 0;
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\n',decision_onset(t),RT(t),[trial_type '_accept'],RT(t),Endowment(t));
                else
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\n',decision_onset(t),RT(t),[trial_type '_reject'],RT(t),Endowment(t));
                end
            end
            
            if response(t) == 3
                if round(R_Option(t)) > 0;
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\n',decision_onset(t),RT(t),[trial_type '_accept'],RT(t),Endowment(t));
                else
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\n',decision_onset(t),RT(t),[trial_type '_reject'],RT(t),Endowment(t));
                end
            end
        end
               
        if Block(t) == 2
            if response(t) == 2
                if L_Option(t) > R_Option(t);
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\n',decision_onset(t),RT(t),[trial_type '_more'],RT(t),Endowment(t));
                else
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\n',decision_onset(t),RT(t),[trial_type '_less'],RT(t),Endowment(t));
                end
            end
            
            
            if response(t) == 3
                if L_Option(t) > R_Option(t);
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\n',decision_onset(t),RT(t),[trial_type '_less'],RT(t),Endowment(t));
                else
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\n',decision_onset(t),RT(t),[trial_type '_more' ],RT(t),Endowment(t));
                end
            end
        end
        
        if Block(t) == 1
            if response(t) == 2
                if L_Option(t) > R_Option(t);
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\n',decision_onset(t),RT(t),[trial_type '_more' ],RT(t),Endowment(t));
                else
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\n',decision_onset(t),RT(t),[trial_type '_less'],RT(t),Endowment(t));
                end
            end
            
            if response(t) == 3
                if L_Option(t) > R_Option(t);
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\n',decision_onset(t),RT(t),[trial_type '_less'],RT(t),Endowment(t));
                else
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\n',decision_onset(t),RT(t),[trial_type '_more'],RT(t),Endowment(t));
                end
            end
        end
        
        %% Add choice only regessors

% These regressors collapse the decision phase into simply "choice". It
% eliminates More/Less or Accept/Reject. This is to deal with the ceiling
% effect associated with "perfectly rational" behavior, if subjects always
% choose a given option.
        
        
        if Block(t) == 3
            if response(t) == 2
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\n',decision_onset(t),RT(t),[trial_type '_choice'],RT(t),Endowment(t));
               
            end
            
            if response(t) == 3
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\n',decision_onset(t),RT(t),[trial_type '_choice'],RT(t),Endowment(t));
            end
        end
        
        
        if Block(t) == 2
            
            if response(t) == 2
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\n',decision_onset(t),RT(t),[trial_type '_choice'],RT(t),Endowment(t));  
            end
            
            
            if response(t) == 3
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\n',decision_onset(t),RT(t),[trial_type '_choice'],RT(t),Endowment(t));   
           end
        end
        
        if Block(t) == 1
            if response(t) == 2
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\n',decision_onset(t),RT(t),[trial_type '_choice' ],RT(t),Endowment(t));
            end
            
            if response(t) == 3
                    fprintf(fid,'%f\t%f\t%s\t%f\t%d\n',decision_onset(t),RT(t),[trial_type '_choice'],RT(t),Endowment(t));
            end
        
        end
    
        
        %% Adding in the cue onsets
        
        %cue_dict
        %cue_ug-resp
        %cue_ug-prop
        
        %fprintf(fid,'onset\tduration\ttrial_type\tresponse_time\tPartnerKeeps\tOffer\tResponse\n');
        if (Block(t) == 1)
            trial_type = 'cue_dict';
            fprintf(fid,'%f\t%d\t%s\t%s\t%d\n',onset(t),2,[trial_type],'n/a',Endowment(t));
        elseif (Block(t) == 2)
            trial_type = 'cue_ug-resp';
            fprintf(fid,'%f\t%d\t%s\t%s\t%d\n',onset(t),2,[trial_type],'n/a',Endowment(t));
        elseif (Block(t) == 3)
            trial_type = 'cue_ug-prop';
            fprintf(fid,'%f\t%d\t%s\t%s\t%d\n',onset(t),2,[trial_type],'n/a',Endowment(t));
        else
            keyboard
        end
        
        %% Adding in the cue onsets for parametric model
        
        %cue_dict
        %cue_ug-resp
        %cue_ug-prop
        
        
        
%         %fprintf(fid,'onset\tduration\ttrial_type\tresponse_time\tPartnerKeeps\tOffer\tResponse\n');
%         if (Block(t) == 1)
%             trial_type = 'cue_dict_parametric';
%             fprintf(fid,'%f\t%d\t%s\t%s\t%d\n',onset(t),2,[trial_type],'n/a',Endowment(t));
%         elseif (Block(t) == 2)
%             trial_type = 'cue_ug-resp_parametric';
%             fprintf(fid,'%f\t%d\t%s\t%s\t%d\n',onset(t),2,[trial_type],'n/a',Endowment(t));
%         elseif (Block(t) == 3)
%             trial_type = 'cue_ug-prop_parametric';
%             fprintf(fid,'%f\t%d\t%s\t%s\t%d\n',onset(t),2,[trial_type],'n/a',Endowment(t));
%         else
%             keyboard
%         end

% Endowment_Mean = mean(Endowment);
%        
%        if (Block(t) == 1)
%             trial_type = 'cue_dict_parametric';
%             fprintf(fid,'%f\t%d\t%s\t%s\t%d\n',onset(t),2,[trial_type],'n/a',round(Endowment(t)-Block1Mean));
%         elseif (Block(t) == 2)
%             trial_type = 'cue_ug-resp_parametric';
%             fprintf(fid,'%f\t%d\t%s\t%s\t%d\n',onset(t),2,[trial_type],'n/a',round(Endowment(t)-Block2Mean));
%         elseif (Block(t) == 3)
%             trial_type = 'cue_ug-prop_parametric';
%             fprintf(fid,'%f\t%d\t%s\t%s\t%d\n',onset(t),2,[trial_type],'n/a',round(Endowment(t)-Block3Mean));
%         else
%             keyboard
%        end

       
       % I took this code from the choice only parametric. This
       % demeaning process only demeans the endowment parametric
       % regressor.

        
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
