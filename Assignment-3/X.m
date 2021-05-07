%% ADVANCED DIGITAL SIGNAL PROCESSING METHODS 
% Assignment 3 - Summer Semester 2020/2021
% Kavelidis Frantzis Dimitrios - AEM 9351 - kavelids@ece.auth.gr - ECE AUTH

N = 2048;                         % Data Length
v = exprnd(1,[1,N]);              % Exponential dist noise
vn =  v-mean(v);                  % Subtracting mean -> stationarity
x = zeros(N,1); 
b = [1,0.93,0.85,0.72,0.59,-0.1]; % MA parameters
x = conv(vn,b,'same')';           % MA timeseries
filename = 'X.mat';               % Save file
save ('X.mat');