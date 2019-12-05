
# coding: utf-8

# In[1]:


#This script plays a 2 alt Force choice game for risk lotteries and Ambiguous Lotteries
#This cell imports out library and sets some global variables

from psychopy import visual, core, event, data, logging,gui
import sys
import os
import csv
import random
import numpy as np
import pandas as pd
#I want two different things to run for risk and Amb so we'll need 2 different data
#Risk should need Lottery_RL|Lottery %| Lottery $|Lottery_color| Sure $
# Ambiguity should need Amb_RL|Amb_type|Amb$|Risk%|Risk$
lot_color=['red','green','blue']
random.shuffle(lot_color)
Prizes=[8]
sure_prize=[5]
Lot_pers=np.array([0,10,20,30,40,50,60,70,80,90,100])
# Distribution of lotteries
wide_d=[0,0,0,0,1,1,1,1,2,2,8,8,9,9,9,9,10,10,10,10]
narrow_d=[3,3,4,4,4,4,5,5,5,5,5,5,5,5,6,6,6,6,7,7]
skew_d=[x+3 for x in narrow_d]
left=np.concatenate((np.repeat(0,10),np.repeat(1,10)))
print(left)


# In[2]:


#This cell sets up the risky lotteries
#left is shuffled each time so that there is a random order of left vs right and equal number for each color lot
# The data frames then get combined later
random.shuffle(left)
W_trials=pd.DataFrame({'LotisLeft':left,
                       'Lot_per':Lot_pers[wide_d],
                      'Lot_mon':Prizes[0],
                      'Lot_color':lot_color[0],
                      'Sure_mon':sure_prize[0]})
W_trials['dist']='wide'
random.shuffle(left)
N_trials=pd.DataFrame({'LotisLeft':left,
                       'Lot_per':Lot_pers[narrow_d],
                      'Lot_mon':Prizes[0],
                      'Lot_color':lot_color[1],
                      'Sure_mon':sure_prize[0]})
N_trials['dist']='Narrow'

random.shuffle(left)
S_trials=pd.DataFrame({'LotisLeft':left,
                       'Lot_per':Lot_pers[skew_d],
                      'Lot_mon':Prizes[0],
                      'Lot_color':lot_color[2],
                      'Sure_mon':sure_prize[0]})
S_trials['dist']='Skew'
random.shuffle(left)


# In[3]:


from sklearn.utils import shuffle
R_trials=pd.concat([N_trials,W_trials,S_trials])
R_trials=R_trials.sample(frac=1).reset_index(drop=True)
#display(R_trials.head())
R_trials.sort_values(by=['Lot_color'])

aa_data=[[r,m,c,Amb] for c in np.concatenate((lot_color,['yellow']))for Amb in [100,50]for r in Lot_pers[[3,4,5,6,7,8,9]] for m in [8] ]
A_trials=pd.DataFrame(data=aa_data,columns=['Risk_per','Money','Color','Amb'])
A_trials['RiskisLeft'] = np.random.randint(0, 2, A_trials.shape[0])
#A_trials=A_trials.sample(frac=1).reset_index(drop=True)
#display(A_trials.head())


# In[4]:


#Here we defined the risky choices

def risk_choice(lot_col,lot_m,lot_p,lot_left,sure_m):
    event.clearEvents()

    print([lot_left,lot_p,lot_m,lot_col,sure_m])
    if lot_col=='red':
        col_code=[1,0,0]
    elif lot_col=='green':
        col_code=[0,1,0]
    else:
        col_code=[0,0,1]
    
    if lot_left:
        lot_pos=-300
        sure_pos=(300,0)
    else:
        lot_pos=300
        sure_pos=(-300,0)
        
    tmp_div=np.divide(lot_p,100.00)
    shade=np.multiply(360.00,tmp_div)+1
    print(shade)
    
    Outline= visual.RadialStim( win=win, name='OUTLINE', color=col_code,opacity=1,
                                angularCycles = 0, radialCycles = 0, radialPhase = 0.5, colorSpace = 'rgb', 
                                ori= 45.0, pos=(lot_pos,0), size=(400,400))
    Outline2= visual.RadialStim( win=win, name='OUTLINE_in', color=[0,0,0],opacity=1,
                                angularCycles = 0, radialCycles = 0, radialPhase = 0.5, colorSpace = 'rgb', 
                               ori= 45.0, pos=(lot_pos,0), size=(380,380))
     
    Outline.draw()
    Outline2.draw()
    
    Lot_a_win=visual.RadialStim(win=win,units="pix",name='Lot', color=col_code,opacity=1,
                          angularCycles = 0, radialCycles = 0, radialPhase = 0.5, colorSpace = 'rgb', 
                          ori= -90.0,pos=(lot_pos,0), size=(300,300),visibleWedge=(0.0, shade))
    
    Lot_a_lose= visual.RadialStim( win=win, name='rad2', color=col_code,opacity=0.5,
                                angularCycles = 0, radialCycles = 0, radialPhase = 0.5, colorSpace = 'rgb', 
                                ori= 45.0, pos=(lot_pos,0), size=(300,300))
    Lot_a_lose.draw()
    Lot_a_win.draw()
    
    
    SureMoney=visual.TextStim(win=win,text="$ %s"%(sure_m),pos=sure_pos,bold=True)
    SureMoney.draw()
    
    Lot_per=visual.TextStim(win=win,text="%s %%"%(lot_p),pos=(lot_pos,-50),bold=True)
    Lot_Money=visual.TextStim(win=win,text="$ %s"%(lot_m),pos=(lot_pos,50),bold=True)
    Lot_per.draw()
    Lot_Money.draw()
    focus=visual.TextStim(win=win,text='+')
    
   
    focus.draw()
   
    win.flip()
    timer.reset()
    
    
    core.wait(0.5)
    keys=event.waitKeys(keyList=['f', 'j','escape'],maxWait=5)
    RT=timer.getTime()

        
    if not keys:
        keys='No_resp'
        RT=10

            
   
    wait_sec=6-RT
    focus.draw()
    win.flip()   
    core.wait(wait_sec)
    core.wait(0.5)
    return keys,RT


