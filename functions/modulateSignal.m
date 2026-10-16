function [tx_symbols, tx_waveform, bits_per_symbol] = modulateSignal(pcm_bits, modulation, sps)
    % MODULATESIGNAL Performs BPSK or QPSK digital modulation.
    switch upper(modulation)
        case 'BPSK'
            tx_symbols = 2*double(pcm_bits) - 1;
            tx_waveform = repelem(tx_symbols, sps);
            bits_per_symbol = 1;

        case 'QPSK'
            if mod(length(pcm_bits), 2) ~= 0
                error('QPSK requires an even number of bits.');
            end
            bit_I = double(pcm_bits(1:2:end));
            bit_Q = double(pcm_bits(2:2:end));

            I = (1 - 2*bit_I)/sqrt(2);
            Q = (1 - 2*bit_Q)/sqrt(2);

            tx_symbols = I + 1j*Q;
            tx_waveform = repelem(tx_symbols, sps);
            bits_per_symbol = 2;

        otherwise
            error('Invalid modulation. Choose BPSK or QPSK.');
    end
end