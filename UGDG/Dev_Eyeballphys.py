#!/usr/bin/env python
# coding: utf-8

# In[10]:


import os
import re

prep_dir='/data/projects/istart-data/derivatives/fmriprep'
infiles=[os.path.join(root,f) for root,dirs,files in os.walk(prep_dir) for f in files if (
    'mid'in f) and (f.endswith('preproc_bold.nii.gz'))]
infiles.sort()


# In[17]:


lefteye_mask='/data/projects/istart-ugdg/masks/eyeball_left.nii.gz'
righteye_mask='/data/projects/istart-ugdg/masks/eyeball_right.nii.gz'

outdir='/data/projects/istart-ugdg/derivatives/fsl/EVfiles/sub-1001/ugdg_GLM2_d/run-01_LeftEye.txt'

command_list=[]

for f in infiles:
    sub=re.search('func/sub-(.*)_task',f).group(1)
    run=re.search('run-(.*)_space',f).group(1)
    task=re.search('task-(.*)_run',f).group(1)
    
    lefteye_out='/data/projects/istart-ugdg/derivatives/fsl/EVfiles/sub-%s/%s/ugdg_GLM2_d/run-0%s_LeftEye.txt'%(sub,task,run)
    righteye_out='/data/projects/istart-ugdg/derivatives/fsl/EVfiles/sub-%s/%s/ugdg_GLM2_d/run-0%s_LeftEye.txt'%(sub,task,run)

    leftcommand='fslmeants -i %s -o %s -m %s --eig'%(f,lefteye_out,lefteye_mask)
    rightcommand='fslmeants -i %s -o %s -m %s --eig'%(f,righteye_out,righteye_mask)
    command_list.append(leftcommand)
    command_list.append(rightcommand)
        


# In[ ]:


import subprocess
cores=4

def RUN_bash(command):
    
    time.sleep(2)
    
    sub=re.search('func/sub-(.*)_task',f).group(1)
    run=re.search('run-(.*)_space',f).group(1)
    task=re.search('task-(.*)_run',f).group(1)
    print(sub,run,task)
    
    process = subprocess.Popen(bashCommand,shell=True, stdout=subprocess.PIPE)
    output, error = process.communicate()
    print(error)
    
from multiprocessing import Pool

pool = Pool(cores)
results = pool.starmap(RUN_bash, command_list)


# In[25]:





# In[ ]:




