%% SMART DIGITAL AUDIO COMMUNICATION SIMULATOR - MASTER SCRIPT
% Stage 1 to 6 using modular function calls

clc;
clear;
close all;

% Ensure the functions directory is on the MATLAB path
addpath('functions');

%% 1. Define signal parameters

Fs = 8000;          % Sampling frequency in Hz
fm = 300;           % Message frequency in Hz
duration = 0.05;    % Signal duration in seconds

%% 2. Generate the message signal (Using modular function)

[t, message] = generateMessage(Fs, fm, duration);

%% 3. Display signal information

fprintf('SMART AUDIO COMMUNICATION SIMULATOR\n');
fprintf('-----------------------------------\n');
fprintf('Sampling frequency: %d Hz\n', Fs);
fprintf('Message frequency: %d Hz\n', fm);
fprintf('Signal duration: %.3f seconds\n', duration);
fprintf('Number of samples: %d\n', length(message));

%% 4. Plot the original message signal

figure('Name', 'Stage 1 - Message Signal', ...
       'NumberTitle', 'off');

plot(t*1000, message, 'b-', 'LineWidth', 1.5);

grid on;
xlabel('Time (ms)');
ylabel('Amplitude');
title('Original 300 Hz Message Signal');

xlim([0 duration*1000]);
ylim([-1.2 1.2]);

%% 5. Display the individual samples

figure('Name', 'Sampled Message', ...
       'NumberTitle', 'off');

stem(t*1000, message, 'filled', ...
     'MarkerSize', 3);

grid on;
xlabel('Time (ms)');
ylabel('Amplitude');
title('Discrete Samples of the Message Signal');

xlim([0 10]);
ylim([-1.2 1.2]);


%% STAGE 2: SAMPLING, QUANTIZATION AND PCM ENCODING

fprintf('\nSTAGE 2: QUANTIZATION AND PCM ENCODING\n');
fprintf('--------------------------------------\n');

%% 2.1 Define the quantizer

n_bits = 8;                  % Number of bits per sample
L = 2^n_bits;                % Number of quantization levels

xmin = -1;                   % Minimum input amplitude
xmax = 1;                    % Maximum input amplitude

delta = (xmax - xmin)/(L-1); % Spacing between levels

%% 2.2 Quantize the sampled message & Encode (Using modular function)

[quantized_message, quantization_MSE, pcm_bits, delta] = ...
    quantizeAndEncode(message, n_bits, xmin, xmax);

% Retain local variables needed for Stage 2.5 display loop
quantization_indices = round((message - xmin)/delta);
quantization_indices = max(0, min(L-1, quantization_indices));
binary_matrix = dec2bin(quantization_indices, n_bits) - '0';

%% 2.3 Calculate quantization error

quantization_error = message - quantized_message;

fprintf('Quantization bits: %d\n', n_bits);
fprintf('Quantization levels: %d\n', L);
fprintf('Quantization step: %.6f\n', delta);
fprintf('Quantization MSE: %.8f\n', quantization_MSE);

%% 2.4 Convert quantization indices to binary PCM

fprintf('Number of message samples: %d\n', length(message));
fprintf('Bits per sample: %d\n', n_bits);
fprintf('Total PCM bits: %d\n', length(pcm_bits));

%% 2.5 Display the first 10 PCM words

fprintf('\nFirst 10 PCM words:\n');

for k = 1:min(10, size(binary_matrix, 1))
    fprintf('Sample %2d: %s\n', ...
        k, dec2bin(quantization_indices(k), n_bits));
end

%% 2.6 Plot sampled and quantized signals

figure('Name', 'Stage 2 - Quantization', ...
       'NumberTitle', 'off');

plot(t*1000, message, 'b-', 'LineWidth', 1.2);
hold on;

stairs(t*1000, quantized_message, ...
       'r-', 'LineWidth', 1.2);

stem(t*1000, message, 'k.', ...
     'MarkerSize', 5);

grid on;
xlabel('Time (ms)');
ylabel('Amplitude');
title('Original and Quantized Message Signals');

