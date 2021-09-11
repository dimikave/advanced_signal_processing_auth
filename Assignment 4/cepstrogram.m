%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Cepstrogram with MATLAB Implementation     %
%                                                %
% Author: Ph.D. Eng. Hristo Zhivomirov  08/25/16 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [C, q, t] = cepstrogram(x, win, hop, fs)
% function: [C, q, t] = cepstrogram(x, win, hop, fs)
% Input:
% x - signal in the time domain
% win - analysis window function
% hop - hop size
% fs - sampling frequency, Hz
%
% Output:
% C - real cepstrum-matrix (only unique points, 
%     time across columns, quefrency across rows)
% q - quefrency vector, s
% t - time vector, s
% representation of the signal as column-vector
x = x(:);
% determination of the signal length 
xlen = length(x);
% determination of the window length
wlen = length(win);
% stft matrix size estimation and preallocation
NUP = ceil((1+wlen)/2);     % calculate the number of unique fft points
L = 1+fix((xlen-wlen)/hop); % calculate the number of signal frames
C = zeros(NUP, L);          % preallocate the stft matrix
% STFT (via time-localized FFT)
for l = 0:L-1
    % windowing
    xw = x(1+l*hop : wlen+l*hop).*win;
    
    % cepstrum calculation
    c = real(ifft(log(abs(fft(xw)))));
    % update of the cepstrum-matrix
    C(:, 1+l) = c(1:NUP);
end
% calculation of the time and quefrency vectors
t = (wlen/2:hop:wlen/2+(L-1)*hop)/fs;
q = (0:NUP-1)/fs;
end