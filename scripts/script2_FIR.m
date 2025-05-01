[x, fs] = audioread('../audio-files/sample.wav');  % x = signal, fs = sampling rate

window = hamming(1024);       % Window size
noverlap = 512;               % Overlapping samples 
nfft = 2048;                  % FFT size (zero padding for better frequency resolution)

% Define cutoffs
f1 = 3300;   % Lower stopband edge (Hz) 3800 - 500
f2 = 5500;   % Upper stopband edge (Hz) 5000 + 500
Wn = [f1, f2] / (fs/2);  % Normalize to Nyquist frequency

% Design 256th-order FIR bandstop filter
order = 256;
b = fir1(order, Wn, 'stop');

% Apply the filter to the signal
x_filtered = filter(b, 1, x);  

figure;
spectrogram(x_filtered, window, noverlap, nfft, fs, 'yaxis');
title('Spectrogram of Filtered Audio (FIR Bandstop) f1 = 3800, f2 = 5000');
xlabel('Time (seconds)');
ylabel('Frequency (kHz)');
colorbar;

saveas(gcf, '../graphs/spectrogram_fir_filtered.svg');

audiowrite('../audio-files/fir_filtered.wav', x_filtered, fs);


