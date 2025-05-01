[x, fs] = audioread('../audio-files/sample.wav');  % x = signal, fs = sampling rate
Wn = [3300, 5500] / (fs/2);

R = 0.1;    % R value for filters

n_butter = 7;       % From the value 7 to 12, the noise cannot be heard. After 13, audio gets corrupted.
n_cheby = 6;        % From the value 6 to 11, the noise cannot be heard. After 12, audio gets corrupted.
n_ellip = 8;        % From the value 8 to 9, the noise cannot be heard. After 10, audio gets corrupted

order = 256;        % Requested order for FIR filter.
b = fir1(order, Wn, 'stop');
x_filtered = filter(b, 1, x);

% Apply Butterworth filter
[bb, ab] = butter(n_butter, Wn, 'stop');
x_butter = filter(bb, ab, x);
audiowrite('../audio-files/iirbutterworth_filtered.wav', x_butter, fs);

x_butter(~isfinite(x_butter)) = 0;      % In order to demonstrate when the n value causes corruption on audio.


% Apply Chebyshev Type 1 filter
[bc, ac] = cheby1(n_cheby, R, Wn, 'stop');
x_cheby = filter(bc, ac, x);
audiowrite('../audio-files/iircheby_filtered.wav', x_cheby, fs);

x_cheby(~isfinite(x_cheby)) = 0;      % In order to demonstrate when the n value causes corruption on audio.

% Apply Elliptic filter
[be, ae] = ellip(n_ellip, R, Rs, Wn, 'stop');
x_ellip = filtfilt(be, ae, x); 
audiowrite('../audio-files/iirelliptic_filtered.wav', x_ellip, fs);

x_ellip(~isfinite(x_ellip)) = 0;      % In order to demonstrate when the n value causes corruption on audio.

% Common parameters for spectrogram demonstration
window = hamming(1024);
noverlap = 512;
nfft = 2048;

figure;
spectrogram(x_butter, window, noverlap, nfft, fs, 'yaxis');
title(sprintf('Spectrogram of Butterworth Filtered Audio (n = %d)', n_butter));
xlabel('Time (seconds)');
ylabel('Frequency (kHz)');
colorbar;

saveas(gcf, sprintf('../graphs/spectrogram_iirbutter_filtered_%d.svg', n_butter));

figure;
spectrogram(x_cheby, window, noverlap, nfft, fs, 'yaxis');
title(sprintf('Spectrogram of Chebyshev Filtered Audio (n = %d)', n_cheby));
xlabel('Time (seconds)');
ylabel('Frequency (kHz)');
colorbar;

saveas(gcf, sprintf('../graphs/spectrogram_iirchebyshev_filtered_%d.svg', n_cheby));

figure;
spectrogram(x_ellip, window, noverlap, nfft, fs, 'yaxis');
title(sprintf('Spectrogram of Elliptic Filtered Audio (n = %d)', n_ellip));
xlabel('Time (seconds)');
ylabel('Frequency (kHz)');
colorbar;

saveas(gcf, sprintf('../graphs/spectrogram_iirelliptic_filtered_%d.svg', n_ellip));

[Hfir, f] = freqz(b, 1, 2048, fs);      % FIR
[Hb, ~]   = freqz(bb, ab, 2048, fs);    % Butterworth
[Hc, ~]   = freqz(bc, ac, 2048, fs);    % Chebyshev
[He, ~]   = freqz(be, ae, 2048, fs);    % Elliptic

figure;
plot(f, 20*log10(abs(Hfir)), 'b'); hold on;
plot(f, 20*log10(abs(Hb)), 'r');
plot(f, 20*log10(abs(Hc)), 'g');
plot(f, 20*log10(abs(He)), 'm');
xlim([1000 8000]);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
ttl = title('Magnitude of Frequency Response (log scale)');
set(ttl, 'FontSize', 18);
leg = legend('FIR', sprintf('Butterworth (n = %d)', n_butter), sprintf('Chebyshev (n = %d)', n_cheby), sprintf('Elliptic (n = %d)', n_ellip));
set(leg, 'FontSize', 18);
grid on;

figure;
subplot(1,3,1);
zplane(bb, ab); 
ttl = title('Butterworth');
set(ttl, 'FontSize', 18);

subplot(1,3,2);
zplane(bc, ac); 
ttl = title('Chebyshev');
set(ttl, 'FontSize', 18);

subplot(1,3,3);
zplane(be, ae); 
ttl = title('Elliptic');
set(ttl, 'FontSize', 18);