legend('Original message', ...
       'Quantized message', ...
       'Samples', ...
       'Location', 'best');

xlim([0 10]);
ylim([-1.2 1.2]);
hold off;

%% 2.7 Plot the quantization error

figure('Name', 'Stage 2 - Quantization Error', ...
       'NumberTitle', 'off');

stem(t*1000, quantization_error, ...
     'filled', 'MarkerSize', 3);

grid on;
xlabel('Time (ms)');
ylabel('Error amplitude');
title('Quantization Error');

xlim([0 10]);

%% 2.8 Display the first 64 PCM bits

figure('Name', 'Stage 2 - PCM Bit Stream', ...
       'NumberTitle', 'off');

stairs(0:63, pcm_bits(1:64), ...
       'LineWidth', 1.5);

grid on;
xlabel('Bit index');
ylabel('Bit value');
title('First 64 Bits of the PCM Stream');

ylim([-0.2 1.2]);
yticks([0 1]);
xlim([0 63]);


%% STAGE 3: NRZ LINE CODING AND DIGITAL MODULATION

fprintf('\nSTAGE 3: LINE CODING AND DIGITAL MODULATION\n');
fprintf('-------------------------------------------\n');

%% 3.1 Select the digital modulation scheme

modulation = 'BPSK'; % Change this value to 'BPSK' or 'QPSK'
sps = 8;             % Number of simulation samples per symbol

fprintf('Selected modulation: %s\n', modulation);
fprintf('Samples per symbol: %d\n', sps);


%% 3.2 NRZ line coding

nrz_signal = 2*double(pcm_bits) - 1;

fprintf('Number of NRZ levels: %d\n', length(nrz_signal));

num_display_bits = 32;

figure('Name', 'Stage 3 - NRZ Line Coding', ...
       'NumberTitle', 'off');

subplot(2,1,1);
stairs(0:num_display_bits-1, ...
       double(pcm_bits(1:num_display_bits)), ...
       'LineWidth', 1.5);
grid on;
xlabel('Bit index');
ylabel('Bit value');
title('Original PCM Bits');
ylim([-0.2 1.2]);
yticks([0 1]);

subplot(2,1,2);
stairs(0:num_display_bits-1, ...
       nrz_signal(1:num_display_bits), ...
       'LineWidth', 1.5);
grid on;
xlabel('Bit index');
ylabel('Voltage level (normalized)');
title('Polar NRZ Line-Coded Signal');
ylim([-1.3 1.3]);
yticks([-1 1]);


%% 3.3 Digital modulation (Using modular function)

[tx_symbols, tx_waveform, bits_per_symbol] = modulateSignal(pcm_bits, modulation, sps);

fprintf('Bits per symbol: %d\n', bits_per_symbol);
fprintf('Number of modulation symbols: %d\n', length(tx_symbols));
fprintf('Number of waveform samples: %d\n', length(tx_waveform));

%% 3.4 Plot the modulated baseband waveform

num_symbols_display = min(20, length(tx_symbols));
num_waveform_display = num_symbols_display*sps;
sample_index = 0:num_waveform_display-1;

figure('Name', 'Stage 3 - Modulated Waveform', ...
       'NumberTitle', 'off');

subplot(2,1,1);
plot(sample_index, real(tx_waveform(1:num_waveform_display)), ...
     'b-', 'LineWidth', 1.3);
grid on;
xlabel('Simulation sample index');
ylabel('In-phase amplitude');
title([upper(modulation), ' In-Phase Baseband Signal']);

subplot(2,1,2);
plot(sample_index, imag(tx_waveform(1:num_waveform_display)), ...
     'r-', 'LineWidth', 1.3);
grid on;
xlabel('Simulation sample index');
ylabel('Quadrature amplitude');
title('Quadrature Baseband Signal');

%% 3.5 Plot the modulation constellation

figure('Name', 'Stage 3 - Constellation Diagram', ...
       'NumberTitle', 'off');

