%% ADVANCED DIGITAL SIGNAL PROCESSING METHODS 
% Assignment 3 - Summer Semester 2020/2021
% Kavelidis Frantzis Dimitrios - AEM 9351 - kavelids@ece.auth.gr - ECE AUTH

function nrmse = nrmse(x,xest)
    rmse = sqrt(immse(x,xest));
    nrmse = rmse/range(x);
end