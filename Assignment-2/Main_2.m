%% ADVANCED DIGITAL SIGNAL PROCESSING METHODS 
% Assignment 2 - Summer Semester 2020/2021
% Kavelidis Frantzis Dimitrios - AEM 9351 - kavelids@ece.auth.gr - ECE AUTH

%% Clearing
clear all
close all
clc

%% Assigning values
% Lamda and Wmega
lamda1 = 0.12;
lamda2 = 0.3;
lamda3 = lamda1+lamda2;
lamda4 = 0.19;
lamda5 = 0.17;
lamda6 = lamda4+lamda5;
lamda = [lamda1 lamda2 lamda3 lamda4 lamda5 lamda6]';
wmega = NaN(6,1);
for i = 1:6
    wmega(i) = 2*pi*lamda(i);
end
% Data Length N:
N = 8192;               % = 2^13
% Universaly distributed random variables phi
phi1 = 2*pi*rand;
phi2 = 2*pi*rand;
phi3 = phi1+phi2;
phi4 = 2*pi*rand;
phi5 = 2*pi*rand;
phi6 = phi4+phi5;
phi = [phi1 phi2 phi3 phi4 phi5 phi6]';

%% 1. Constract the X[k].
X = zeros(N,1);
for k = 1:N             % It is 0:N-1 so we assume our index k on MATLAB is k+1
    for j = 1:6
        X(k) = X(k)+cos(wmega(j)*k+phi(j));
    end
end
% Plot our data
figure()
plot(X)
title("Presentation of Data X[k]")
ylabel("X[k]")
xlabel("k")

% Plot a smaller sample of our data for a clearer review.
figure()
plot(X(1:800))
title("Presentation of Data X[k] - Smaller Sample")
ylabel("X[k]")
xlabel("k")

%% 2. Estimate the power spectrum C2(f) using L2 = 128 max shiftings for autocorrelation
% %Estimation of power spectrum using dsp toolbox and welch method
% SE = dsp.SpectrumEstimator;             % Creating SE object
% Pxx = SE(X);
% fvals = (0:length(Pxx)-1)/length(Pxx);
% plotter = dsp.ArrayPlot('XDataMode','Custom','CustomXData',fvals,...
%     'PlotType','Line','YLimits',[0 0.3], ...
%     'YLabel','Power Spectrum ','XLabel','Frequency (Hz)');
% plotter(Pxx)
% [pks1,locs1] = findpeaks(Pxx);
% lamdaFreqEst1 = locs1(1:length(locs1)/2)/length(Pxx)

% Estimation of power spectrum using autocorrelation and 128 shiftings
L2 = 128;                                          % max shiftings
[ACFX,lags] = xcorr(X,L2);                                % ACF including negative
ACFX = ACFX/max(ACFX);                             % Normalizing
acfX = autocorr(X,L2);                             % Autocorrelation
% Plot Autocorrelation
autocorr(X,L2)

tacf = -128:1:128;
figure()
plot(lags,ACFX)
title('Autocorrelation of X[k]')
xlabel('Time [sec]')
ylabel('ACF')
grid on

