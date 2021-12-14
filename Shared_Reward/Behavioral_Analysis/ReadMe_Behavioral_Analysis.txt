Hello! The files in this folder contain the original data from the behavioral portions of a Shared Reward measure, and associated questionnaires from the ISTART project at the Smith Neuroeconomics Lab.

Shared Reward is a task involving a participant in a psychological study making decisions about whether they think the value of a playing card will be higher or lower than 5. If their guess is correct, money is added to a bank and shared with them and a partner displayed on the top of the screen. If their guess is incorrect, money is subtracted from the bank. The task is within an fMRI, but this folder contains analysis of, you guessed it, only the Behavioral aspects.

All scripts are written in Python with Anaconda downloaded. They assume the download of the ISTART repository from GitHub, and are written to operate successfully from within the Behavioral_Analysis folder, assuming the other files are present. Scripts assume the ability to import (and a small bit of familiarity) in the following modules:
import pandas as pd
import scipy.stats as stats
import numpy as np 
import matplotlib.pyplot as plt
import seaborn as sms
import os
import inspect
import string

Script 1 is 'AUDIT, DUDIT, AADIS, 7U7D, rescoring and aggregation.ipynb'
This script takes data from the 4 aforementioned scales that were coded incorrectly, and rescores them according to their official scoring guides, then merges them into a single .csv file: 'Substance_and_Mood_data.csv' which is then duplicated as 'Substance_and_Mood_data_SCORED.csv' in which the values of the AUDIT and DUDIT are totaled using Excel's Visual Basic.

Script 2 is 'Making_RS_PCA.ipynb'
This script takes two reward sensitivity measures, the SPSRQ and BISBAS, and uses the reward and behavioral activation subscales, respectively, to create a mean-centered principal component analysis of the two as a single measure of Reward Sensitivity.

Script 3 is 'Shared Reward Data Aggregation.ipynb'
This script simplifies and aggregates scores from the Shared Reward behavioral measures into one file. The first measure is a post-scan rating of how it felt to win and lose money with a friend, stranger, and computer within the task. This data is stored on individual rows when it is collected, so the first order of business was to collapse the scores into a single row per participant. Next, a rating of the participant's closeness with their friend (study partner) from the beginning of the study is added to the total spreadsheet. Additionally, the Reward Sensitivity PCA from the prior script is merged in as well, and the whole dataframe is written as a .csv file: 'AllSharedRewardData.csv'