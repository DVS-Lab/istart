###social_reward - Caleb Haynes 11/26/2019
from psychopy import visual, core, event, gui, data, sound, logging
from psychopy.visual import ShapeStim
import pandas as pd
import numpy as np
import os
from pathlib import Path
import datetime
import time

#gui set up for subject id and picture order
subjDlg = gui.Dlg(title="Picture Task")
subjDlg.addField('Enter Subject ID: ')
subjDlg.addField('Order:', choices=['Faces', 
                                    'Images', 
                                    'Images->Faces',
                                    'Faces->Images',
                                    'Practice Faces',
                                    'Practice Images'])
subjDlg.addField('Version:', choices=['A', 'B'])
subjDlg.show()
#user presses cancel
if subjDlg.OK == False:
    core.quit()
#store gui variables
subj_id = subjDlg.data[0]
task_order = subjDlg.data[1]
version = subjDlg.data[2]

#parameter file for Trial, ITI, win or lose, and image and face ordering.
reference = pd.read_csv(('reference.csv'), header = 0)

win = visual.Window([1000,750], monitor="testMonitor", units="deg", fullscr=False, allowGUI=False, screen=1)
responseKeys=('2','3','z')
instruct_screen = visual.TextStim(win, text='''Hello! This is the picture task.
\n \nPress the index finger button to continue.''', pos = (0,0), wrapWidth=45, height = 1.2)

instruct_screen1_image = visual.TextStim(win, text='''In this task, you will see two pictures on the computer screen, only one of them will have a prize behind it. 
\n \nWe want you to tell us which picture you think contains a prize. 
\n \nPress the index finger button to continue.''', pos = (0,0), wrapWidth=45, height = 1.2)

instruct_screen1_face = visual.TextStim(win, text='''In this task, you will see two pictures of individuals on the computer screen, one on the left and one on the right. 
\n \nWe want you to tell us which person you think liked you based on your photo. 
\n \nPress the index finger (or 2 on your keyboard) button to continue.''', pos = (0,0), wrapWidth=45, height = 1.2)

instruct_screen2 = visual.TextStim(win, text='''Press Button 2 (index finger) for the LEFT picture. 
\n \nPress Button 3 (middle finger) for the RIGHT picture.''', pos = (0,0), wrapWidth=45, height = 1.2)

instruct_screen3_image = visual.TextStim(win, text='''If you choose correctly, you will see a green arrow pointing up, meaning that you won 50 cents.
\n \nIf you choose incorrectly, you will see a red arrow pointing down, meaning that you lost 25 cents.
\n \nIf you are not fast enough, the computer will make a decision for you at random, so make sure you are responding quickly. 
\n \nOnce you see the arrow, that round is over.''', pos = (0,0), wrapWidth=45, height = 1.2)

instruct_screen3_face = visual.TextStim(win, text='''If you choose correctly, you will see a green arrow pointing up, meaning that you chose the person who said they liked you.
\n \nIf you choose incorrectly, you will see a red arrow pointing down, meaning that you did not choose the person who said they liked you; that person actually disliked you.
\n \nIf you are not fast enough, the computer will make a decision for you at random, so make sure you are responding quickly. 
\n \nOnce you see the arrow, that round is over.''', pos = (0,0), wrapWidth=45, height = 1.2)

ready_screen = visual.TextStim(win, text='''Please wait for the game to begin! 
\n\nRemember to keep your head still!''', height=1.5, wrapWidth=30)

###Setting image, face, fixation, and arrow calling methods
fixation = visual.TextStim(win, text="+", height=2)
arrowVert_down = [(0.05,.2),(-0.05,0.2),(-0.05,0), (-0.1, 0),(0,-.2), (0.1,0),(0.05,0)]
down_arrow = ShapeStim(win, vertices=arrowVert_down, fillColor='darkred', size= 10, lineColor='darkred')
arrowVert_up = [(0.05,-.2),(-0.05,-0.2),(-0.05,0), (-0.1, 0),(0,.2), (0.1,0),(0.05,0)]
up_arrow = ShapeStim(win, vertices=arrowVert_up, fillColor='green', size= 10, lineColor='green')

###timing variables
fixation_time = 0.6
decision_time = 3.0
fake_pic = visual.TextStim(win, text=":)    :)", height=2)
def ready():
    ready_screen.draw()
    win.flip()
    event.waitKeys(keyList=('equal'))

def face_instructions():
    instruct_screen.draw()
    win.flip()
    event.waitKeys(keyList=('space','2'))
    instruct_screen1_face.draw()
    win.flip()
    event.waitKeys(keyList=('space','2'))
    instruct_screen2.draw()
    win.flip()
    event.waitKeys(keyList=('space','2'))
    instruct_screen3_face.draw()
    win.flip()
    event.waitKeys(keyList=('space','2'))

def image_instructions():
    instruct_screen.draw()
    win.flip()
    event.waitKeys(keyList=('space','2'))
    instruct_screen1_image.draw()
    win.flip()
    event.waitKeys(keyList=('space','2'))
    instruct_screen2.draw()
    win.flip()
    event.waitKeys(keyList=('space','2'))
    instruct_screen3_image.draw()
    win.flip()
    event.waitKeys(keyList=('space','2'))

