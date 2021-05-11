%% ADVANCED DIGITAL SIGNAL PROCESSING METHODS 
% Assignment 3 - Summer Semester 2020/2021
% Kavelidis Frantzis Dimitrios - AEM 9351 - kavelids@ece.auth.gr - ECE AUTH

% Description: Validity check of Giannakis' formula

%% Clearing
clear all
close all
clc
tic                                     % Start clock
%% Assigning values
% Generating MA model (Non Gaussian Noise derived from exponential dist)

lengthOfData = 2048;                    % Data Length
q = 5;                                  % MA Order
b = [1,0.93,0.85,0.72,0.59,-0.1];       % MA parameters
load('X.mat')

%% 1. Justify the non-Gaussian character of input v[k] by calculating its skewness
sk = skewness(vn)

sk2 = 0;
for i = 1:lengthOfData
    sk2 = sk2 + ((vn(i)-mean(vn))^3)/((lengthOfData-1)*std(vn)^3);
end
sk2
% we get skewness different than zero, so we have non gaussian noise

%% 2. Estimate and plot the 3rd order cumulants of x[k], c3, using the
%% indirect method with K = 32, M = 64, L3 = 20
M = 64;
K = 32;
L3 = 20;
nfft = 2*L3+1;
waxis = [-nfft/2:(nfft/2-1)];
[~,~,cum3,~] = bisp3cumV2(x,M,L3,'n','u');
figure()
contour(waxis,waxis,cum3,250);
title('3rd order Cumulants - 2D')
xlabel('\tau_1')
ylabel('\tau_2')
figure()
contour3(waxis,waxis,cum3,250);
title('3rd order Cumulants - 3D')
xlabel('\tau_1')
ylabel('\tau_2')
zlabel('Magnitude')
% % Primary area
% c3 = cum3(21:end,21:end);
% figure()
% contour3(waxis(21:end),waxis(21:end),c3,250);

%% Use the c3 to estimate the impulseresponse h[k] of the MA system using
%% Giannakis' formula: h[k] = c3(q,k)/c3(q,0) , k = 0,1,...,q, h[k] = 0,k>0
h = GiannakisFormula(q,cum3)

%% 4. Estimate h[k] of the MA system with G. formula, yet considering:
%% a) Sub-estimation of the order q,that is, hsub: MA(qsub) where qsub= q-2
%% b) Sup-estimation of the order q,that is, hsup: MA(qsub) where qsup= q+3
%%
% 4.a)
hsub = GiannakisFormula(q-2,cum3)
% 4.b)
hsup = GiannakisFormula(q+3,cum3)

%% 5. Estimate NRMSE
xest = conv(vn,h,'same')';
plotDif(x,xest,q)
nrmseX = nrmse(x,xest)

%% 6. Repeat step 5 for xsub and xsup
xest_sub = conv(vn,hsub,'same')';
plotDif(x,xest_sub,q-2)
nrmseXsub = nrmse(x,xest_sub)

xest_sup = conv(vn,hsup,'same')';
plotDif(x,xest_sup,q+3)
nrmseXsup = nrmse(x,xest_sup)
%% 7. Add white Gaussian Noise at the output
snr = [30:-5:-5]';
% snr = [30:-1:-5]';
Y = zeros(lengthOfData,length(snr));
NRMSEs = zeros(length(snr),1);
Hs = zeros(q+1,length(snr));

for i = 1:length(snr)
    y = awgn(x,snr(i),'measured');
    Y(:,i) = y;
    % Calculating C3
    [~,~,cum3_t,~] = bisp3cumV2(Y(:,i),M,L3,'n','u');
    % Estimating h
    Hs(:,i) = GiannakisFormula(q,cum3_t);
    yest_t = conv(vn,Hs(:,i),'same')';
    NRMSEs(i) = nrmse(y,yest_t);
end


figure()
plot(snr,NRMSEs)
xlabel('SNR [dB]')
ylabel('NRMSE')
title('Effect of SNR to NRMSE')
toc                                                 % Stop clock
%% 8. Repeat the whole procedure for 50 realizations to find the mean NRMSEs
tic                                                 % Start clock

meanNRMSEs = zeros(length(snr),1);
meanNRMSEsub = zeros(length(snr),1);
meanNRMSEsup = zeros(length(snr),1);
n = 50;
H = zeros(q+1,1);

% Choose 131072 for showing accuracy, 2048 to show the non practical aspect
% of the method:
% length8 = 131072;
length8 = 2048;

if length8 == 131072
    disp('Approximate time of waiting: 45 sec')
end


for j = 1:n
    [x8,v8] = x_v_sigs(length8);                    % Step 1
    
    [~,~,cum3_8,~] = bisp3cumV2(x8,M,L3,'n','u');   % Step 2
    
    h8 = GiannakisFormula(q,cum3_8);                % Step 3
    
    h8sub = GiannakisFormula(q-2,cum3_8);           % Step 4
    h8sup = GiannakisFormula(q+3,cum3_8);

    xest8 = conv(v8,h8,'same')';                    % Step 5
