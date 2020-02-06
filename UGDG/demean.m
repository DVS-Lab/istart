function demean(subj,r)

% This function is demeaning. Type in the subject and run number and it
% will demean all of the cue files for the parametric regressors.

% Afterwards, you have to get it back to Istart analysis, into the EVfiles.

maindir = pwd;
path = ("pmod/" + "sub-" + subj + "/");


data = (path + "sub-" + subj + "run-0" + r + ".bids_cue_ug-resp_parametric_pmod.txt");
UGResp = importdata(data);
UGRespMean = mean(UGResp(:,3));
UGRespDemeaned = UGResp(:,3)-UGRespMean;
UGResp = UGResp(:,1:2);
UGResp = [UGResp,UGRespDemeaned];   

output = (path + "sub-" + subj + "run-0" + r + ".bids_cue_ug-resp_parametric_pmod_demeaned.txt");
dlmwrite(output,UGResp,'delimiter','\t','precision',4)

data = (path + "sub-" + subj + "run-0" + r + ".bids_cue_ug-prop_parametric_pmod.txt");
UGProp = importdata(data);
UGPropMean = mean(UGProp(:,3));
UGPropDemeaned = UGProp(:,3)-UGPropMean;
UGProp = UGProp(:,1:2);
UGProp = [UGProp,UGPropDemeaned];   

output = (path + "sub-" + subj + "run-0" + r + ".bids_cue_ug-prop_parametric_pmod_demeaned.txt");
dlmwrite(output,UGProp,'delimiter','\t','precision',4)

data = (path + "sub-" + subj + "run-0" + r + ".bids_cue_dict_parametric_pmod.txt");
Dict = importdata(data);
DictMean = mean(Dict(:,3));
DictDemeaned = Dict(:,3)-DictMean;
Dict = Dict(:,1:2);
Dict = [Dict,DictDemeaned];   

output = (path + "sub-" + subj + "run-0" + r + ".bids_cue_dict_parametric_pmod_demeaned.txt");
dlmwrite(output,Dict,'delimiter','\t','precision',4)
