%% ADVANCED DIGITAL SIGNAL PROCESSING METHODS 
% Assignment 2 - Summer Semester 2020/2021
% Kavelidis Frantzis Dimitrios - AEM 9351 - kavelids@ece.auth.gr - ECE AUTH


hold on
fplot(XeqY,[-.5,.5],'LineStyle','--')
fplot(-XeqY,[-.5,.5],'LineStyle','--')
line([-.5,.5],[0,0],'Color','g','LineStyle','--')
line([0,0],[-.5,.5]','Color','c','LineStyle','--')
fplot((-1/2)*m,[-.5,.5],'LineStyle','--')
fplot(-2*m,[-.5,.5],'LineStyle','--')
ylim([-.5,.5])
legend("X(k)","f_2 = f_1", "f_2 = -f_1","f_2 = 0","f_1 = 0","f_2 = -(1/2)*f_1","f_2 = -2*f_1")
legend('boxoff')