# In[5]:


#Here we define the Ambiguous choices
#Risk_per 	Money 	Color 	Amb 	RiskisLeft
def Amb_choice(lot_left,lot_p,money,lot_col,Amb_level):
    event.clearEvents()

    print([lot_left,lot_p,money,lot_col,Amb_level])
    if lot_col=='red':
        col_code=[1,0,0]
    elif lot_col=='green':
        col_code=[0,1,0]
    elif lot_col=='blue':
        col_code=[0,0,1]
    else:
        col_code=[1,1,0]

    
    if lot_left:
        lot_pos=-300
        amb_pos=300
    else:
        lot_pos=300
        amb_pos=-300
        
    tmp_div=np.divide(lot_p,100.00)
    shade=np.multiply(360.00,tmp_div)+1
    
    tmp_div=np.divide(Amb_level,100.00)
    amb_shade=np.multiply(360.00,tmp_div)+1
    
    print(shade)
    
    # The risky lottery has 3 parts. The Outline Win ammount. & Lose Amount
    R_Outline= visual.RadialStim( win=win, name='OUTLINE', color=col_code,opacity=1,
                                angularCycles = 0, radialCycles = 0, radialPhase = 0.5, colorSpace = 'rgb', 
                                ori= 45.0, pos=(lot_pos,0), size=(400,400))
    R_Outline2= visual.RadialStim( win=win, name='OUTLINE_in', color=[0,0,0],opacity=1,
                                angularCycles = 0, radialCycles = 0, radialPhase = 0.5, colorSpace = 'rgb', 
                               ori= 45.0, pos=(lot_pos,0), size=(380,380))
     
    R_Outline.draw()
    R_Outline2.draw()
    
    Lot_a_win=visual.RadialStim(win=win,units="pix",name='Lot', color=col_code,opacity=1,
                          angularCycles = 0, radialCycles = 0, radialPhase = 0.5, colorSpace = 'rgb', 
                          ori= -90.0,pos=(lot_pos,0), size=(300,300),visibleWedge=(0.0, shade))
    
    Lot_a_lose= visual.RadialStim( win=win, name='rad2', color=col_code,opacity=0.5,
                                angularCycles = 0, radialCycles = 0, radialPhase = 0.5, colorSpace = 'rgb', 
                                ori= 45.0, pos=(lot_pos,0), size=(300,300))
    Lot_a_lose.draw()
    Lot_a_win.draw()

    #The Ambiguous Lottery has 4 parts the Outline, Win shade, Lose Shade, & ambiguity shade
    A_Outline= visual.RadialStim( win=win, name='OUTLINE', color=col_code,opacity=1,
                                angularCycles = 0, radialCycles = 0, radialPhase = 0.5, colorSpace = 'rgb', 
                                ori= 0, pos=(amb_pos,0), size=(400,400))
    A_Outline2= visual.RadialStim( win=win, name='OUTLINE_in', color=[0,0,0],opacity=1,
                                angularCycles = 0, radialCycles = 0, radialPhase = 0.5, colorSpace = 'rgb', 
                               ori= 0, pos=(amb_pos,0), size=(380,380))
     
    A_Outline.draw()
    A_Outline2.draw()
    
    A_win=visual.RadialStim(win=win,units="pix",name='Lot', color=col_code,opacity=1,
                          angularCycles = 0, radialCycles = 0, radialPhase = 0.5, colorSpace = 'rgb', 
                          ori= 0,pos=(amb_pos,0), size=(300,300),visibleWedge=(0.0,180))
    
    A_lose = visual.RadialStim( win=win, name='rad2', color=col_code,opacity=0.3,
                                angularCycles = 0, radialCycles = 0, radialPhase = 0.5, colorSpace = 'rgb', 
                                ori= 0, pos=(amb_pos,0), size=(300,300))
    cover= visual.RadialStim( win=win, name='rad2', color=[0.2,0.2,0.2],opacity=1,
                                angularCycles = 0, radialCycles = 0, radialPhase = 0.5, colorSpace = 'rgb', 
                                ori= 90.0, pos=(amb_pos,0), size=(300,300),visibleWedge=(0.0,amb_shade))
    
    A_lose.draw()
    A_win.draw()
    cover.draw()
    
    AmbMoney=visual.TextStim(win=win,text="$ %s"%(money),pos=(amb_pos,50),bold=True)
    AmbMoney.draw()
    if Amb_level==100:
        am_per_text="0% - 100%"
    elif Amb_level==50:
        am_per_text="25% - 75%"
    AmbPer=visual.TextStim(win=win,text=am_per_text,pos=(amb_pos,-50),bold=True)
    AmbPer.draw()
    
    
    Lot_per=visual.TextStim(win=win,text="%s %%"%(lot_p),pos=(lot_pos,-50),bold=True)
    Lot_Money=visual.TextStim(win=win,text="$ %s"%(money),pos=(lot_pos,50),bold=True)
    Lot_per.draw()
    Lot_Money.draw()
    focus=visual.TextStim(win=win,text='+')
    
   
    focus.draw()
   
    win.flip()
    timer.reset()
    
    
    core.wait(0.5)
    keys=event.waitKeys(keyList=['f', 'j','escape'],maxWait=3)
    RT=timer.getTime()
    print(RT)
    
    if lot_col==lot_color[0]:
        dist='wide'
    elif lot_col==lot_color[1]:
        dist='narrow'
    elif lot_col==lot_color[2]:
        dist='skew'
    elif lot_col=='yellow':
        dist='True_unkown'
        
        
    
    if not keys:
        keys='No_resp'
        RT=3
        
    wait_sec=6-RT
    focus.draw()
    win.flip()   
    core.wait(wait_sec)
    core.wait(0.5)
    return keys,RT,dist


