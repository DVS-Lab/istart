function[parameterssinglesub] = setupdiscanalysis_singlesub(edattxtfile)
%3.15.18 Karolina Lempert
%Function that takes as input the name of an edat text file, with the raw
%data from a participant (this text file is output along with the edat data
%file), and returns hyperbolic discount rate parameters for one subject.
%runs a function I found online called "eprimetxt2vars" to convert the raw
%data file into a Matlab table
[T,headervars]=eprimetxt2vars(edattxtfile);
%then we convert from table to cell array
c = table2cell(T);

%delete the first 4 rows of the cell array, since these are the practice
%trials.
c(1:4,:) = [];

%number of choices in the task, which is 51 in this case.
numberchoices = 51;
%creating a matrix "subject", first column is the subject number
subject(:,1) = c{end,end}*ones(numberchoices,1);
%fourth column is the amount of the immediate reward
subject(:,4) = cell2mat(c(:,28));
%fifth column is the amount of the delayed reward
subject(:,5) = cell2mat(c(:,29));
%seventh column is the LeftRight variable, indicating whether Amount14
%or Amount6 was seen on that trial.
subject(:,7) = cell2mat(c(:,32));
 
%converts "f"s and "j"s into 1s and 0s and puts them into the subject
%matrix in columns 2 and 3.
for jax = 1:numberchoices
    if c{jax,16} == 'f', 
        subject(jax,2) = 1;
    elseif c{jax,16} == 'j'
        subject(jax,2) = 0;
    end
    if c {jax,25} == 'f', 
        subject(jax,3) = 1;
    elseif c {jax,25} == 'j'
        subject(jax,3) = 0;
    end
    %also converts the days variable from a string to a number and puts
    %that into the subject matrix as column 6.
    subject(jax,6) = str2num(c{jax,31});
end
%this next loop makes a new column in "Subject" that indicates the choice
%on that trial (0 = chose immediate; 1 = chose delayed), based on the
%LeftRight variable and the choice of left or right on that trial.
for i = 1:length(subject)
   if subject(i,7) == 1 && subject(i,3) == 1
       subject(i,8) = 0;
   elseif subject(i,7) == 1 && subject(i,3) == 0
       subject(i,8) = 1;
   end

   if subject(i,7) == 0 && subject(i,2) == 1
       subject(i,8) = 1;
   elseif subject(i,7) == 0 && subject(i,2) == 0
       subject(i,8) = 0;
   end
end
%gets parameters for the subject by running the ITCHyperbolic script.
choseDelayed = subject(1:end,8);
ImmedAmt = subject(1:end,4);
DelAmt = subject(1:end,5);
Delay = subject(1:end,6);
[out] = ITChyperbolic(choseDelayed,ImmedAmt,DelAmt,Delay);
parameterssinglesub(1,1) = subject(1,1);
%subject number in first column
parameterssinglesub(1,2) = out.k;
%discount rate k in second column
parameterssinglesub(1,3) = out.percentDelayed;
%percent of choices that were for delayed reward in 3rd column
parameterssinglesub(1,4) = out.noise;
%noise parameter in 4th column. Not often used but it is another fit
%parameter of the model and tells you about how consistent subjects were
parameterssinglesub(1,5) = out.LL;
%log-likelihood of model fit (in case you want to compare to other models)
end
