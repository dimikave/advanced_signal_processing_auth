function plotstd(t,sig,sig_std)

% plotstd(t,sig,sig_std)  
% plots a function +/- std in gray
% sig=signal
% sig_std=function with the std of signal sig
% t=vector of the horizontal axis

% Mathworks, L.J. Hadjileontiadis, 1-04-99

x1=sig+sig_std;
x2=sig-sig_std;

h1=plot(t,x1); %plot of the signal with the standard deviation added
hold on;

x=get(h1,'xdata'); %obtain the Xdata and Ydata from the first plot
y=get(h1,'ydata');
l1=[x' y'];        %transpose and place in a matrix

h2=plot(t,x2);   %plot of the signal-the standard deviation

x=get(h2,'xdata');  %now for the second plot
y=get(h2,'ydata');
l2=[x' y'];         %transpose and place in a matrix

l3=[l1;flipud(l2)];  
patch(l3(:,1),l3(:,2),[.8 .8 .8]); %create the gray patch
plot(t,sig,'k');
hold off