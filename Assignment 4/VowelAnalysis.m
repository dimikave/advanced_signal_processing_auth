%% ADVANCED DIGITAL SIGNAL PROCESSING METHODS 
% Assignment 4 - Summer Semester 2020/2021
% Kavelidis Frantzis Dimitrios - AEM 9351 - kavelids@ece.auth.gr - ECE AUTH


function [x,xwin,Cr,C,Ccent,h] = VowelAnalysis(samp_folder, letter, cutCep, cut_down, cut_up)
    % Vowel Analysis: 
    %     Homomorphic filtering and plots. This function takes
    %     a folder name as well as the letter-vowel as inputs and given some
    %     parameters it takes a segment of the speech signal and makes an
    %     estimates the following
    % OUTPUTS:
    % 1) xwin            : The windowed signal 
    % 2) Cr              : The Real Cepstrum 
    % 3) C               : The Complex Cepstrum 
    % 4) Ccent           : The Mixed Phase Cepstrum 
    % 5) h               : The Impulse response of the system/mouth
    % 6) p               : The Pitch 
    
    % It also creates the plots for all the above.
    
    % INPUTS:
    % 1) samp_folder     : Folder with the speech samples   (string)
    % 2) letter          : Specification of vowel           (string)
    % 3) cutCep          : The lag/number of samples to cut cepstrum in
    %                      order to calculate h_hat
    % 4) cut_down        : lower bound/cut value to cut the original speech
    %                      sample and get the short segment of 2-5 periods.
    % 5) cut_up          : upper bound/cut value to cut the original speech
    %                      sample and get the short segment of 2-5 periods.
    
    %% Segment of speech signal  
    [x,fs] = audioread(strcat(samp_folder,letter,'.wav'),[cut_down cut_up]);
    x = x(:,1);                  % Convert to mono
%     sound(x,fs)                  % Play the sound of the short
%                                  % sample to know what to expect
    %% Segment / Wind.Seg / Spectrum / Real Cepstrum / Complex Cepstrum
    ms1=fs/1000;                 % Maximum speech Fx at 1000Hz
    ms20=fs/50;                  % Minimum speech Fx at 50Hz    (Male)
    ms10=fs/100;                 % Minimum Speech Fx at 100Hz   (Female)
    ms15 = floor(fs/67);

    if (length(x)<900)&& (length(x)>670)
        ms20 = ms15;
    elseif (length(x)<670)
        ms20 = ms10;
    end
    % Plot segment
    figure;
    suptitle(['Plots for ' letter]);
    j = 0:length(x)-1;
    t=(0:length(x)-1)/fs;        % times of sampling instants
    subplot(5,1,1);
%     plot(j,x);
    plot(t*1000,x);
    legend('Speech Segment');
    xlabel('Time (ms)');
    ylabel('Amplitude');

    % Windowing

%     xwin = x(1:1323);
%     win = window(@parzenwin,length(x));
%     xwin = xwin.*win;
%     xwin = x.*win;
%     xwin = x.*hann(length(x),'periodic');
    xwin = x.*hamming(length(x));
    
    % Plot of windowed signal
    subplot(5,1,2);
    plot(t*1000,xwin);
    legend('Windowed Speech Segment');
    xlabel('Time (ms)');
    ylabel('Amplitude');
    
    % Fourier Transform for Spectrum.
    Y=fft(xwin);

    % Real Cepstrum 
    % C=real(ifft(log(abs(Y)+eps)));
    Cr = rceps(xwin);
    
    % Complex Cepstrum
    % logY = log(abs(Y)) + sqrt(-1)*rcunwrap(angle(Y));
    % C=real(ifft(logY)+eps);
    [C,nd] = cceps(xwin);
    
    % Getting fundamental frequency
