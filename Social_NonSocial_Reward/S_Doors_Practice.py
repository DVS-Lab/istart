#Social Doors & Doors Practice

#by Caleb Haynes 8/20/19

#based on Dominic Fareri's 'Shared Reward' task, and Johanna Jarcho's E-Prime (2.0) version 

from psychopy import visual, core, event, gui, data, sound, logging
import csv
import datetime
import random
import pandas as pd
import numpy
import os
import xlrd
import sys
from psychopy.visual import ShapeStim
#parameters

useFullScreen = True
useDualScreen=1
DEBUG = False

frame_rate=1
initial_fixation_dur = 4
final_fixation_dur = 2
decision_dur=3
arrow_dur = 3

responseKeys=('2','3','z')

#get subjID
subjDlg=gui.Dlg(title="Social Doors Task")
subjDlg.addField('Enter Subject ID: ')
subjDlg.addField('Run Number:', choices=['1'])
subjDlg.show()

if gui.OK:
    subj_id=subjDlg.data[0]    
    subj_run = subjDlg.data[1]
    print(subj_id, subj_run)

else:
    sys.exit()

run_data = {
    'Participant ID': subj_id,
    'Date': str(datetime.datetime.now()),
    'Description': 'ISTART - Social Doors Task',
    }

#window setup
win = visual.Window([800,600], monitor="testMonitor", units="deg", fullscr=useFullScreen, allowGUI=False, screen=useDualScreen)

#checkpoint
print("got to check 1")

#define fixation
fixation = visual.TextStim(win, text="+", height=2)

#waiting for trigger
ready_screen = visual.TextStim(win, text="Please wait for the game to begin! \n\nRemember to keep your head still!", height=1.5, wrapWidth=30)

expdir = os.getcwd()
#decision screen
imagepath = os.path.join(expdir)

if subj_run == '1':
    workbook = pd.read_csv(os.path.join(expdir, 'params', 'practice_blocks', 'sub-999_run-01_design_social.csv'))
    face_folder = os.path.join(imagepath, 'practice_images_social') 


face_R = workbook['face_image_R'].tolist()
face_L = workbook['face_image_L'].tolist()

face_L_sorted = []
face_R_sorted = []



for face in face_L:
    image = os.path.join(face_folder, face)
    face_L_sorted.append(image)

for face in face_R:
    image = os.path.join(face_folder, face)
    face_R_sorted.append(image)


resp_image_left = visual.ImageStim(win,image= face_L_sorted[0], pos =(-7,0),size=(11.2,17.14))
resp_image_right = visual.ImageStim(win,image= face_R_sorted[0], pos =(7,0),size=(11.2,17.14))

border = visual.ShapeStim(win, vertices=resp_image_left.verticesPix, units='pix', lineColor='white')
border2 = visual.ShapeStim(win, vertices=resp_image_right.verticesPix, units='pix', lineColor='white')


#arrow screen 
arrow_Stim =  visual.ImageStim(win, pos=(0,5),size=(20,20))


#outcome screen (timeout)
outcome_stim = visual.TextStim(win, pos = (0,-2.5),text='')
outcome_map = {999: 'You have 3 seconds to respond.'}


#instructions
instruct_screen = visual.TextStim(win, text='In this task, you will see two pictures of individuals on the computer screen, one on the left and one on the right. \n \nWe want you to tell us which person you think liked you based on your photo. \n \n Press the index finger button to continue.', pos = (0,0), wrapWidth=45, height = 1.2)
instruct_screen2 = visual.TextStim(win, text='Press Button 2 (index finger) for the LEFT picture. \n \nPress Button 3 (middle finger) for the RIGHT picture.', pos = (0,0), wrapWidth=45, height = 1.2)
instruct_screen3 = visual.TextStim(win, text='If you choose correctly, you will see a green arrow pointing up meaning that you chose the person who said they liked you.\n \nIf you choose incorrectly, you will see a red arrow pointing down, meaning that you did not choose the person who said they liked you; that person actually disliked you.\n \n Once you see the arrow, that round is over.', pos = (0,0), wrapWidth=45, height = 1.2)

#exit
exit_screen = visual.TextStim(win, text='Thanks for playing! Please wait for instructions from the experimenter.', pos = (0,0), wrapWidth=30, height = 1.2)


#logging
expdir = os.getcwd()
subjdir = '%s/logs/%s' % (expdir, subj_id)
if not os.path.exists(subjdir):
    os.makedirs(subjdir)
log_file = os.path.join(subjdir, f'sub-{subj_id}_task-social_door_run-{subj_run}.csv')



arrowVert = [(0.05,.2),(-0.05,0.2),(-0.05,0), (-0.1, 0),(0,-.2), (0.1,0),(0.05,0)]
down_arrow = ShapeStim(win, vertices=arrowVert, fillColor='darkred', size= 10, lineColor='darkred')

arrowVert2 = [(0.05,-.2),(-0.05,-0.2),(-0.05,0), (-0.1, 0),(0,.2), (0.1,0),(0.05,0)]
up_arrow = ShapeStim(win, vertices=arrowVert2, fillColor='green', size= 10, lineColor='green')



globalClock = core.Clock()
logging.setDefaultClock(globalClock)

timer = core.Clock()

#trial handler

if subj_run == '1':
    trial_data_1_filename = 'params/practice_blocks/sub-999_run-01_design_social.csv'
    trial_data_1  = [r for r in csv.DictReader(open(trial_data_1_filename,'rU'))]
    trial_data_1_df = pd.read_csv(trial_data_1_filename)
    trial_data_1_win_or_lose = list(trial_data_1_df.winlose.values.tolist())
    trial_win_lose = trial_data_1[:]
    trials_run1 = data.TrialHandler(trial_data_1[:], 1, method="sequential") #change to [] for full run
