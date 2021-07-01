function [tempRT_thresh] =  set_MID_threshold(tempRTs) 

tempRTs = tempRTs(tempRTs>0);
RT_init = 0.4;              %values used as past RTs before collection of RTs for this subject
RT_dev = 0.02;              %stdev used before enough data is collected to simulate it
fraction_miss = 0.25;       %fraction of trials subject should fail on
thresh_stdevs = 2^0.5 * erfinv(1-(2*fraction_miss));  %calc needed CIs to give the proper percent missed
thresh_bin = 6;             %number of RTs to use to make monte carlo history. +1 is taken and the outlier is discarded

    %%%%%%%%%%%%%%%%%%%%
    %set threshold for next trial of this_trialtype
    if length(tempRTs) >= (thresh_bin+1)
        [tmp_RTmean, tmp_RTdev] = RT_stats(tempRTs, thresh_bin);
    elseif length(tempRTs) == 0;
        tmp_RTmean = RT_init;
        tmp_RTdev = RT_dev;
    else
        tmp_RTmean = mean(tempRTs);
        tmp_RTdev = RT_dev;
    end
    
    tempRT_thresh = tmp_RTmean + thresh_stdevs*tmp_RTdev;  %use a number of devs to set threshold
    %end for each trial

function [tmp_RTmean tmp_RTdev] = RT_stats(tmp_RTs, thresh_bin)
%%% function [tmp_RTmean tmp_RTdev] = RT_stats(tmp_RTs, thresh_bin)
%computes a mean and stdev for the last thresh_bin RTs
tmp_med = median(tmp_RTs((end-(thresh_bin)):end)); %define median
tmp_dev = abs(tmp_RTs((end-(thresh_bin)):end) - tmp_med);
[tmp_dev_sort, ref_ind] = sort(tmp_dev);
tmp_RTtrim = tmp_RTs((end-thresh_bin-1)+ref_ind(1:thresh_bin));
tmp_RTmean = mean(tmp_RTtrim);
tmp_RTdev = std(tmp_RTtrim);
end

end