% Power spectrum
Pxx = abs(fft(acfX));                              % Power Spectrum
PxxR = abs(fft(ACFX));
% Getting the frequency axis
fvals = (0:length(Pxx)-1)/length(Pxx);
fvalsR = (0:length(PxxR)-1)/length(PxxR);
% Plot power spectrum
figure()
plot(fvals,Pxx)
title("Power Spectrum")
ylabel("P_x_x[f]")
xlabel("f")
line([0.5 0.5], [0 12],'Color','red','LineStyle','--')
hold on
[pks2,locs2] = findpeaks(Pxx,fvals,'NPeaks',6);                      % Finding locations of peaks
findpeaks(Pxx,fvals,'NPeaks',6);
text(locs2(1:6)+.02,pks2(1:6)-.5,num2str([1;5;4;2;6;3]))            % Display number of peak
text(locs2(1:6),pks2(1:6)+.8,num2str(locs2(1:6)'))           % Display the frequencies of interest

% % Power Spectrum but not with original acf, but acf shiffted
% figure()
% plot(fvalsR,PxxR)
% title("Power Spectrum")
% ylabel("P_x_x[f]")
% xlabel("f")
% line([0.5 0.5], [-5 25],'Color','red','LineStyle','--')
% hold on
% [pksR,locsR] = findpeaks(PxxR,fvalsR,'MinPeakHeight',5);                      % Finding locations of peaks
% findpeaks(PxxR,fvalsR,'MinPeakHeight',5);
% text(locsR(1:6)+.02,pksR(1:6)-.5,num2str([1;5;4;2;6;3]))            % Display number of peak
% text(locsR(1:6),pksR(1:6)+.8,num2str(locsR(1:6)'))           % Display the frequencies of interest


%% 3. Estimate the bispectrum (only in the primary area) using:
%% a. The indirect method with K = 32 , M = 256 , L3 = 64 and 
%% a1) Rectangular window a2) Parzen window
%% b. The direct method with K = 32 , M = 256 , J = 0
syms m
XeqY = m;
K = 32;
M = 256;
L3 = 64;


% 3.a.a1. --- Bispectrum / Indirect Method / Rectangular Window
% Biscpetrum estimation using the indirect method:

%%% For the whole plot, uncomment/turn on bspecPlotInfo2 and comment/turn
%%% off bspecPlotInfo
%%% And for the primary area, comment/turn off bspecPlotInfo and
%%% uncomment/turn on bspecPlotInfo2


figure()
[BspecIn1, waxisIn1] = bispeciV2(X,L3,M,0,'unbiased');      % Rectangular Window
% bspecPlotInfo
bspecPlotInfo2
figure()
contour3(waxisIn1,waxisIn1,abs(BspecIn1),250), grid on
title('Bispectrum in 3 dimensions / Indirect Method / Rectangular Window')
% bspecPlotInfo
bspecPlotInfo2

% ------------------------------------------------------------

% 3.a.a2. --- Bispectrum / Indirect Method / Parzen Window
figure()
[BspecIn2, waxisIn2] = bispeci(X,L3,M,0,'unbiased');        % Parzen window
% bspecPlotInfo
bspecPlotInfo2
figure()
contour3(waxisIn2,waxisIn2,abs(BspecIn2),250), grid on
title('Bispectrum in 3 dimensions / Indirect Method / Parzen Window')
% bspecPlotInfo
bspecPlotInfo2

% ------------------------------------------------------------

% 3.b --- Bispectrum / Direct Method
figure()
[BspecD, waxisD] = bispecd(X,M,1,M,0);
% bspecPlotInfo
bspecPlotInfo2
figure()
contour3(waxisD,waxisD,abs(BspecD),250), grid on
title('Bispectrum in 3 dimensions / Direct Method')
% bspecPlotInfo
bspecPlotInfo2

% ------------------------------------------------------------

% Bispectrum using indirect method (different function)   
figure()
[bisp,freq,cum,lag] = bisp3cum(X,M,L3,'none','u');      % Rectangular



%% 7. How the results change if you repeat the process taking into account
%% a) i) K = 16, M = 512 ii)K = 64, M = 128?
%% b) 50 realizations of the X[k] and comparing mean values of the estimated C2,C3
% 7.a.i)
Ka1 = 16;
Ma1 = 512;

% Bispectrum estimation using indirect method & rectangular window
figure()
[BspecIn1_7a1, waxisIn1_7a1] = bispeciV2(X,L3,Ma1,0,'unbiased');      % Rectangular Window
% bspecPlotInfo
bspecPlotInfo2


% ------------------------------------------------------------

% Bispectrum estimation using indirect method & Parzen window
figure()
[BspecIn2_7a1, waxisIn2_7a1] = bispeci(X,L3,Ma1,0,'unbiased');        % Parzen window
% bspecPlotInfo
bspecPlotInfo2

% ------------------------------------------------------------

% Bispectrum using direct method
figure()
[BspecD_7a1, waxisD_7a1] = bispecd(X,Ma1,1,Ma1,0);
% bspecPlotInfo
bspecPlotInfo2

% ------------------------------------------------------------

% Bispectrum using direct inmethod (different function)
figure()
[bisp_7a1,freq,cum,lag] = bisp3cum(X,Ma1,L3,'none','u');      % Rectanguar

