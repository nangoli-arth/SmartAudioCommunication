function [rx_message, reconstruction_MSE] = decodeAndReconstruct(rx_bits, n_bits, xmin, delta, message)
    % DECODEANDRECONSTRUCT Decodes PCM bits back into analog signal amplitudes.
    rx_binary_matrix = reshape(rx_bits, n_bits, []).';
    bit_weights = 2.^(n_bits-1:-1:0);
    rx_indices = rx_binary_matrix * bit_weights.';
    rx_message = xmin + rx_indices.'*delta;

    reconstruction_error = message - rx_message;
    reconstruction_MSE = mean(reconstruction_error.^2);
end