# In[6]:


#Here we define instructions
def instruction(instructions):
    print(instructions)
    if any(instructions.endswith(x) for x in ('.jpg','.gif','.png','.bmp')):
        Inst_IMG=visual.ImageStim(win=win, image=instructions)
        Inst_IMG.draw()
        win.flip()
    else:
        Inst_text=visual.TextStim(win=win,text=instructions,size=50)
        Inst_text.draw()
        win.flip()
    keys=event.waitKeys()
    print(keys)


# In[7]:


response_R_trials=pd.DataFrame(columns=['Keypress','RT'])
timer = core.Clock()
win=visual.Window(fullscr=False,
                  size=[3000,1000],
                  units="pix")

Stimdir="Stim/"

responses=[]
subjDlg = gui.Dlg(title="JOCN paper - rate items")
subjDlg.addField('Enter Subject ID: ')
subjDlg.show()
subj_id=subjDlg.data[0]
os.makedirs("../data/sub-%s"%(subj_id),exist_ok=True)


R_inst=["img0.jpg","img1.jpg","img2.jpg","img3.jpg","img4.jpg","img5.jpg","img6.jpg"]
A_inst=["img7.jpg","img8.jpg","img9.jpg","img10.jpg","img11.jpg"]

if len(subj_id) < 1: # Make sure participant entered name
    core.quit()
for page in R_inst:
    instruction(Stimdir+page)
    
#LotisLeft 	Lot_per 	Lot_mon 	Lot_color 	Sure_mon 	dist
#def risk_choice(lot_col,lot_m,lot_p,lot_left,sure_m):


#for i in range(2):
for i in range(len(R_trials)):
    row=R_trials.iloc[i]
    print(row)
    resp,RT=risk_choice(row[3],row[2],row[1],row[0],row[4])
    responses.append(np.concatenate([row,[resp,RT]]))
    print(resp,RT)
    # Lets participant quit at any time by pressing escape button
    if 'escape' in resp:
        win.close()
        core.quit()
R_resp=pd.DataFrame(data=responses,columns=np.concatenate([R_trials.columns.to_list(),['response','RT']]))
R_resp.to_csv("../data/sub-%s/sub-%s_task-risk_events.csv"%(subj_id,subj_id),index = False)
       
for page in A_inst:
    instruction(Stimdir+page)
    
#Risk_per 	Money 	Color 	Amb 	RiskisLeft
#def Amb_choice(lot_left,lot_p,money,lot_col,Amb_level):

responses=[]
#for i in range(2):
for i in range(len(A_trials)):
    row=A_trials.iloc[i]
    print(row)
    resp,RT,dist=Amb_choice(row[4],row[0],row[1],row[2],row[3])
    responses.append(np.concatenate([row,[resp,RT,dist]]))
    print(resp,RT)
    # Lets participant quit at any time by pressing escape button
    if 'escape' in resp:
        win.close()
        core.quit()
A_resp=pd.DataFrame(data=responses,columns=np.concatenate([A_trials.columns.to_list(),['response','RT','dist']]))
A_resp.to_csv("../data/sub-%s/sub-%s_task-ambiguity_events.csv"%(subj_id,subj_id),index = False)

win.close()
core.quit()


# In[ ]:


win.close()

