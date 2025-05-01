[x, fs] = audioread('../audio-files/sample.wav');  % x = signal, fs = sampling rate

window = hamming(1024);       % Window size = 1024
noverlap = 512;               % Overlapping samples 
nfft = 2048;                  % FFT size (zero padding for better frequency resolution)

figure;
spectrogram(x, window, noverlap, nfft, fs, 'yaxis');  % 'yaxis' sets y-axis as frequency
title('Spectrogram of Original Audio');
xlabel('Time (seconds)');
ylabel('Frequency (kHz)');
colorbar;

saveas(gcf, '../graphs/spectrogram_original.svg');
