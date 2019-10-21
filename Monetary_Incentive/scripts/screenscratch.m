function screenscratch(rating_beh, data_dir)

order = {'three', 'four', 'two', 'five', 'one'};
screens = {};
if size(screens,1) <10
    
    for o = 1:length(order)
        a = rating_beh.(order{o});
        while length(a) >= 4
            temp = Shuffle(a);
            screens=[screens; [temp(1:4) order(o)]];
            a = setdiff(a, temp(1:4));
            if size(screens,1) > 9; break; end;
        end
        if size(screens,1) > 9; break; end;
    end
end

screentemp1 = [screens; screens; screens] ;
screentemp2 = screentemp1(:,[2 1 4 3 5]) ;
screentemp = [screentemp1; screentemp2] ;
temp = Shuffle(1:length(screentemp)) ;
screentemp3=screentemp(temp,:) ;

screeninput.lchoice1 = screentemp(1:15, 1) ; 
screeninput.rchoice1 = screentemp(1:15, 2) ;
screeninput.lchoice2 = screentemp(16:30, 1) ; 
screeninput.rchoice2 = screentemp(16:30, 2) ;
screeninput.lchoice3 = screentemp(31:45, 1) ; 
screeninput.rchoice3 = screentemp(31:45, 2) ;
screeninput.lchoice4 = screentemp(46:60, 1) ; 
screeninput.rchoice4 = screentemp(46:60, 2) ;
screeninput.lcontrol1 = screentemp(1:15, 3) ; 
screeninput.rcontrol1 = screentemp(1:15, 4) ;
screeninput.lcontrol2 = screentemp(16:30, 3) ; 
screeninput.rcontrol2 = screentemp(16:30, 4) ;
screeninput.lcontrol3 = screentemp(31:45, 3) ;
screeninput.rcontrol3 = screentemp(31:45, 4) ;
screeninput.lcontrol4 = screentemp(46:60, 3) ;
screeninput.rcontrol4 = screentemp(46:60, 4) ;

save([data_dir '/screeninput'], 'screeninput') 
end