plot(real(tx_symbols), imag(tx_symbols), ...
     'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 5);

grid on;
axis equal;
xlabel('In-phase component (I)');
ylabel('Quadrature component (Q)');
title([upper(modulation), ' Constellation Diagram']);

hold on;
xline(0, 'k:');
yline(0, 'k:');
hold off;


%% STAGE 4: AWGN CHANNEL, DEMODULATION AND RECONSTRUCTION

fprintf('\nSTAGE 4: AWGN CHANNEL AND SIGNAL RECONSTRUCTION\n');
fprintf('----------------------------------------------\n');

%% 4.1 Additive White Gaussian Noise (AWGN) channel (Using modular function)

SNR_dB = 10;
[rx_symbols, rx_waveform, noise_power] = applyAWGN(tx_symbols, SNR_dB, sps);

symbol_power = mean(abs(tx_symbols).^2);

fprintf('Selected modulation: %s\n', upper(modulation));
fprintf('Channel SNR: %.2f dB\n', SNR_dB);
fprintf('Average symbol power: %.4f\n', symbol_power);
fprintf('Noise power: %.6f\n', noise_power);

%% 4.2 Plot the received waveform

num_symbols_display = min(20, length(rx_symbols));
num_waveform_display = num_symbols_display*sps;
sample_index = 0:num_waveform_display-1;

figure('Name', 'Stage 4 - Received Waveform', ...
       'NumberTitle', 'off');

subplot(2,1,1);
plot(sample_index, real(rx_waveform(1:num_waveform_display)), 'b-', 'LineWidth', 1.2);
grid on;
xlabel('Simulation sample index');
ylabel('In-phase amplitude');
title('Received In-Phase Signal');

subplot(2,1,2);
plot(sample_index, imag(rx_waveform(1:num_waveform_display)), 'r-', 'LineWidth', 1.2);
grid on;
xlabel('Simulation sample index');
ylabel('Quadrature amplitude');
title('Received Quadrature Signal');

%% 4.3 Plot the received constellation

figure('Name', 'Stage 4 - Received Constellation', ...
       'NumberTitle', 'off');

plot(real(rx_symbols), imag(rx_symbols), 'b.', 'MarkerSize', 10);
hold on;
plot(real(tx_symbols(1:min(500,length(tx_symbols)))), ...
     imag(tx_symbols(1:min(500,length(tx_symbols)))), ...
     'ro', 'MarkerSize', 5, 'LineWidth', 1);

grid on;
axis equal;
xlabel('In-phase component (I)');
ylabel('Quadrature component (Q)');
title([upper(modulation), ' Constellation After AWGN']);
legend('Received symbols', 'Transmitted reference symbols', 'Location', 'best');
xline(0, 'k:');
yline(0, 'k:');
hold off;

%% 4.4 Demodulate the received symbols (Using modular function)

rx_bits = demodulateSignal(rx_symbols, modulation, pcm_bits);

fprintf('\nDEMODULATION RESULTS\n');
fprintf('--------------------\n');
fprintf('Transmitted bits: %d\n', length(pcm_bits));
fprintf('Received bits: %d\n', length(rx_bits));

%% 4.5 Calculate the bit error rate (BER)

bit_errors = sum(double(pcm_bits(:)) ~= rx_bits);
BER = bit_errors/length(pcm_bits);

fprintf('Number of bit errors: %d\n', bit_errors);
fprintf('Bit Error Rate (BER): %.8f\n', BER);

num_bits_display = min(64, length(pcm_bits));

figure('Name', 'Stage 4 - Bit Recovery', ...
       'NumberTitle', 'off');

subplot(2,1,1);
stairs(0:num_bits_display-1, double(pcm_bits(1:num_bits_display)), 'b-', 'LineWidth', 1.3);
grid on; xlabel('Bit index'); ylabel('Bit value'); title('Transmitted PCM Bits');
ylim([-0.2 1.2]); yticks([0 1]);

subplot(2,1,2);
stairs(0:num_bits_display-1, rx_bits(1:num_bits_display), 'r-', 'LineWidth', 1.3);
grid on; xlabel('Bit index'); ylabel('Bit value'); title('Demodulated PCM Bits');
ylim([-0.2 1.2]); yticks([0 1]);

%% 4.6 Decode the received PCM bitstream & Reconstruct (Using modular function)

[rx_message, reconstruction_MSE] = decodeAndReconstruct(rx_bits, n_bits, xmin, delta, message);

fprintf('\nPCM DECODING RESULTS\n');
fprintf('--------------------\n');
fprintf('Reconstructed samples: %d\n', length(rx_message));

%% 4.7 Calculate reconstruction error and MSE

reconstruction_error = message - rx_message;

fprintf('Reconstruction MSE: %.8f\n', reconstruction_MSE);
fprintf('Quantization-only MSE: %.8f\n', quantization_MSE);

%% 4.8 Plot the original and reconstructed signals

figure('Name', 'Stage 4 - Signal Reconstruction', ...
       'NumberTitle', 'off');

plot(t*1000, message, 'b-', 'LineWidth', 1.5);
hold on;
stairs(t*1000, rx_message, 'r-', 'LineWidth', 1.2);
grid on;
xlabel('Time (ms)');
ylabel('Amplitude');
title(['Original vs Reconstructed Signal - ', upper(modulation), ', SNR = ', num2str(SNR_dB), ' dB']);
legend('Original message', 'Reconstructed message', 'Location', 'best');
xlim([0 10]); ylim([-1.2 1.2]);
hold off;

%% 4.9 Plot the reconstruction error

figure('Name', 'Stage 4 - Reconstruction Error', ...
       'NumberTitle', 'off');

plot(t*1000, reconstruction_error, 'k-', 'LineWidth', 1.2);
grid on;
xlabel('Time (ms)');
ylabel('Error amplitude');
title(['Reconstruction Error - MSE = ', num2str(reconstruction_MSE, '%.6f')]);
xlim([0 10]);

fprintf('\nSTAGE 4 COMPLETED\n');
fprintf('-----------------\n');
fprintf('Modulation: %s\n', upper(modulation));
fprintf('SNR: %.2f dB\n', SNR_dB);
fprintf('BER: %.8f\n', BER);
fprintf('Reconstruction MSE: %.8f\n', reconstruction_MSE);


%% STAGE 5: PERFORMANCE ANALYSIS AND SHANNON CAPACITY

fprintf('\nSTAGE 5: PERFORMANCE ANALYSIS\n');
fprintf('----------------------------\n');

SNR_range_dB = 0:2:20;

% Run performance analysis sweep using modular function
[BER_sweep, MSE_sweep, capacity_sweep] = evaluatePerformance(...
    tx_symbols, pcm_bits, message, modulation, n_bits, xmin, delta, Fs, SNR_range_dB);

num_SNR_points = length(SNR_range_dB);

%% 5.3 Display the results

fprintf('\nSNR SWEEP RESULTS\n');
fprintf('-----------------\n');
fprintf('%8s %14s %18s %20s\n', ...
    'SNR (dB)', 'BER', 'MSE', 'Capacity (kbps)');

for k = 1:num_SNR_points
    fprintf('%8.1f %14.8f %18.8f %20.2f\n', ...
        SNR_range_dB(k), BER_sweep(k), MSE_sweep(k), capacity_sweep(k)/1000);
end

%% 5.4 Plot BER versus SNR

figure('Name', 'Stage 5 - BER vs SNR', 'NumberTitle', 'off');
BER_display = max(BER_sweep, 1/(2*length(pcm_bits)));
semilogy(SNR_range_dB, BER_display, 'bo-', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
grid on; xlabel('SNR (dB)'); ylabel('Bit Error Rate (BER)');
title(['BER vs SNR - ', upper(modulation)]);
xlim([min(SNR_range_dB), max(SNR_range_dB)]);

%% 5.5 Plot reconstruction MSE versus SNR

figure('Name', 'Stage 5 - MSE vs SNR', 'NumberTitle', 'off');
plot(SNR_range_dB, MSE_sweep, 'rs-', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
hold on;
yline(quantization_MSE, 'k--', 'Quantization-only MSE', 'LineWidth', 1.3);
grid on; xlabel('SNR (dB)'); ylabel('Mean Squared Error (MSE)');
title(['Reconstruction MSE vs SNR - ', upper(modulation)]);
legend('Measured reconstruction MSE', 'Quantization-only MSE', 'Location', 'best');
xlim([min(SNR_range_dB), max(SNR_range_dB)]);
hold off;

%% 5.6 Plot Shannon channel capacity versus SNR

figure('Name', 'Stage 5 - Shannon Capacity', 'NumberTitle', 'off');
plot(SNR_range_dB, capacity_sweep/1000, 'md-', 'LineWidth', 1.5, 'MarkerFaceColor', 'm');
hold on;
pcm_bit_rate = Fs*n_bits;
yline(pcm_bit_rate/1000, 'k--', 'PCM bit rate = 64 kbps', 'LineWidth', 1.3);
grid on; xlabel('SNR (dB)'); ylabel('Theoretical Capacity (kbps)');
title('Shannon Channel Capacity vs SNR');
legend('Shannon capacity', 'PCM bit rate', 'Location', 'best');
xlim([min(SNR_range_dB), max(SNR_range_dB)]);
hold off;

%% 5.7 Summarize the analysis

channel_bandwidth = Fs*n_bits;
fprintf('\nSTAGE 5 SUMMARY\n');
fprintf('---------------\n');
fprintf('Selected modulation: %s\n', upper(modulation));
fprintf('SNR range: %.1f to %.1f dB\n', min(SNR_range_dB), max(SNR_range_dB));
fprintf('Assumed channel bandwidth: %.1f kHz\n', channel_bandwidth/1000);
fprintf('PCM source bit rate: %.1f kbps\n', pcm_bit_rate/1000);
fprintf('Capacity at minimum SNR: %.2f kbps\n', capacity_sweep(1)/1000);
fprintf('Capacity at maximum SNR: %.2f kbps\n', capacity_sweep(end)/1000);

fprintf('\nSTAGE 5 COMPLETED\n');
fprintf('-----------------\n');


%% STAGE 6: PROJECT FOLDER SETUP AND FIGURE EXPORT

fprintf('\nSTAGE 6: PROJECT ORGANIZATION\n');
fprintf('----------------------------\n');

projectFolder = fileparts(mfilename('fullpath'));
functionsFolder = fullfile(projectFolder, 'functions');
figuresFolder = fullfile(projectFolder, 'figures');
resultsFolder = fullfile(projectFolder, 'results');
reportFolder = fullfile(projectFolder, 'report');
presentationFolder = fullfile(projectFolder, 'presentation');

if ~exist(functionsFolder, 'dir'), mkdir(functionsFolder); end
if ~exist(figuresFolder, 'dir'), mkdir(figuresFolder); end
if ~exist(resultsFolder, 'dir'), mkdir(resultsFolder); end
if ~exist(reportFolder, 'dir'), mkdir(reportFolder); end
if ~exist(presentationFolder, 'dir'), mkdir(presentationFolder); end

fprintf('Project folders checked and created.\n');

%% Export all open figures as PNG and MATLAB FIG files

allFigures = findall(0, 'Type', 'figure');
allFigures = flipud(allFigures);

for k = 1:length(allFigures)
    fig = allFigures(k);
    figName = get(fig, 'Name');
    if isempty(figName)
        figName = sprintf('Figure_%02d', k);
    end

    safeName = regexprep(figName, '[^a-zA-Z0-9_-]', '_');

    pngFile = fullfile(figuresFolder, [safeName, '.png']);
    exportgraphics(fig, pngFile, 'Resolution', 200);

    figFile = fullfile(figuresFolder, [safeName, '.fig']);
    savefig(fig, figFile);

    fprintf('Saved figure: %s\n', safeName);
end

fprintf('\nSTAGE 6 COMPLETED\n');
fprintf('Figures saved in: %s\n', figuresFolder);