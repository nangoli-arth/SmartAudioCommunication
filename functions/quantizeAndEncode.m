function [quantized_message, quantization_MSE, pcm_bits, delta] = quantizeAndEncode(message, n_bits, xmin, xmax)
    % QUANTIZEANDENCODE Performs uniform quantization and PCM encoding.
    L = 2^n_bits;
    delta = (xmax - xmin)/(L-1);

    quantization_indices = round((message - xmin)/delta);
    quantization_indices = max(0, min(L-1, quantization_indices));

    quantized_message = xmin + quantization_indices*delta;
    quantization_error = message - quantized_message;
    quantization_MSE = mean(quantization_error.^2);

    binary_matrix = dec2bin(quantization_indices, n_bits) - '0';
    pcm_bits = reshape(binary_matrix.', [], 1);
end