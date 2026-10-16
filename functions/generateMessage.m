function [t, message] = generateMessage(Fs, fm, duration)
    % GENERATEMESSAGE Generates a sinusoidal message signal.
    t = 0:1/Fs:duration;
    message = sin(2*pi*fm*t);
end
