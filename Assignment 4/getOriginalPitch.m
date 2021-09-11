%% ADVANCED DIGITAL SIGNAL PROCESSING METHODS 
% Assignment 4 - Summer Semester 2020/2021
% Kavelidis Frantzis Dimitrios - AEM 9351 - kavelids@ece.auth.gr - ECE AUTH

function pA = getOriginalPitch(A,cut)
    % Helper function, simple calculations to get pitch of the original
    % signal
    [CmA,nd] = cceps(A);
    CmAh = zeros(length(CmA),1);
    CmAh(1:cut) = CmA(1:cut);
    CmAh(end:-1:end-(cut-2)) = CmA(end:-1:end-(cut-2));
    CmAp = CmA-CmAh;
    pA = icceps(CmAp,nd);
%     pA = fftshift(pA);
end 