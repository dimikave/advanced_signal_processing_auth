%% ADVANCED DIGITAL SIGNAL PROCESSING METHODS 
% Assignment 4 - Summer Semester 2020/2021
% Kavelidis Frantzis Dimitrios - AEM 9351 - kavelids@ece.auth.gr - ECE AUTH

function vowelPlotsReconstructed(A,E,I,O,U,gender,Fs)

    A = A(10000:12000,1);
    dt = 1/Fs;
    t = 0:dt:(length(A)*dt)-dt;
    figure
    suptitle(strcat('Reconstructed ',gender,' Samples'))
    subplot(5,1,1)
    plot(t,A)
    title(strcat('A - ',gender))
    xlabel('Time (ms)')
    ylabel('Amplitude')
    
    E = E(10000:12000,1);
    subplot(5,1,2)
    plot(t*1000,E)
    title(strcat('E - ',gender))
    xlabel('Time (ms)')
    ylabel('Amplitude')
    
    I = I(10000:12000,1);
    subplot(5,1,4)
    plot(t*1000,I)
    title(strcat('I - ',gender))
    xlabel('Time (ms)')
    ylabel('Amplitude')
    
    O = O(10000:12000,1);
    subplot(5,1,3)
    plot(t*1000,O)
    title(strcat('O - ',gender))
    xlabel('Time (ms)')
    ylabel('Amplitude')
    
    U = U(10000:12000,1);
    subplot(5,1,5)
    plot(t*1000,U)
    title(strcat('U - ',gender))
    xlabel('Time (ms)')
    ylabel('Amplitude')
end
