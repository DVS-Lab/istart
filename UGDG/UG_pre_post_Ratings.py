##Ratings for SRNDNA

from psychopy import visual, core, event, gui, data, logging
import csv
import datetime
import random
import numpy
import os
import sys

#parameters
useFullScreen = True
useDualScreen=1
DEBUG = False
frame_rate=1
responseKeys=('1','2','3','z','enter','escape')



#subject ID
subjDlg=gui.Dlg(title="Bargaining Task Ratings")
subjDlg.addField('Enter Subject ID: ') #0
subjDlg.addField('Enter Gender (0 for male, 1 for female): ') #1
subjDlg.addField('Enter Ethnicity (0 for Caucasian, 1 for Other): ') #2
subjDlg.addField('Enter Age: ') #3
subjDlg.addField('Full Screen? (Enter lowercase: y or n):') #4
subjDlg.addField('Session (1/2): ') #5
subjDlg.show()

if gui.OK:
    subj_id=subjDlg.data[0]
    subj_gen=subjDlg.data[1]
    subj_eth=subjDlg.data[2]
    subj_age=subjDlg.data[3]
    subj_session=subjDlg.data[5]
else:
    sys.exit()

subj_session = int(subj_session)

run_data = {
    'Participant ID': subj_id,
    'Date': str(datetime.datetime.now()),
    'Description': 'SRNDNA Pilot - UG Task',
    'Participant Gender': subj_gen,
    'Participant Ethnicity': subj_eth,
    'Participant Age': subj_age,
    'Session (Pre/Post)': subj_session
    }

#window setup
win = visual.Window([800,600], monitor="testMonitor", units="deg", fullscr=useFullScreen, allowGUI=False, screen=useDualScreen)

#checkpoint
print "got to check 1"

#first screen
instruct_screen = visual.TextStim(win, text='Please use the button box to answer the following questions about your partners', pos = (0,0), units='norm', height = 0.1)

#image
pictureStim =  visual.ImageStim(win, pos=(0,5.5),size=(6.65,6.65))

#text
questionStim = visual.TextStim(win, font='Arial', pos = (0,-0.1), units='norm', height = 0.1)


#last screen
exit_screen = visual.TextStim(win, text='Thank you for participating!', pos = (0,0), units='norm', height = 0.1)

#logging
expdir = os.getcwd()
subjdir = '%s/logs/%s' % (expdir, subj_id)
if not os.path.exists(subjdir):
    os.makedirs(subjdir)
log_file = os.path.join(subjdir,'sub{}_Bargaining-Ratings-{}.csv')

if subj_session==1:
    trial_data = [r for r in csv.DictReader(open('UGRatings_Pre.csv','rU'))]
    trials = data.TrialHandler(trial_data[:], 1, method="sequential")
elif subj_session==2:
    trial_data = [r for r in csv.DictReader(open('UGRatings_Post.csv','rU'))]
    trials = data.TrialHandler(trial_data[:], 1, method="sequential")

subj_gen = int(subj_gen)
subj_eth = int(subj_eth)
subj_age = int(subj_age)

if subj_gen==0 and subj_eth==0 and subj_age > 35:
    stim_map = {
    '3': 'olderadultMale_C',
    '2': 'youngadultMale_C',
    '1': 'computer',
    }

elif subj_gen==0 and subj_eth==0 and subj_age <= 35:
    stim_map = {
    '3': 'youngadultMale_C',
    '2': 'olderadultMale_C',
    '1': 'computer',
    }

elif subj_gen==0 and subj_eth==1 and subj_age > 35:
    stim_map = {
    '3': 'olderadultMale_M',
    '2': 'youngadultMale_M',
    '1': 'computer',
    }

elif subj_gen==0 and subj_eth==1 and subj_age <= 35:

    stim_map = {
    '3': 'youngadultMale_M',
    '2': 'olderadultMale_M',
    '1': 'computer',
    }

elif subj_gen==1 and subj_eth==0 and subj_age > 35:
    stim_map = {
    '3': 'olderadultFemale_C',
    '2': 'youngadultFemale_C',
    '1': 'computer',
    }


elif subj_gen==1 and subj_eth==0 and subj_age <= 35:
    stim_map = {
    '3': 'youngadultFemale_C',
    '2': 'olderadultFemale_C',
    '1': 'computer',
    }


elif subj_gen==1 and subj_eth==1 and subj_age > 35:
    stim_map = {
    '3': 'olderadultFemale_M',
    '2': 'youngadultFemale_M',
    '1': 'computer',
    }

elif subj_gen==1 and subj_eth==1 and subj_age <= 35:
    stim_map = {
    '3': 'youngadultFemale_M',
    '2': 'olderadultFemale_M',
    '1': 'computer',
    }

question_map = {
    '2': 'fair',
    '1': 'likeable',
    '0': 'angry',
    '4': 'satisfied'
    }

#clock
globalClock = core.Clock()
logging.setDefaultClock(globalClock)
timer = core.Clock()


#main task
#instructions
instruct_screen.draw()
win.flip()
event.waitKeys(keyList=('space'))


for trial in trials:
    condition_label = stim_map[trial['Partner']]
    imagepath = os.path.join(expdir,'Images')
    image = os.path.join(imagepath,"%s.png") %condition_label
    pictureStim.setImage(image)
    question_label = question_map[trial['Trait']]
    #position = trial['position']
    fileName=log_file.format(subj_id,subj_session)



    # rating scale
    scale = visual.RatingScale(win, low=0, high=10, size=2, tickMarks=['0','10'],
    markerStart='5',marker='triangle', textSize=.5, showValue=True, scale = '0 = not at all, 5 = neutral,  10 = extremely',
    showAccept=True, noMouse=True, maxTime = 0.0, leftKeys = ['1','left'], rightKeys = ['3','right'], acceptKeys = ['2','enter'], pos = (0, -0.55))


    resp=[]
    resp_val=None
    resp_onset=None


    trial_onset = globalClock.getTime()

    if int(trial['Trait'])==1 or int(trial['Trait'])==2:
        while scale.noResponse:
            scale.draw()
            pictureStim.draw()
            questionStim.draw()
            ratingQ = 'How %s do you feel this partner is?' % question_label
            questionStim.setText(ratingQ)
            win.flip()

        #resp = event.getKeys(keyList = responseKeys)

        if len(resp)>0:
            if resp[0] == 'escape':
                trials.addData('Rating', scale.getRating())
                os.chdir(subjdir)
                trials.saveAsWideText(fileName)
                os.chdir(expdir)
                win.close()
                core.quit()


        trials.addData('Rating', scale.getRating())

    elif int(trial['Trait'])==0 or int(trial['Trait'])==4:
        while scale.noResponse:
            scale.draw()
            pictureStim.draw()
            questionStim.draw()
            ratingQ = 'How %s were you with offers from this partner?' % question_label
            questionStim.setText(ratingQ)
            win.flip()

        if len(resp)>0:
            if resp[0] == 'escape':
                trials.addData('Rating', scale.getRating())
                os.chdir(subjdir)
                trials.saveAsWideText(fileName)
                os.chdir(expdir)
                win.close()
                core.quit()

        trials.addData('Rating', scale.getRating())

os.chdir(subjdir)
trials.saveAsWideText(fileName)
os.chdir(expdir)

#last screen
exit_screen.draw()
win.flip()
event.waitKeys()
