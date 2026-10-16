function [BER_sweep, MSE_sweep, capacity_sweep] = evaluatePerformance(tx_symbols, pcm_bits, message, modulation, n_bits, xmin, delta, Fs, SNR_range_dB)
    % EVALUATEPERFORMANCE Runs an SNR sweep to calculate BER, MSE, and Shannon capacity.
    num_SNR_points = length(SNR_range_dB);
    BER_sweep = zeros(1, num_SNR_points);
    MSE_sweep = zeros(1, num_SNR_points);
    capacity_sweep = zeros(1, num_SNR_points);

    symbol_power = mean(abs(tx_symbols).^2); %#ok<NASGU>
    channel_bandwidth = Fs * n_bits;

    for k = 1:num_SNR_points
        current_SNR_dB = SNR_range_dB(k);
        current_SNR_linear = 10^(current_SNR_dB/10);

        [current_rx_symbols, ~, ~] = applyAWGN(tx_symbols, current_SNR_dB, 1);
        current_rx_bits = demodulateSignal(current_rx_symbols, modulation, pcm_bits);

        BER_sweep(k) = sum(double(pcm_bits(:)) ~= current_rx_bits) / length(pcm_bits);

        [~, current_MSE] = decodeAndReconstruct(current_rx_bits, n_bits, xmin, delta, message);
        MSE_sweep(k) = current_MSE;

        capacity_sweep(k) = channel_bandwidth * log2(1 + current_SNR_linear);
    end
end