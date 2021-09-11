%% ADVANCED DIGITAL SIGNAL PROCESSING METHODS 
% Assignment 4 - Summer Semester 2020/2021
% Kavelidis Frantzis Dimitrios - AEM 9351 - kavelids@ece.auth.gr - ECE AUTH

function vowelPlots(samp_fold,gender,Fs)
    % RC-505 has 5 different channels and when recording a single channel
    % it then makes the length equal for all the other channels as well
    % thus, singals have the same length
    A = audioread(strcat(samp_fold,'A','.wav'));
    A = A(10000:12000,1);
    dt = 1/Fs;
    t = 0:dt:(length(A)*dt)-dt;
    figure
    suptitle(strcat(gender,' Samples'))
    subplot(5,1,1)
    plot(t*1000,A)
    title(strcat('A - ',gender))
    xlabel('Time (ms)')
    ylabel('Amplitude')
    
    E = audioread(strcat(samp_fold,'E','.wav'));
    E = E(10000:12000,1);
    subplot(5,1,2)
    plot(t*1000,E)
    title(strcat('E - ',gender))
    xlabel('Time (ms)')
    ylabel('Amplitude')
    
    O = audioread(strcat(samp_fold,'O','.wav'));
    O = O(10000:12000,1);
    subplot(5,1,3)
    plot(t*1000,O)
    title(strcat('O - ',gender))
    xlabel('Time (ms)')
    ylabel('Amplitude')
    
    I = audioread(strcat(samp_fold,'I','.wav'));
    I = I(10000:12000,1);
    subplot(5,1,4)
    plot(t*1000,I)
    title(strcat('I - ',gender))
    xlabel('Time (ms)')
    ylabel('Amplitude')
    
    U = audioread(strcat(samp_fold,'U','.wav'));
    U = U(10000:12000,1);
    subplot(5,1,5)
    plot(t*1000,U)
    title(strcat('U - ',gender))
    xlabel('Time (ms)')
    ylabel('Amplitude')
end