def do_face_run():
    #set Version ITI, Image orders, feedback order
    fixation.draw()
    win.flip()
    if version == 'A':
        print('VersionA')
        pic_path = os.path.join(os.getcwd(), 'pictureFolder', 'A_faces')
        face_L = reference[['A_face_L']]
        face_R = reference[['A_face_R']]
        ITI = reference[['A_ITI']]
    elif version == 'B':
        print('VersionB')
        pic_path = os.path.join(os.getcwd(), 'pictureFolder', 'B_faces')
        face_L = reference.loc[['B_face_L']]
        face_R = reference[['B_face_R']]
        ITI = reference[['B_ITI']]
    else:
            core.quit()
    #lists to store logging
    onset = []
    duration = []
    condition = []
    resp_val = []
    rt = []
    trial_start = time.time()
    for trial in reference.iterrows():
        trial_row_start = time.time()
        row_counter = trial[0]
        #1st fixation
        timer = core.CountdownTimer(fixation_time)
        onset.append(trial_row_start)
        while timer.getTime() > 0:
            fixation.draw()
            win.flip()
        fix_dur = time.time() - trial_row_start
        duration.append(fix_dur)
        condition.append('fix_pre_decision')
        resp_val.append('999')
        rt.append('999')

        #decision phase
        timer = core.CountdownTimer(decision_time)
        while timer.getTime() > 0:
            fake_pic.draw()
            win.flip()
        #timer = core.CountdownTimer(fixation_time)
        #while timer.getTime() > (decision_time):
        #    face_L.draw()
        #    face_R.draw()
        #    win.flip()
        #    resp = event.getKeys(keyList = responseKeys)
        #    if len(resp)>0:
        #        if resp[0] == 'z':
        #            try:
        #                log.to_csv(f'data/{subj_id}/sub-{subj_id}_task-socialReward_run-{version}_events.tsv', sep='\t', index = False)
        #            except:
        #                Path(f'logs/{subj_id}/sub-{subj_id}_task-socialReward_run-{version}_events.tsv').touch()
        #                log.to_csv(f'logs/{subj_id}/sub-{subj_id}_task-socialReward_run-{version}_events.tsv', sep='\t', index = False)
        #            core.quit()
        #        resp_val = int(resp[0])
        #        resp_onset = globalClock.getTime()
        #        rt = resp_onset - decision_onset
        #        if resp_val == 2:
        #            border.autoDraw=True
        #        if resp_val == 3:
        #            border2.autoDraw=True
        #        resp_image_left.draw()
        #        resp_image_right.draw()
        #        win.flip()
        #        core.wait(decision_dur - rt)
        #        decision_offset = globalClock.getTime()
        #        break
        #    else:
        #        resp_val = 999
        #        rt = 999
        #        resp_onset = 999
        
        #2nd fixation
        timer = core.CountdownTimer(fixation_time)
        onset.append(trial_start)
        while timer.getTime() > 0:
            fixation.draw()
            win.flip()
        fix_dur = time.time() - trial_start
        duration.append(fix_dur)
        condition.append('fix_post_decision')
        resp_val.append('999')
        rt.append('999')
        
        
        #feedback phase 
        if reference.loc[reference.index[row_counter], 'A_feedback'] == 'loss':
            while timer.getTime() > 0:
                arrow_onset = time.time()
                down_arrow.draw()
                win.flip() 
                duration.append(arrow_dur)
                condition.append('loss')
        elif trial['A_feedback'] == 'win':
                arrow_onset = time.time()
                up_arrow.draw()
                win.flip() 
                duration.append(arrow_dur)
                condition.append('win')
                resp_val.append('999')
                rt.append('999')
                
        else:
            print('Feedback Error')
        
        #ITI
        
        trial_end = time.time()
        trial_duration = trial_end - trial_start
    log = pd.DataFrame(
            {'onset':onset, 
            'duration':duration, 
            'condition':condition,
            'resp':resp_val,
            'rt':rt})
    try:
        log.to_csv(f'data/{subj_id}/sub-{subj_id}_task-socialReward_run-{version}_events.tsv', sep='\t', index = False)
    except:
        Path(f'logs/{subj_id}/sub-{subj_id}_task-socialReward_run-{version}_events.tsv').touch()
        log.to_csv(f'logs/{subj_id}/sub-{subj_id}_task-socialReward_run-{version}_events.tsv', sep='\t', index = False)
    return;

############################
def do_image_run():
    print('image_run_goes_here')
    return;

def master_run():
    try:
        os.mkdir(f'data/{subj_id}')
    except:
        print("Subject File Exists, Overwrite Warning")
    expstart = time.time()
    if task_order == 'Faces->Images':
        #face
        face_instructions()
        face_run_start = time.time()
        do_face_run()
        face_run_end = time.time()
        face_run_length = face_run_end - face_run_start
        print(face_run_length)
        #image
        image_instructions()
        image_run_start = time.time()
        do_image_run()
        image_run_end = time.time()
        image_run_length = image_run_end - image_run_start
        print(image_run_length)
    elif task_order == 'Images->Faces':
        #image
        image_instructions()
        image_run_start = time.time()
        do_image_run()
        image_run_end = time.time()
        image_run_length = image_run_end - image_run_start
        #face
        face_instructions()
        face_run_start = time.time()
        do_face_run()
        face_run_end = time.time()
        face_run_length = face_run_end - face_run_start
    elif task_order == 'Images':
        #image
        image_instructions()
        image_run_start = time.time()
        do_image_run()
        image_run_end = time.time()
        image_run_length = image_run_end - image_run_start
    elif task_order == 'Faces':
        #face
        face_instructions()
        face_run_start = time.time()
        ready()
        do_face_run()
        face_run_end = time.time()
        face_run_length = face_run_end - face_run_start
        print(face_run_length)
    else:
        core.quit()
    exp_end = time.time()
    return;

do_face_run()
#master_run()
core.quit()
###TODO

#beta
#workout logging to csv and tsv (bids names)
#iterate over trials in pd
#set up feedback arrow display
#image presentation, bufferring
#image selection
#recheck all logging, timing should be usable version of task at base
#make practice version of task
#make stimuli disappear with toggle
#append new files to old?
