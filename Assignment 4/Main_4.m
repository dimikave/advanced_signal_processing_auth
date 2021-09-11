%% ADVANCED DIGITAL SIGNAL PROCESSING METHODS 
% Assignment 4 - Summer Semester 2020/2021
% Kavelidis Frantzis Dimitrios - AEM 9351 - kavelids@ece.auth.gr - ECE AUTH

% Description: 
% CEPSTRUM via HOMOMORPHIC FILTERING:
% - Acquire voice samples making the five vowel sounds
% - Compute the cepstrum with different methods
% - Lifter the cepstrum domain signals
% - Try to synthesize back the voiced signals

% Equipment used for obtaining vocal samples:
% - Behringer B1 microphone : 
%   https://www.behringer.com/product.html?modelCode=P0142
% - BOSS RC-505 Loopstation used as audio interface:
%   https://www.boss.info/global/products/rc-505/

% Software used to get the samples:
% - RC-505 Editor
% - Ableton Live 11 
%% Clearing
clear all
close all
clc
% tic                                     % Start clock
%% 1. Import audio files
filenameF = 'Samples\Female1\';     % Directory with female samples
filenameM = 'Samples\Male1\';       % Directory with male samples
Fs = 44100;                         % Sampling frequency of RC-505


% Female Samples
[femA,femE,femI,femO,femU] = getSamples(filenameF);
[malA,malE,malI,malO,malU] = getSamples(filenameM);
% Female Samples - Plots
vowelPlots(filenameF,' Female',Fs);           % Plots of vowels
% Male Samples - Plots
vowelPlots(filenameM,' Male', Fs);            % Plots of vowels


% %% Another way of getting samples on the spot:
% s = audiorecorder(8000,16,1);
% 
% fprintf('Press a key to record vowel A for 5 sec: \n')
% pause;
% recordblocking(s,5); % sing aaaaaaa
% a = getaudiodata(s);
% 
% fprintf('Press a key to record vowel E for 5 sec: \n')
% pause;
% recordblocking(s,5); % sing eeeeeee
% e = getaudiodata(s);
% 
% fprintf('Press a key to record vowel O for 5 sec: \n')
% pause;
% recordblocking(s,5); % sing oooooooo
% o = getaudiodata(s);
% 
% fprintf('Press a key to record vowel I for 5 sec: \n')
% pause;
% recordblocking(s,5); % sing iiiiiii
% i = getaudiodata(s);
% 
% fprintf('Press a key to record vowel U for 5 sec: \n')
% pause;
% recordblocking(s,5); % sing uuuuuuu
% u = getaudiodata(s);
% 
% vowelPlots(a,e,o,i,u,' Specify Gender',8000)
% vowelPlots(a(10000:13000),e(10000:13000),o(10000:13000)...
%     ,i(10000:13000),u(10000:13000),' Specify Gender',8000)

warning('off')
%% 2-3-4. Computing Cepstrum
%% Female vowels cepstrum analysis & synthesis
% Reconstructed signals calculated from the convolution of the short 
% segment's impulse response and original signal's pitch.

% Female Gain
gainF = 13;

% Female A
% [fA,fAwin,CrfA,CfA,CcentfA,hfA] = VowelAnalysis(filenameF,'A',50,10135,12135);
[fA,fAwin,CrfA,CfA,CcentfA,hfA] = VowelAnalysis(filenameF,'A',40,10000,10950);
% [fA,fAwin,CrfA,CfA,CcentfA,hfA] = VowelAnalysis(filenameF,'A','f',28,10000,10590);
fprintf('Plots of female aah - Press a key to hear sound\n')
pause;
pfA = getOriginalPitch(femA,28);
% Original sound
fprintf('Playing sound of original signal - Press a key to move on\n');
sound(femA(1:Fs*3),Fs)          % Play for 3 seconds
pause;
close all;
% Synthesized sound
fprintf('Playing sound of the reconstructed signal - Press a key to move on\n');
recfA = conv(pfA,hfA);
sound(gainF*recfA(1:Fs*3),Fs)
pause; 

% Female E
% [fE,fEwin,CrfE,CfE,CcentfE,hfE] = VowelAnalysis(filenameF,'E',40,10000,12000);
[fE,fEwin,CrfE,CfE,CcentfE,hfE] = VowelAnalysis(filenameF,'E',54,10000,10930);
fprintf('Plots of female eeh - Press a key to hear sound\n')
pause;
pfE = getOriginalPitch(femE,54);
% Original sound
fprintf('Playing sound of original signal - Press a key to move on\n');
sound(femE(1:Fs*3),Fs)          % Play for 3 seconds
pause;
close all;
% Synthesized sound
fprintf('Playing sound of the reconstructed signal - Press a key to move on\n');
recfE = conv(pfE,hfE);
sound(gainF*recfE(1:Fs*3),Fs)
pause;

% Female I
% [fI,fIwin,CrfI,CfI,CcentfI,hfI] = VowelAnalysis(filenameF,'I',50,10000,12000);
[fI,fIwin,CrfI,CfI,CcentfI,hfI] = VowelAnalysis(filenameF,'I',50,10000,10950);
fprintf('Plots of female iii - Press a key to hear sound\n')
pause;
pfI = getOriginalPitch(femI,50);
% Original sound
fprintf('Playing sound of original signal - Press a key to move on\n');
sound(femI(1:Fs*3),Fs)          % Play for 3 seconds
pause;
close all;
% Synthesized sound
fprintf('Playing sound of the reconstructed signal - Press a key to move on\n');
recfI = conv(pfI,hfI);
sound(gainF*recfI(1:Fs*3),Fs)
pause;
 
