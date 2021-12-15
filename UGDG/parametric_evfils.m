subj = 1004
maindir = pwd;

%% Open the cue files

%fname = fullfile(maindir,'derivatives','fsl','EVfiles',['sub-'
%num2str(subj)],'ugdg',['run-0' num2str(r) '_cue_dict.txt']) % Actual path

% Current path

% fname = fullfile(['sub-' num2str(subj)],'ugdg',['run-0' num2str(r) '_cue_dict.txt'])
%
% N = dlmread(fname,'\t');
%
% end

% Open the raw logs
r = 2
s = r - 1;

% fname = fullfile(maindir,'istart','UGDG','logs',num2str(subj),sprintf('sub-%04d_task-ultimatum_run-%d_raw.csv',subj,s)); % Psychopy taken out from Logs to make work for now.
fname =  fullfile(maindir,'logs',num2str(subj),sprintf('sub-%04d_task-ultimatum_run-%d_raw.csv',subj,s));

C = readtable(fname);
C = C{:,:};



% "Feedback" is the offer value (out of $20)

decision_onset = C(:,16);
endowment_onset = C(:,12);
endowment_offset = C(:,13);
onset = C(:,11);
RT = C(:,18);
duration = C(:,21);
Block = C(:,3);
Endowment = C(:,4);
response = C(:,17);
L_Option = C(:,7);
R_Option = C(:,8);

% We need to split up the endowments per the blocks. Then take the
% mean of those blocks. We do this to generate the parametric
% regressors, which require the demeaned endowment.

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

dict_parametric_endowment = [];
UGP_parametric_endowment = [];
UGR_parametric_endowment = [];

for t = 1:length(Block)
    
    saveme = [];
    
    if (Block(t) == 1)
        saveme = [onset(t),2, round(Endowment(t)-Block1Mean)];
        dict_parametric_endowment = [dict_parametric_endowment; saveme];
    end
    
    if (Block(t) == 2)
        saveme = [onset(t),2, round(Endowment(t)-Block2Mean)];
        UGP_parametric_endowment = [UGP_parametric_endowment; saveme];
    end
    
    if (Block(t) == 3)
        saveme = [onset(t),2, round(Endowment(t)-Block3Mean)];
        UGR_parametric_endowment = [UGR_parametric_endowment; saveme];
    end
    
end


fileName={'dict_parametric_endowment.txt', 'UGP_parametric_endowment.txt', 'UGR_parametric_endowment.txt'};
%open file identifier
fid=fopen('MyFile.txt','w');
for k=1:length(fileName)
    %read the file name as string including delimiters and next lines
    List=textread(fileName{1,k},'%s','delimiter','\n');
    %arrange them in order of k if you want in a cell array
    FinalList{k,1}=List;
    %or print them into a file.
    fprintf(fid, [cell2mat(List)  '\n']);
end
%close file indentifier
fclose(fid)

%     fopen(fid); % Changed from fclose
%
% end
