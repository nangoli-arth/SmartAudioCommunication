function [rx_symbols, rx_waveform, noise_power] = applyAWGN(tx_symbols, SNR_dB, sps)
    % APPLYAWGN Adds Additive White Gaussian Noise to transmitted symbols.
    symbol_power = mean(abs(tx_symbols).^2);
    SNR_linear = 10^(SNR_dB/10);
    noise_power = symbol_power/SNR_linear;

    noise = sqrt(noise_power/2) .* ...
            (randn(size(tx_symbols)) + 1j*randn(size(tx_symbols)));
    rx_symbols = tx_symbols + noise;
    rx_waveform = repelem(rx_symbols, sps);
end