# NIDA ISTART Grant
This repository contains code related to our NIDA ISTART grant (NIH R03-DA046733; PI Smith). All hypotheses and analysis plans were pre-registered on AsPredicted by 12/12/2019 and data collection commenced on 12/13/2019. We will share all of the resulting imaging data via [OpenNeuro][1] at the conclusion of our study (projected for fall 2020).

## Notes on repository organization and files (needs updating)
Some of the contents of this repository are not tracked (.gitignore) because the files are large. These files/folders specifically include our dicom images, converted images in bids format, fsl output, and derivatives from bids (e.g., mriqc and fmriprep). All scripts will reference these directories, which are only visible on our the primary linux workstation in Smith Lab.



## Basic steps for experimenters (needs updating)
Here are the basic steps for transferring and processing data. Note that when you see `$sub`, it should be replaced with your subject number (e.g., 102). Remember, always check your input and output for each step. If the input/output isn't clear, look through the scripts and talk to someone. In many scripts and wrappers, the `$nruns` argument is necessary because some subjects will not have the full set of five runs for the trust task. If you are processing more than 1 subject at a time, consider using the `runall_*` script.

1. Transfer data from XNAT to dicoms folder (e.g., /data/projects/srndna/dicoms/SMITH-AgingDM-102). Be sure to save a backup on the S: drive.
1. Convert data to BIDS, preprocess, and run QA using the wrapper `bash run_prestats.sh $sub $nruns`. This wrapper will do the following:
    - Run [heudiconv][3] to convert dicoms to BIDS using `bash run_heudiconv.sh $sub $nruns`.
    - Run PyDeface to remove the face from the anats. This is done using `bash run_pydeface.sh $sub`.
    - Run [mriqc][4] and [fmriprep][5] using `bash run_mriqc.sh $sub` and `bash run_fmriprep.sh $sub`, respectively.
1. Open Matlab and Run `pay_subject(subnum)`, making sure to replace with the appropriate subject number in the (). This will run all three convert*BIDS.m scripts to place events files in bids folder. Note, this is a Matlab script. If you run into issues opening Matlab in your terminal, see the steps outlined on the Wiki https://smithlabinternal.cla.temple.edu/computing/labcomputers
1. Convert `*_events.tsv` files to 3-column files (compatible with FSL) using Tom Nichols' [BIDSto3col.sh][2] script. This script is wrapped into our pipeline using `bash gen_3col_files.sh $sub $nruns`
1. Run analyses in FSL. Analyses in FSL consist of two stages, which we call "Level 1" (L1) and "Level 2" (L2). For L1, we have a wrapper that runs all tasks simultaneously `bash run_L1stats.sh $sub $nruns $ppi $sm`. Enter '5' for number of trust runs (unless otherwise), enter '0' for ppi to indicate run activation analyses and enter '4' for sm (smoothing) which refers to a 4 mm smoothing kernel. This wrapper will do the following:
    - Run `L1_task-trust_model-01.sh` on all runs.
    - Run `L1_task-sharedreward_model-01.sh` on all runs.
    - Run `L1_task-ultimatum_model-01.sh` on all runs.
1. Display the `runall_L2stats.sh script` and edit the two `for subrun in` lines to include the appropriate subject numbers and trust runs they had


[1]: https://openneuro.org/
[2]: https://github.com/INCF/bidsutils
[3]: https://github.com/nipy/heudiconv
[4]: https://mriqc.readthedocs.io/en/latest/index.html
[5]: http://fmriprep.readthedocs.io/en/latest/index.html
