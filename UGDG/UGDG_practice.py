###i/start
###UGDG practice

from psychopy import visual, core, event, gui, data, sound, logging
import csv
import datetime
import random
import numpy
import os

#parameters
useFullScreen = True
useDualScreen=1
DEBUG = False

frame_rate=1
initial_fixation_dur = 4
#final_fixation_dur = 2
decision_dur=3
#outcome_dur=0.25
fileSuffix = 'UGDG'

responseKeys=('2','3','z')

#get subjID
subjDlg=gui.Dlg(title="Bargaining Task")
subjDlg.addField('Enter Subject ID: ') #0
subjDlg.addField('Enter Gender (0 for male, 1 for female): ') #1
subjDlg.addField('Enter Ethnicity (0 for Caucasian, 1 for Other): ') #2
subjDlg.addField('Enter Age: ') #3
subjDlg.addField('Full Screen? (Enter lowercase: y or n):') #4
subjDlg.show()

if gui.OK:
    subj_id=subjDlg.data[0]
    subj_gen=subjDlg.data[1]
    subj_eth=subjDlg.data[2]
    subj_age=subjDlg.data[3]
else:
    sys.exit()

run_data = {
    'Participant ID': subj_id,
    'Date': str(datetime.datetime.now()),
    'Description': 'I/START Pilot - UGDG Task',
    'Participant Gender': subj_gen,
    'Participant Ethnicity': subj_eth,
    'Participant Age': subj_age
    }

#window setup
win = visual.Window([1920, 1200], monitor="testMonitor", units="deg", fullscr=useFullScreen, allowGUI=False, screen=useDualScreen)

#checkpoint
print("got to check 1")

#define fixation
fixation = visual.TextStim(win, text="+", height=2)

#waiting for trigger
ready_screen = visual.TextStim(win, text="Please press button 2 to begin the practice trials.", height=1.5)

#end of run Screen
run_over_screen = visual.TextStim(win, text="You have completed the first run of Let's Make a Deal!", height=1.5)

#decision screen
pictureStim =  visual.ImageStim(win, pos=(0,3.5),size=(6.65,6.65))
cueStim = visual.ImageStim(win,pos=(0,3.5),size = (6.65,6.65))
sampleStim1 = visual.ImageStim(win,pos=(-12,-2),size = (6.65,6.65))
sampleStim2 = visual.ImageStim(win,pos=(0,-2),size = (6.65,6.65))
sampleStim3 = visual.ImageStim(win,pos=(12,-2),size = (6.65,6.65))
sampleStimText1 = visual.TextStim(win,text = "Accept/reject a proposal\nfrom your partner",pos=(-12,-8), wrapWidth=20, height = 0.8)
sampleStimText2 = visual.TextStim(win,text = "You propose a split of money.\nYour partner can accept/reject",pos = (0,-8),wrapWidth = 20, height = 0.8)
sampleStimText3 = visual.TextStim(win,text = "You propose a split of money.\nYour partner cannot respond.",pos = (12,-8),wrapWidth = 20, height = 0.8)
#resp_text_reject = visual.TextStim(win,text="Reject Offer", pos =(-7,-4.8), height=1, alignHoriz="center")
#resp_text_accept = visual.TextStim(win,text="Accept Offer", pos =(7,-4.8), height=1, alignHoriz="center")
offer_text = visual.TextStim(win,pos = (0,-4.0), height=1, alignHoriz="center")
resp_text_left = visual.TextStim(win, pos =(-7,-5), height=1, alignHoriz="center")
resp_text_right = visual.TextStim(win, pos =(7,-5), height=1, alignHoriz="center")
endowment_text = visual.TextStim(win, pos =(0,-3.0), height=1, alignHoriz="center")
cueStimSqText = visual.TextStim(win,text = "Partner can reject offer",pos=(0,-1.5), wrapWidth=20,height = 1)
cueStimTriText = visual.TextStim(win,text = "Partner cannot reject offer",pos=(0,-1.5), wrapWidth=20,height = 1)
cueStimCirText = visual.TextStim(win,text = "You can reject offer", pos=(0,-1.5), wrapWidth=20,height=1)


#outcome screen
outcome_stim = visual.TextStim(win, pos = (0,-2.5),text='')

