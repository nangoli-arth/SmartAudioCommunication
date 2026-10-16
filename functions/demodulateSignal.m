function rx_bits = demodulateSignal(rx_symbols, modulation, pcm_bits)
    % DEMODULATESIGNAL Demodulates BPSK or QPSK received symbols into bits.
    switch upper(modulation)
        case 'BPSK'
            rx_bits = double(real(rx_symbols) >= 0);

        case 'QPSK'
            recovered_I_bits = double(real(rx_symbols) < 0);
            recovered_Q_bits = double(imag(rx_symbols) < 0);

            rx_bits = zeros(size(pcm_bits));
            rx_bits(1:2:end) = recovered_I_bits;
            rx_bits(2:2:end) = recovered_Q_bits;

        otherwise
            error('Invalid modulation. Choose BPSK or QPSK.');
    end
    rx_bits = rx_bits(:);
end