%     [c,fx]= max(abs(Cr(ms1:ms20)));
%     fprintf([letter ' - Fundamental frequency: Fx=%gHz\n'],fs/(ms1+fx-1));
%     fundF = fs/(ms1+fx-1);
%     fundT = 1/fundF;
    test = Cr(ms1:floor(ms20/2));
    [c,fx] = max(test);
    fundF = fs/(ms1+fx-1);
	fundT = 1/fundF;
    fprintf([letter ' - Fundamental frequency: Fx=%gHz\n'],fs/(ms1+fx-1));

    % plot spectrum of bottom 5000Hz
    hz5000=5000*length(Y)/fs;
    f=(0:hz5000)*fs/length(Y);
    
    % Plot of Spectrum
    subplot(5,1,3);
    plot(f,20*log10(abs(Y(1:length(f)))+eps));
    legend('Log Spectrum');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
    text(2500,-40,['Fundamental frequency at ' num2str(fundF) ' Hz'],'FontSize',8)

    % Plot of Real Cepstrum between 1ms (=1000Hz) and 20ms (=50Hz)
    q=(ms1:ms20)/fs;
    subplot(5,1,4);
    plot(q*1000,abs(Cr(ms1:ms20)));
    legend('Real Cepstrum');
    xlabel('Quefrency (ms)');
    ylabel('Amplitude');
    text(1000*fundT+1,0.03,['Rahmonic at ' num2str(1000*fundT) ' ms'],'FontSize',8)
    
    % Plot of Complex Cepstrum between 1ms (=1000Hz) and 20ms (=50Hz)
    subplot(5,1,5);
    plot(q*1000,C(ms1:ms20))
    legend('Complex Cepstrum');
    xlabel('Quefrency (ms)');
    ylabel('Amplitude');
    text(1000*fundT+1,0.1,['Rahmonic at ' num2str(1000*fundT) ' ms'],'FontSize',8)

    
    
    % Mixed phase Complex Cepstrum
    Ccent = fftshift(C);
    tcent = -floor(length(t)/2):floor(length(t)/2);
    
    figure
    plot(tcent*1000/fs,Ccent)
    ylim([-2 2])
    title(['Complex Cepstrum - ' letter ' - Mixed phase']);
    xlabel('Quefrency (ms)');
    ylabel('Amplitude');

    %% Inverse Cepstrum
    % Getting h^ part
    cch = zeros(length(x),1);
    cch(1:cutCep) = C(1:cutCep);
    cch(end:-1:end-cutCep-2) = C(end:-1:end-cutCep-2);
    figure;subplot(211);plot(t,cch);                % Ceps of pitch
    title('Cepstrum of impulse response')
    % Getting Pitch part
    ccp = C - cch;
    subplot(212);plot(t,ccp);                       % Ceps of h
    title('Cepstrum of pitch')
    
    p_hat = icceps(ccp,nd);
%     p_hat = fftshift(p_hat);
    figure;subplot(212);plot(t,p_hat);              % Pitch estimation plot
    title('Pitch Signal')
    logh = fft(cch);                                
    hspec = exp(real(logh)+1i*rcwrap(imag(logh),nd));
    h = icceps(cch,nd);
    h = fftshift(h);
    subplot(211);plot(t,h);                     % h estimation plot
    title('System/Impulse response Signal')
    
    xrec = conv(p_hat,h);
%     xr = repmat(xrec,50,1);
%     subplot(313);plot(xr)
%     sound(xr,fs);
    
    % Spectrum and estimation
    figure
    plot(f,20*log10(abs(Y(1:length(f)))+eps));
    hold on
    plot(f,20*log10(abs(hspec(1:length(f)))+eps));
    legend('Log Spectrum','h_h_a_t')
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
    title('Log Spectrum & Impulse response estimation in frequency domain')
    
    
    
    function x = rcwrap(y,nd)
    %RCWRAP Phase wrap utility used by ICCEPS.
    %   RCWRAP(X,nd) adds phase corresponding to integer lag.

    n = length(y);
    nh = fix((n+1)/2);
    x = y(:).' + pi*nd*(0:(n-1))/nh;
    if size(y,2)==1
        x = x.';
    end
    end
    
    
    
    function [y,nd] = rcunwrap(x)
    %RCUNWRAP Phase unwrap utility used by CCEPS.
    %   RCUNWRAP(X) unwraps the phase and removes phase corresponding
    %   to integer lag.  See also: UNWRAP, CCEPS.

    n = length(x);
    y = unwrap(x);
    nh = fix((n+1)/2);

    idx = nh+1; 
    % Special case the index for scalar input.
    if length(y) == 1
      idx = 1;
    end
    nd = round(y(idx)/pi);
    y(:) = y(:)' - pi*nd*(0:(n-1))/nh;
    % Cast to 'double' to enforce precision rules
    nd = double(nd); % output nd has no bearing on single precision rules
    end
    
end