#instructions
instruct_screen = visual.TextStim(win, text="Welcome to Let's Make a Deal!\n\nIn this task you will be making decisions involving sending money to another person.\n", pos = (0,1), wrapWidth=20, height = 1.2)
instruct_screen2 = visual.TextStim(win, text = 'On most trials, you will be given between $15-25.\n\nOn some trials, you will decide how much to share with your partner. You will keep the remainder.', pos = (0,1), wrapWidth=20, height = 1.2)
instruct_screen3 = visual.TextStim(win, text = 'On other trials, your partner will have the opportunity to reject your offer. If your partner rejects your offer, you will earn $0.',pos = (0,1), wrapWidth=20, height = 1.2)
instruct_screen4 = visual.TextStim(win, text = 'Sometimes you will receive offers from another person, which you can either accept or reject.\n\nIf you reject the offer, both you and your partner will earn $0.',pos = (0,1), wrapWidth=20, height = 1.2)
instruct_screen5 = visual.TextStim(win, text = 'On all trials, if you would like to select the option on the left side of the screen, press Button 2.\n\nIf you would like to select the option on the right side of the screen, press Button 3.',pos = (0,1), wrapWidth=20, height = 1.2)
instruct_screen6 = visual.TextStim(win, text = "You will know which type of trial it will be by the presentation of a unique cue designating your role and your partner's role.", pos = (0,5), wrapWidth=20, height = 1.2)
instruct_screen7 = visual.TextStim(win, text = 'The choices you will see are from people who have participated in past studies. Your choices will be used in future studies with real people.\n\nOne trial will be randomly selected at the end of the study and you will be paid based on its result.',pos = (0,1),wrapWidth=20,height=1.2)
instruct_screen8 = visual.TextStim(win, text = 'Do you have any questions?',pos = (0,1),wrapWidth=20,height=1.2)


#exit
exit_screen = visual.TextStim(win, text='You have reached the end of the practice round.\n\nDo you have any questions?.', pos = (0,1), wrapWidth=20, height = 1.2)

#logging
expdir = os.getcwd()
subjdir = '%s/logs/%s' % (expdir, subj_id)
if not os.path.exists(subjdir):
    os.makedirs(subjdir)
log_file = os.path.join(subjdir,'sub-{}_task-ultimatum_run-{}_practice_raw.csv')


globalClock = core.Clock()
logging.setDefaultClock(globalClock)

timer = core.Clock()


#trial handler
#trial_data_1 = [r for r in csv.DictReader(open('UGDG_blocks/sub-' + subj_id + '/sub-'+ subj_id + '_run-01_design.csv','rU'))]
trial_data_1 = [r for r in csv.DictReader(open('Subject_' + subj_id + '_run_1.csv','rU'))]
trial_data_2  = [r for r in csv.DictReader(open('Subject_' + subj_id + '_run_2.csv','rU'))]

trials_run1 = data.TrialHandler(trial_data_1[:], 1, method="sequential") #change to [] for full run
trials_run2 = data.TrialHandler(trial_data_2[:], 1, method="sequential") #change to [] for full run


subj_gen = int(subj_gen)
subj_eth = int(subj_eth)
subj_age = int(subj_age)

stim_map = {
    '2': 'human',
    '1': 'computer'
    }

outcome_map = {
  #3: 'You have accepted the offer.\n\nYou: $%s.00\nPartner: $%s.00',
  #2: 'You have rejected the offer.\n\nYou: $0.00\nPartner: $0.00',
  999: 'You missed the trial. Please respond faster.'
  }

#checkpoint
print("got to check 2")

# main task loop
# Instructions
instruct_screen.draw()
win.flip()
event.waitKeys(keyList=('2'))

instruct_screen2.draw()
win.flip()
event.waitKeys(keyList=('2'))

instruct_screen3.draw()
win.flip()
event.waitKeys(keyList=('2'))

instruct_screen4.draw()
win.flip()
event.waitKeys(keyList=('2'))

instruct_screen5.draw()
win.flip()
event.waitKeys(keyList=('2'))