% ------------------------------------------------------------
% ------------------------------------------------------------


% 7.a.ii)
Ka2 = 64;
Ma2 = 128;

% Bispectrum estimation using inverse method & rectangular window
figure()
[BspecIn1_7a2, waxisIn1_7a2] = bispeciV2(X,L3,Ma2,0,'unbiased');      % Rectangular Window
% bspecPlotInfo
bspecPlotInfo2

% ------------------------------------------------------------

% Bispectrum estimation using inverse method & Parzen window
figure()
[BspecIn2_7a2, waxisIn2_7a2] = bispeci(X,L3,Ma2,0,'unbiased');        % Parzen window
% bspecPlotInfo
bspecPlotInfo2

% ------------------------------------------------------------

% Bispectrum using direct method
figure()
[BspecD_7a2, waxisD_7a2] = bispecd(X,Ma2,1,Ma2,0);
% bspecPlotInfo
bspecPlotInfo2

% ------------------------------------------------------------

% Bispectrum using indirect method (different function)
figure()
[bisp_7a2,freq,cum,lag] = bisp3cum(X,Ma2,L3,'none','u');       % Rectanguar

% ------------------------------------------------------------
% ------------------------------------------------------------

% 7.b)
meanC2_X = zeros(length(Pxx),1);
meanC3_X = zeros(length(BspecIn2),length(BspecIn2));
Xvecs = zeros(N,50);

% Taking 50 realization of the X[k]
for i = 1:50
    X7 = zeros(N,1);
    phi1 = 2*pi*rand;
    phi2 = 2*pi*rand;
    phi3 = phi1+phi2;
    phi4 = 2*pi*rand;
    phi5 = 2*pi*rand;
    phi6 = phi4+phi5;
    phi = [phi1 phi2 phi3 phi4 phi5 phi6]';
    for k = 1:N             % It is 0:N-1 so we assume our index k on MATLAB is k+1
        for j = 1:6
            X7(k) = X7(k)+cos(wmega(j)*k+phi(j));
        end
    end
    Xvecs(:,i) = X7;
end

% Estimating C2 ,C3
for i = 1:50
    acfX7 = autocorr(Xvecs(:,i),L2);                               % Autocorrelation
    Pxx7 = abs(fft(acfX7));                                % Power Spectrum
    meanC2_X = meanC2_X + Pxx7;
    [BspecIn2_7, waxisIn2_7] = bispecd(Xvecs(:,i),L3,1,M,0);      % Rectangular Window
    meanC3_X = meanC3_X + BspecIn2_7;
end
meanC2_X = meanC2_X./50;
meanC3_X = meanC3_X./50;

nfft = 256;
if (rem(nfft,2) == 0) 
        waxis = [-nfft/2:(nfft/2-1)]/nfft; 
    else
        waxis = [-(nfft-1)/2:(nfft-1)/2]/nfft; 
end

% Plot Mean Estimation of Power Spectrum
% Getting the frequency axis
fvals_X = (0:length(meanC2_X)-1)/length(meanC2_X);
% Plot power spectrum
figure()
plot(fvals_X,meanC2_X)
title("Mean Estimation of Power Spectrum")
ylabel("P_x_x[f]")
xlabel("f")
line([0.5 0.5], [0 12],'Color','red','LineStyle','--')
hold on
[pks2_X,locs2_X] = findpeaks(meanC2_X,fvals_X);                      % Finding locations of peaks
findpeaks(meanC2_X,fvals_X,'NPeaks',6);
text(locs2_X(1:6)+.02,pks2_X(1:6)-.5,num2str([1;5;4;2;6;3]))            % Display number of peak
text(locs2_X(1:6),pks2_X(1:6)+.8,num2str(locs2_X(1:6)'))           % Display the frequencies of interest

% Plot Mean Estimation of Bispectrum
figure()
contour(waxis,waxis,abs(meanC3_X),4), grid on 
title('Mean Estimation of Bispectrum estimated via the direct method')
xlabel('f1'), ylabel('f2') 
set(gcf,'Name','Hosa BISPECI')

% bspecPlotInfo
bspecPlotInfo2
%% ------------------------ End of Assignment 2 -------------------------