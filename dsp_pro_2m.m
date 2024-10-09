clc; close all; clear;

filter_order = 21;  
cutoff_freq = 0.4;   
num_bits = 8;       

b = fir1(filter_order, cutoff_freq);

[H_orig, W_orig] = freqz(b, 1, 1024);

disp('Original filter coefficients:');
disp(b);
quantized_b = round(b * 2^(num_bits-1)) / 2^(num_bits-1);

[H_quant, W_quant] = freqz(quantized_b, 1, 1024);

disp('Quantized filter coefficients:');
disp(quantized_b);

figure;
plot(W_orig/pi, 20*log10(abs(H_orig)), 'b', 'LineWidth', 1.5); hold on;
plot(W_quant/pi, 20*log10(abs(H_quant)), 'r--', 'LineWidth', 1.5);
title('Frequency Response of FIR Filter');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Magnitude (dB)');
legend('Original', 'Quantized');
grid on;
quant_error = b - quantized_b;
disp('Quantization error in coefficients:');
disp(quant_error);
figure;
stem(0:filter_order, quant_error, 'filled');
title('Quantization Error in FIR Filter Coefficients');
xlabel('Coefficient Index');
ylabel('Error');
grid on;

fs = 1000;                
t = 0:1/fs:0.25-1/fs;       
input_signal = sin(2*pi*50*t) + 0.5*sin(2*pi*120*t);

output_orig = filtfilt(b, 1, input_signal);

output_quant = filtfilt(quantized_b, 1, input_signal);

figure;
subplot(4,1,1);
plot(t, input_signal);
title('Input Signal');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(4,1,2);
plot(t, output_orig);
title('Output Signal (Original Filter)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(4,1,3);
plot(t, output_quant);
title('Output Signal (Quantized Filter)');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(4,1,4);
plot(t, abs(output_orig-output_quant));
title('Difference');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;