instruct_screen6.draw()
sampleImage1 = os.path.join(expdir,'Images','UGResponder_circle.png')
sampleImage2 = os.path.join(expdir,'Images','UGProposer_sq.png')
sampleImage3 = os.path.join(expdir,'Images','DGProposer_triangle.png')
sampleStim1.setImage(sampleImage1)
sampleStim2.setImage(sampleImage2)
sampleStim3.setImage(sampleImage3)
sampleStim1.draw()
sampleStim2.draw()
sampleStim3.draw()
#sampleStimText1.setText(sampleStimText1)
#sampleStimText2.setText(sampleStimText2)
#sampleStimText3.setText(sampleStimText3)
sampleStimText1.draw()
sampleStimText2.draw()
sampleStimText3.draw()
win.flip()
event.waitKeys(keyList=('2'))

instruct_screen7.draw()
win.flip()
event.waitKeys(keyList=('2'))

instruct_screen8.draw()
win.flip()
event.waitKeys(keyList=('2'))

def do_run(run, trials):
    resp=[]
    fileName=log_file.format(subj_id,run)

    #wait for trigger
    ready_screen.draw()
    win.flip()
    event.waitKeys(keyList=('2'))
    globalClock.reset()
    studyStart = globalClock.getTime()

    #Initial Fixation screen
    fixation.draw()
    win.flip()
    core.wait(initial_fixation_dur)

    for trial in trials:
        #condition_label = stim_map[trial['Partner']]
        imagepath = os.path.join(expdir,'Images')
        #image = os.path.join(imagepath, "human.png") # % condition_label
        #pictureStim.setImage(image)

        #decision phase
        timer.reset()
        event.clearEvents()


        # 1 = UG Proposer, 2 = DG Proposer, 3 = UG responder
        if trial['Block'] == '3':         #UG Responder
            while timer.getTime() < 1:
                cue = os.path.join(imagepath,"UGResponder_circle.png")
                cueStim.setImage(cue)
                cue_Onset = globalClock.getTime()
                trials.addData('cue_Onset',cue_Onset)
                cueStim.draw()
                cueStimCirText.draw()
                win.flip()
                core.wait(1)

            while timer.getTime() >= 1 and timer.getTime() <= 2:
                endowment_onset = globalClock.getTime()
                trials.addData('endowment_onset', endowment_onset)
                endowment = trial['Endowment']
                endowmentText = 'Partner was given $%s' % (endowment)
                endowment_text.setText(endowmentText)
                cueStim.draw()
                cueStimCirText.draw()
                endowment_text.draw()
                #pictureStim.draw()
                win.flip()
                core.wait(1)
                endowment_offset = globalClock.getTime()
                trials.addData('endowment_offset', endowment_offset)

            endowment_offset = globalClock.getTime()
            trials.addData('endowment_offset', endowment_offset)
            timer.reset()

            #ISI
            ISI_onset = globalClock.getTime()
            trials.addData('ISI_onset', ISI_onset)
            isi_for_trial = float(trial['ISI'])
            fixation.draw()
            win.flip()
            core.wait((isi_for_trial))
            ISI_offset = globalClock.getTime()
            trials.addData('ISI_offset', ISI_offset)

            timer.reset()

            event.clearEvents()

            resp_val=None
            resp_onset=None

            #Decision
            decision_onset = globalClock.getTime()
            trials.addData('decision_onset', decision_onset)

            while timer.getTime() < decision_dur:
                cueStim.draw()
                cueStimCirText.draw()
                if trial['L_Option']=='0':
                    partner_offer = trial['R_Option']
                else:
                    partner_offer = trial['L_Option']
                partnerOffer = 'Partner offers you: $%s' % (partner_offer)
                resp_left = trial['L_Option']
                resp_right = trial['R_Option']

                if resp_left == '0':
                    resp_text_left.setText('Reject offer')
                    resp_text_right.setText('Accept offer')
                else:
                    resp_text_left.setText('Accept offer')
                    resp_text_right.setText('Reject offer')
                resp_text_left.draw()
                resp_text_right.draw()
                #resp_text_accept.draw()
                #resp_text_reject.draw()
                #pictureStim.draw()
                endowment_text.draw()
                offer_text.setText(partnerOffer)
                offer_text.draw()
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
                        resp_text_left.setColor('darkorange')
                    if resp_val == 3:
                        resp_text_right.setColor('darkorange')
                    cueStim.draw()
                    cueStimCirText.draw()
                    resp_text_left.draw()
                    resp_text_right.draw()
                    endowment_text.draw()
                    #pictureStim.draw()
                    offer_text.setText(partnerOffer)
                    offer_text.draw()
                    win.flip()
                    core.wait((decision_dur - rt + .5))
                    decision_offset = globalClock.getTime()
                    break
                else:
                    resp_val = 999
                    rt = 999
                    resp_onset = 999
                    outcome_txt = outcome_map[resp_val]
                    decision_offset = globalClock.getTime()


        elif trial['Block'] == '1': #UGProposer
            while timer.getTime() < 1:
                cue = os.path.join(imagepath,"UGProposer_sq.png")
                cueStim.setImage(cue)
                cue_Onset = globalClock.getTime()
                trials.addData('cue_Onset',cue_Onset)
                cueStim.draw()
                cueStimSqText.draw()
                win.flip()
                core.wait(1)

            while timer.getTime() >= 1 and timer.getTime() <= 2:
                endowment_onset = globalClock.getTime()
                trials.addData('endowment_onset', endowment_onset)
                endowment = trial['Endowment']
                endowmentOffer = 'You are given $%s' % endowment
                endowment_text.setText(endowmentOffer)
                cueStim.draw()
                cueStimSqText.draw()
                endowment_text.draw()
                #pictureStim.draw()
                win.flip()
                core.wait(1)

            resp_val=None
            resp_onset=None

            timer.reset()

            event.clearEvents()

            endowment_offset = globalClock.getTime()
            trials.addData('endowment_offset', endowment_offset)

            #ISI
            ISI_onset = globalClock.getTime()
            trials.addData('ISI_onset', ISI_onset)
            isi_for_trial = float(trial['ISI'])
            fixation.draw()
            win.flip()
            core.wait((isi_for_trial))
            ISI_offset = globalClock.getTime()
            trials.addData('ISI_offset', ISI_offset)

            timer.reset()

            decision_onset = globalClock.getTime()
            trials.addData('decision_onset', decision_onset)

            while timer.getTime() < decision_dur:
                resp_left = trial['L_Option']
                resp_right = trial['R_Option']
                respcLeft = 'Offer $%s' % resp_left
                resp_text_left.setText(respcLeft)
                respcRight = 'Offer $%s' % resp_right
                resp_text_right.setText(respcRight)
                cueStim.draw()
                cueStimSqText.draw()
                resp_text_left.draw()
                resp_text_right.draw()
                #pictureStim.draw()
                endowment_text.setText(endowmentOffer)
                endowment_text.draw()
                win.flip()

                resp = event.getKeys(keyList = responseKeys)

                if len(resp)>0:
                    if resp[0] == 'z':
                        os.chdir(subjdir)
                        trials.saveAsWideText(fileName)
                        os.chdir(expdir)
                        win.close()
                        core.quit()
                    resp_val = int(resp[0])
                    resp_onset = globalClock.getTime()
                    rt = resp_onset - decision_onset
                    if resp_val == 2:
                        resp_text_left.setColor('darkorange')
                    if resp_val == 3:
                        resp_text_right.setColor('darkorange')
                    cueStim.draw()
                    cueStimSqText.draw()
                    resp_text_left.draw()
                    resp_text_right.draw()
                    #pictureStim.draw()
                    endowment_text.setText(endowmentOffer)
                    endowment_text.draw()
                    win.flip()
                    core.wait((decision_dur - rt + .5))
                    decision_offset = globalClock.getTime()
                    break
                else:
                    resp_val = 999
                    rt = 999
                    resp_onset = 999
                    outcome_txt = outcome_map[resp_val]
                    decision_offset = globalClock.getTime()

        else:
            trial['Block'] == '2'
            while timer.getTime() < 1:
                cue = os.path.join(imagepath,"DGProposer_triangle.png")
                cueStim.setImage(cue)
                cue_Onset = globalClock.getTime()
                trials.addData('cue_Onset',cue_Onset)
                cueStim.draw()
                cueStimTriText.draw()
                win.flip()
                core.wait(1)

            while timer.getTime() >= 1 and timer.getTime() <= 2:
                endowment_onset = globalClock.getTime()
                trials.addData('endowment_onset', endowment_onset)
                endowment = trial['Endowment']
                endowmentOffer = 'You are given $%s' % endowment
                endowment_text.setText(endowmentOffer)
                cueStim.draw()
                cueStimTriText.draw()
                endowment_text.draw()
                #pictureStim.draw()
                win.flip()
                core.wait(1)

            resp_val=None
            resp_onset=None

            endowment_offset = globalClock.getTime()
            trials.addData('endowment_offset', endowment_offset)

            timer.reset()

            event.clearEvents()

            #ISI
            ISI_onset = globalClock.getTime()
            trials.addData('ISI_onset', ISI_onset)
            isi_for_trial = float(trial['ISI'])
            fixation.draw()
            win.flip()
            core.wait((isi_for_trial))
            ISI_offset = globalClock.getTime()
            trials.addData('ISI_offset', ISI_offset)

            timer.reset()

            decision_onset = globalClock.getTime()
            trials.addData('decision_onset', decision_onset)


            while timer.getTime() < decision_dur:
                resp_left = trial['L_Option']
                resp_right = trial['R_Option']
                respcLeft = 'Give $%s' % resp_left
                resp_text_left.setText(respcLeft)
                respcRight = 'Give $%s' % resp_right
                resp_text_right.setText(respcRight)
                resp_text_left.draw()
                resp_text_right.draw()
                cueStim.draw()
                cueStimTriText.draw()
                #pictureStim.draw()
                endowment_text.setText(endowmentOffer)
                endowment_text.draw()
                win.flip()

                resp = event.getKeys(keyList = responseKeys)

                if len(resp)>0:
                    if resp[0] == 'z':
                        os.chdir(subjdir)
                        trials.saveAsWideText(fileName)
                        os.chdir(expdir)
                        win.close()
                        core.quit()
                    resp_val = int(resp[0])
                    resp_onset = globalClock.getTime()
                    rt = resp_onset - decision_onset
                    if resp_val == 2:
                        resp_text_left.setColor('darkorange')
                    if resp_val == 3:
                        resp_text_right.setColor('darkorange')
                    resp_text_left.draw()
                    resp_text_right.draw()
                    cueStim.draw()
                    cueStimTriText.draw()
                    #pictureStim.draw()
                    endowment_text.setText(endowmentOffer)
                    endowment_text.draw()
                    win.flip()
                    core.wait((decision_dur - rt + .5))
                    decision_offset=globalClock.getTime()
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
                #win.flip()

        timer.reset()
        if resp_val == 999:
            outcome_stim.setText(outcome_txt)
            outcome_stim.draw()
            win.flip()
            missFB_onset = globalClock.getTime()
            core.wait(.5)
            missFB_offset = globalClock.getTime()

        #reset rating number color
        resp_text_left.setColor('#FFFFFF')
        resp_text_right.setColor('#FFFFFF')

        #resp_text_accept.setColor('#FFFFFF')
        #resp_text_reject.setColor('#FFFFFF')

        trial_offset = globalClock.getTime()
        duration = trial_offset - decision_onset
        trials.addData('trialDuration', duration)
        event.clearEvents()
        print("got to check 3")

        #ITI
        logging.log(level=logging.DATA, msg='ITI') #send fixation log event
        timer.reset()
        ITI_onset = globalClock.getTime()
        iti_for_trial = float(trial['ITI'])
        fixation.draw()
        win.flip()
        core.wait(iti_for_trial)
        ITI_offset = globalClock.getTime()

        trials.addData('ITIonset', ITI_onset)
        trials.addData('ITIoffset', ITI_offset)

    # Final Fixation screen after trials completed
    fixation.draw()
    win.flip()
    #core.wait(final_fixation_dur)
    os.chdir(subjdir)
    trials.saveAsWideText(fileName)
    os.chdir(expdir)
    endTime = 0.01 # not sure if this will take a 0, so giving it 0.01 and making sure it is defined
    #expected_dur = 60
    #buffer_dur = 5
    #total_dur = expected_dur + buffer_dur
    #if globalClock.getTime() < total_dur:
    #    endTime = (total_dur - globalClock.getTime())
    #else:
    #    endTime = buffer_dur
    #core.wait(endTime)
    #print("globalClock.getTime()")

for run, trials in enumerate([trials_run1]):
    do_run(run, trials)

# Exit
exit_screen.draw()
win.flip()
event.waitKeys(keyList=('space'))
