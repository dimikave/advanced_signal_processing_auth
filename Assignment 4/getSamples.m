%% ADVANCED DIGITAL SIGNAL PROCESSING METHODS 
% Assignment 4 - Summer Semester 2020/2021
% Kavelidis Frantzis Dimitrios - AEM 9351 - kavelids@ece.auth.gr - ECE AUTH

function [A,E,I,O,U] = getSamples(samp_fold)
    A = audioread(strcat(samp_fold,'A','.wav'));
    A = A(:,1);
    E = audioread(strcat(samp_fold,'E','.wav'));
    E = E(:,1);
    I = audioread(strcat(samp_fold,'I','.wav'));
    I = I(:,1);
    O = audioread(strcat(samp_fold,'O','.wav'));
    O = O(:,1);
    U = audioread(strcat(samp_fold,'U','.wav'));
    U = U(:,1);
end