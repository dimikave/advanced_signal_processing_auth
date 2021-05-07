%% ADVANCED DIGITAL SIGNAL PROCESSING METHODS 
% Assignment 3 - Summer Semester 2020/2021
% Kavelidis Frantzis Dimitrios - AEM 9351 - kavelids@ece.auth.gr - ECE AUTH

function plotDif(x,xest,q)
    figure()
    plot(x,'b')
    hold on
    plot(xest,'r')
    xlabel('Time [sec]')
    ylabel('Signal')
    legend('Original Signal','Estimated Signal')
    title(['Original and Estimated Signal using Giannakis formula for q = ',num2str(q)])
end