elif subj_run == '2':
    trial_data_1_filename = 'params/practice_blocks/sub-999_run-01_design.csv'
    trial_data_1  = [r for r in csv.DictReader(open(trial_data_1_filename,'rU'))]
    trial_data_1_df = pd.read_csv(trial_data_1_filename)
    trial_data_1_win_or_lose = list(trial_data_1_df.winlose.values.tolist())
    trial_win_lose = trial_data_1[:]
    trials_run1 = data.TrialHandler(trial_data_1[:], 1, method="sequential")
 

#checkpoint
print("got to check 2")

# main task loop
# Instructions
instruct_screen.draw()
win.flip()
event.waitKeys(keyList=('space','2'))

instruct_screen2.draw()
win.flip()
event.waitKeys(keyList=('space','2'))

instruct_screen3.draw()
win.flip()
event.waitKeys(keyList=('space','2'))

def do_run(run, trials):

    resp=[]
    fileName=log_file.format(subj_id,run)

    #wait for trigger
    ready_screen.draw()
    win.flip()
    event.waitKeys(keyList=('equal'))
    globalClock.reset()
    studyStart = globalClock.getTime()

    #Initial Fixation screen
    fixation.draw()
    win.flip()
    core.wait(initial_fixation_dur)


    for trial in trials:
        resp_image_left = visual.ImageStim(win,image= face_L_sorted.pop(), pos =(-7,0),size=(11.2,17.14))
        resp_image_right = visual.ImageStim(win,image= face_R_sorted.pop(), pos =(7,0),size=(11.2,17.14))
        
        #decision phase
        timer.reset()
        event.clearEvents()

        decision_onset = globalClock.getTime()
        trials.addData('decision_onset', decision_onset)


        resp_val=None
        resp_onset=None

        while timer.getTime() < (decision_dur):
            resp_image_left.draw()
            resp_image_right.draw()
            win.flip()

            resp = event.getKeys(keyList = responseKeys)

            if len(resp)>0:
                if resp[0] == 'z':
                    #trials.saveAsText(fileName=log_file.format(subj_id),delim=',',dataOut='all_raw')
                    os.chdir(subjdir)
                    trials.saveAsWideText(fileName)
                    os.chdir(expdir)
                    win.close()
                    core.quit()
                resp_val = int(resp[0])
                resp_onset = globalClock.getTime()
                rt = resp_onset - decision_onset
                if resp_val == 2:
                    border.autoDraw=True
                if resp_val == 3:
                    border2.autoDraw=True
                resp_image_left.draw()
                resp_image_right.draw()
                win.flip()
                core.wait((decision_dur - rt)+.5)
                decision_offset = globalClock.getTime()
                break
            else:
                resp_val = 999
                rt = 999
                resp_onset = 999
                outcome_txt = outcome_map[resp_val]
                decision_offset = globalClock.getTime()

        trials.addData('resp', resp_val)
        trials.addData('rt',rt)
        trials.addData('resp_onset',resp_onset)
        trials.addData('decision_offset',decision_offset)
        arrow_onset = globalClock.getTime()

        timer.reset()
        if resp_val == 999:
            outcome_stim.setText(outcome_txt)
            outcome_stim.draw()
            win.flip()
            missFB_onset = globalClock.getTime()
            core.wait(.5)
            missFB_offset = globalClock.getTime()

        
        border.autoDraw=False
        border2.autoDraw=False


        trial_offset = globalClock.getTime()
        duration = trial_offset - decision_onset
        trials.addData('trialDuration', duration)
        event.clearEvents()
        print("got to check 3")
        
        if resp_val != 999:
            try: 
                if trial_data_1_win_or_lose.pop() == 'loss':
                    feedback_onset = globalClock.getTime()
                    down_arrow.draw()
                    win.flip() 
                    core.wait(3.0)
                    feedback_offset = globalClock.getTime()
                elif trial_data_1_win_or_lose.pop() == 'win':
                    feedback_onset = globalClock.getTime()
                    up_arrow.draw()
                    win.flip() 
                    core.wait(3.0)
                    feedback_offset = globalClock.getTime()
                win.flip()
            except IndexError as error:
                print('end')
                
        arrow_offset = globalClock.getTime()
        trials.addData("arrow_onset", arrow_onset)
        trials.addData("arrow_offset", arrow_offset)
        #ITI
        logging.log(level=logging.DATA, msg='ITI') #send fixation log event
        timer.reset()
        ITI_onset = globalClock.getTime()
        iti_for_trial = float(trial['ITI'])
        print(iti_for_trial)
        fixation.draw()
        win.flip()
        core.wait(iti_for_trial)
        ITI_offset = globalClock.getTime()

        trials.addData('ITIonset', ITI_onset)
        trials.addData('ITIoffset', ITI_offset)

    sys.exit()
    # Final Fixation screen after trials completed
    fixation.draw()
    win.flip()
    core.wait(final_fixation_dur)
    os.chdir(subjdir)
    trials.saveAsWideText(fileName)
    os.chdir(expdir)
    endTime = 0.01 # not sure if this will take a 0, so giving it 0.01 and making sure it is defined
    expected_dur = 398
    buffer_dur = 10
    total_dur = expected_dur + buffer_dur
    if globalClock.getTime() < total_dur:
        endTime = (total_dur - globalClock.getTime())
    else:
        endTime = buffer_dur
    core.wait(endTime)
    print(globalClock.getTime())

for run, trials in enumerate([trials_run1]):
    do_run(run, trials)

# Exit
exit_screen.draw()
win.flip()
event.waitKeys(keyList=('space'))