%     plotDif(x8,xest8,q)
    nrsme8 = nrmse(x8,xest8);                    
    
    xest8sub = conv(v8,h8sub,'same')';              % Step 6
%     plotDif(x8,xest8sub,q)
    nrmse8sub = nrmse(x8,xest8sub);
    
    xest8sup = conv(v8,h8sup,'same')';
%     plotDif(x8,xestsup,q)
    nrmse8sup = nrmse(x8,xest8sup);
    
    
    Y8 = zeros(length8,length(snr),50);             % Step 7
    % NRMSEs vectors to add on each iteration 
    NRMSEs8 = zeros(length(snr),1);
    NRMSEsub = zeros(length(snr),1);
    NRMSEsup = zeros(length(snr),1);
    
    % Impulse response of MA systems
    Hs = zeros(q+1,length(snr));
    Hsub = zeros(q+1-2,length(snr));
    Hsup = zeros(q+1+3,length(snr));

    for i = 1:length(snr)                           
        y8 = awgn(x8,snr(i),'measured');         % Contaminate with noise
        Y8(:,i,j) = y8;
        % Calculating C3
        [~,~,cum3_8i,~] = bisp3cumV2(y8,M,L3,'n','u');
        % Estimating h
        Hs(:,i) = GiannakisFormula(q,cum3_8i);
        Hsub(:,i) = GiannakisFormula(q-2,cum3_8i);
        Hsup(:,i) = GiannakisFormula(q+3,cum3_8i);
        
        yest_8 = conv(v8,Hs(:,i),'same')';
        yest_8sub = conv(v8,Hsub(:,i),'same')';
        yest_8sup = conv(v8,Hsup(:,i),'same')';
        NRMSEs8(i) = nrmse(y8,yest_8);
        NRMSEsub(i) = nrmse(y8,yest_8sub);
        NRMSEsup(i) = nrmse(y8,yest_8sup);
    end
    meanNRMSEs = meanNRMSEs + NRMSEs8;
    meanNRMSEsub = meanNRMSEsub + NRMSEsub;
    meanNRMSEsup = meanNRMSEsup + NRMSEsup;
end

% Finding the meanNRMSEs
meanNRMSEs = meanNRMSEs/n;
meanNRMSEsub = meanNRMSEsub/n;
meanNRMSEsup = meanNRMSEsup/n;

% Confidence interval of mean NRMSEs:

% Critical values
a = 0.05;
% cv = [-1.96 1.96]; 
cv = tinv([a/2  1-a/2],length(meanNRMSEs)-1);

% Standard error
SE = std(meanNRMSEs)/sqrt(length(meanNRMSEs));
SEsub = std(meanNRMSEsub)/sqrt(length(meanNRMSEsub));
SEsup = std(meanNRMSEsup)/sqrt(length(meanNRMSEsup));

% Lower and upper bounds
CI = meanNRMSEs + SE*cv;

CIsub = meanNRMSEsub + SEsub*cv;

CIsup = meanNRMSEsup + SEsup*cv;

% Plot mean NRMSEs 
figure()
subplot(3,1,1)
plot(snr,meanNRMSEs)
% plotstd(snr,meanNRMSEs,std(meanNRMSEs))
ylim([0 1])
xlabel('SNR [dB]')
ylabel('NRMSE')
title('Mean NRMSE vs SNR')
hold on
plot(snr,CI(:,1),'r--')
plot(snr,CI(:,2),'g--')
legend('Mean NRMSEs','CI lower bound','CI upper bound')

% Plot mean NRMSEs for sub estimation
subplot(3,1,2)
%figure()
plot(snr,meanNRMSEsub)
% plotstd(snr,meanNRMSEsub,std(meanNRMSEsub))
ylim([0 1])
xlabel('SNR [dB]')
ylabel('NRMSE')
title('Mean NRMSE of subestimation vs SNR')
hold on
plot(snr,CIsub(:,1),'r--')
plot(snr,CIsub(:,2),'g--')
legend('Mean NRMSEs','CI lower bound','CI upper bound')

% Plot mean NRMSEs for sup estimation
subplot(3,1,3)
%figure()
plot(snr,meanNRMSEsup)
% plotstd(snr,meanNRMSEsup,std(meanNRMSEsup))
ylim([0 1])
xlabel('SNR [dB]')
ylabel('NRMSE')
title('Mean NRMSE of supestimation vs SNR')
hold on
plot(snr,CIsup(:,1),'r--')
plot(snr,CIsup(:,2),'g--')
legend('Mean NRMSEs','CI lower bound','CI upper bound')


toc                                     % Stop clock
%% ------------------------ End of 3rd Assignment -------------------------