% Female O
[fO,fOwin,CrfO,CfO,CcentfO,hfO] = VowelAnalysis(filenameF,'O',58,10000,10950);
% [fO,fOwin,CrfO,CfO,CcentfO,hfO] = VowelAnalysis(filenameF,'O',12,10000,10660);
fprintf('Plots of female ooh - Press a key to hear sound\n')
pause;
pfO = getOriginalPitch(femO,58);
% Original sound
fprintf('Playing sound of original signal - Press a key to move on\n');
sound(femO(1:Fs*3),Fs)          % Play for 3 seconds
pause;
close all;
% Synthesized sound
fprintf('Playing sound of the reconstructed signal - Press a key to move on\n');
recfO = conv(pfO,hfO);
sound(gainF*recfO(1:Fs*3),Fs)
pause;

% Female U
[fU,fUwin,CrfU,CfU,CcentfU,hfU] = VowelAnalysis(filenameF,'U',61,10000,10940);
% [fU,fUwin,CrfU,CfU,CcentfU,hfU] = VowelAnalysis(filenameF,'U',23,10000,10660);
fprintf('Plots of female  uuu - Press a key to hear sound\n')
pause;
pfU = getOriginalPitch(femU,61);
% Original sound
fprintf('Playing sound of original signal - Press a key to move on\n');
sound(femU(1:Fs*3),Fs)          % Play for 3 seconds
pause;
close all;
% Synthesized sound
fprintf('Playing sound of the reconstructed signal - Press a key to move on\n');
recfU = conv(pfU,hfU);
sound(gainF*recfU(1:Fs*3),Fs)
pause;

%% Male vowels cepstrum analysis & synthesis
% Reconstructed signals calculated from the convolution of the short 
% segment's impulse response and original signal's pitch.

% Male reconstructed signals gain
gainM = 4;

% Male A
[mA,mAwin,CrmA,CmA,CcentmA,hmA] = VowelAnalysis(filenameM,'A',42,10000,12000);
fprintf('Plots of male aah - Press a key to hear sound\n')
pause;
pmA = getOriginalPitch(malA,42);
% Original sound
fprintf('Playing sound of original signal - Press a key to move on\n');
sound(malA(1:Fs*3),Fs)          % Play for 3 seconds
pause;
close all;
% Synthesized sound
fprintf('Playing sound of the reconstructed signal - Press a key to move on\n');
recmA = conv(pmA,hmA);
sound(gainM*recmA(1:Fs*3),Fs)   % Play for 3 seconds
pause;

% Male E
[mE,mEwin,CrmE,CmE,CcentmE,hmE] = VowelAnalysis(filenameM,'E',90,10000,12000);
fprintf('Plots of male eeh - Press a key to hear sound\n')
pause;
pmE = getOriginalPitch(malE,90);
% Original sound
fprintf('Playing sound of original signal - Press a key to move on\n');
sound(malE(1:Fs*3),Fs)          % Play for 3 seconds
pause;
close all;
% Synthesized sound
fprintf('Playing sound of the reconstructed signal - Press a key to move on\n');
recmE = conv(pmE,hmE);
sound(gainM*recmE(1:Fs*3),Fs)   % Play for 3 seconds
pause;

% Male I
[mI,mIwin,CrmI,CmI,CcentmI,hmI] = VowelAnalysis(filenameM,'I',41,10000,12000);
fprintf('Plots of male iii - Press a key to hear sound\n')
pause;
pmI = getOriginalPitch(malI,41);
% Original sound
fprintf('Playing sound of original signal - Press a key to move on\n');
sound(malI(1:Fs*3),Fs)          % Play for 3 seconds
pause;
close all;
% Synthesized sound
fprintf('Playing sound of the reconstructed signal - Press a key to move on\n');
recmI = conv(pmI,hmI);
sound(gainM*recmI(1:Fs*3),Fs)   % Play for 3 seconds
pause;

% Male O
[mO,mOwin,CrmO,CmO,CcentmO,hmO] = VowelAnalysis(filenameM,'O',65,10500,12500);
fprintf('Plots of male ooo - Press a key to hear sound\n')
pause;
pmO = getOriginalPitch(malO,65);
% Original sound
fprintf('Playing sound of original signal - Press a key to move on\n');
sound(malO(1:Fs*3),Fs)          % Play for 3 seconds
pause;
close all;
% Synthesized sound
fprintf('Playing sound of the reconstructed signal - Press a key to move on\n');
recmO = conv(pmO,hmO);
sound(4*recmO(1:Fs*3),Fs)       % Play for 3 seconds
pause;

% Male U
[mU,mUwin,CrmU,CmU,CcentmU,hmU] = VowelAnalysis(filenameM,'U',65,10000,12000);
fprintf('Plots of male uuu - Press a key to hear sound\n')
pause;
pmU = getOriginalPitch(malU,65);
% Original sound
fprintf('Playing sound of original signal - Press a key to move on\n');
sound(malU(1:Fs*3),Fs)          % Play for 3 seconds
pause;
close all;
% Synthesized sound
fprintf('Playing sound of the reconstructed signal - Press a key to move on\n');
recmU = conv(pmU,hmU);
sound(gainM*recmU(1:Fs*3),Fs)   % Play for 3 seconds
pause;

%% Plots of reconstructed signals

% Female 
vowelPlotsReconstructed(recfA,recfE,recfI,recfO,recfU,'Female',Fs)
% Male
vowelPlotsReconstructed(recmA,recmE,recmI,recmO,recmU,'Male',Fs)

% Female Samples - Plots
vowelPlotsF1Alligned(filenameF,' Female',Fs);
% Male Samples - Plots
vowelPlotsM1Alligned(filenameM,' Male', Fs);

warning('on')
% [C,q,t] = CepWin(filenameM,'A');