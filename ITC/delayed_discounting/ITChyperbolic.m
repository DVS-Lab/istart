function [out] = ITChyperbolic(choseDelayed,ImmedAmt,DelAmt,Delay)
% choseDelayed = 1 if delayed option is chosen, 0 if immediate option is chosen. Others are no choices
% All inputs must be column vectors. 2016-Jun-07, Arthur Lee

out.percentNow = (sum(choseDelayed == 0) / length(choseDelayed)) * 100;
out.percentDelayed = (sum(choseDelayed == 1) / length(choseDelayed)) * 100;
miss = choseDelayed ~= 0 & choseDelayed ~= 1;
out.percentMissed = (sum(miss)/length(choseDelayed)) * 100;
choice = choseDelayed(~miss);
IA = ImmedAmt(~miss);
DA = DelAmt(~miss);
D = Delay(~miss);
indiffk = (DA-IA)./(IA.*D);
mink = log(min(indiffk)*(0.99));
maxk = log(max(indiffk)*(1.01));

if (sum(choice) == length(choice)) || (sum(choice) == 0) % if choices are one-sided, assign extreme value
    if sum(choice) == length(choice)
        out.k=exp(mink);
    else
        out.k=exp(maxk);
    end
    out.noise = nan;
    out.LL = 0;
else
    [noise,ks] = meshgrid([-1, 1], linspace(mink,maxk,3)); % search grid
    b = [noise(:) ks(:)];
    info.negLL = inf;
    for i = 1:length(b)
        [new.b,new.negLL] = fmincon(@negLL,b(i,:),[],[],[],[],[log(eps),mink],[-log(eps),maxk],[],optimset('Display','off'),choice,IA,DA,D);
        if new.negLL < info.negLL
            info = new;
        end
    end
    out.k = exp(info.b(2));
    out.noise = exp(info.b(1));
    out.LL = -info.negLL;
end
out.LL0 = log(0.5)*length(choice);
out.r2 = 1 - out.LL/out.LL0;
SVlater = DA ./(1+out.k.*D);
predictedChoice = SVlater > IA; % 1 if delayed option is greater
out.percentPredicted = sum(predictedChoice == choice) / length(choice) * 100;
end

function negLL = negLL(beta,choice,IA,DA,D)
p = probcalc(beta,IA,DA,D);
negLL = -sum((choice==1).*log(p) + (choice==0).*log(1-p));
end

function p = probcalc(beta,IA,DA,D)
SVdelayed = DA./(1+exp(beta(2)).*D);
reg = exp(beta(1)).*(SVdelayed-IA);
p = 1 ./ (1 + exp(-reg));
p(p == 1) = 1-eps;
p(p == 0) = eps;
end
