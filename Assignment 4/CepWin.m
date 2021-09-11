%% ADVANCED DIGITAL SIGNAL PROCESSING METHODS 
% Assignment 4 - Summer Semester 2020/2021
% Kavelidis Frantzis Dimitrios - AEM 9351 - kavelids@ece.auth.gr - ECE AUTH

function [C,q,t,Cr,qr,tr] = CepWin(samp_fold,letter)
    % Cepstrogram of the real and complex cepstrum
    [x,fs] = audioread([samp_fold letter '.wav']);
    win = hamming(length(x)/10);
    hop = length(win)/2;
    [C,q,t] = cepstrogram(x, win, hop, fs);

    figure
    subplot(2,1,1)
    stackedplot(C,2,1,4)
    xlabel('Segments')
    ylabel('Quefrency')
    zlabel('Gamnitude')
    title('Real Cepstrogram')
    zlim([-2 2])
    ylim([0 1000])
    
    [Cr,qr,tr] = Ccepstrogram(x, win, hop, fs);
    subplot(2,1,2)
    stackedplot(Cr,2,1,4)
    xlabel('Segments')
    ylabel('Quefrency')
    zlabel('Gamnitude')
    title('Compex Cepstrogram')
    zlim([-2 2])
    ylim([0 1000])
    
end
