%function demean(subj,r)

maindir = pwd;
path = ("pmod/" + "sub-" + subj + "/")
subj = 1006
r = 1

% This function is demeaning. Type in the subject and run number and it
% will demean all of the cue files.

data = (path + "sub-" + subj + "run-0" + r + "_cue_ug-resp_parametric_pmod.txt");
UGResp = importdata(data);
UGRespMean = mean(UGResp(:,3));
UGRespDemeaned = UGResp(:,3)-UGRespMean;
UGResp = UGResp(:,1:2);
UGResp = [UGResp,UGRespDemeaned];   

dlmwrite('sub-1006run-01_cue_ug-resp_parametric_pmod_demeaned.txt',UGResp,'delimiter','\t','precision',4)

data = (path + "sub-" + subj + "run-0" + r + "_cue_ug-prop_parametric_pmod.txt");
UGProp = importdata(data);
UGPropMean = mean(UGProp(:,3));
UGPropDemeaned = UGProp(:,3)-UGPropMean;
UGProp = UGProp(:,1:2);
UGProp = [UGProp,UGPropDemeaned];   

dlmwrite('sub-1006run-01_cue_ug-prop_parametric_pmod_demeaned.txt',UGProp,'delimiter','\t','precision',4)

data = (path + "sub-" + subj + "run-0" + r + "_cue_dict_parametric_pmod.txt");
Dict = importdata(data);
DictMean = mean(Dict(:,3));
DictDemeaned = Dict(:,3)-DictMean;
Dict = Dict(:,1:2);
Dict = [Dict,DictDemeaned];   

dlmwrite('sub-1006run-01_cue_dict_parametric_pmod_demeaned.txt',Dict,'delimiter','\t','precision',4)
