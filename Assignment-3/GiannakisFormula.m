%% ADVANCED DIGITAL SIGNAL PROCESSING METHODS 
% Assignment 3 - Summer Semester 2020/2021
% Kavelidis Frantzis Dimitrios - AEM 9351 - kavelids@ece.auth.gr - ECE AUTH

function h = GiannakisFormula(q,c3)
    h = zeros(1,length(q)+1);
    for k = 0:q
        h(k+1) = c3(q+21,k+21)/c3(q+21,21);
    end
end