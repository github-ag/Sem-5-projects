function [dem_output] = ask_demod(askkNoise)
fs = 10;
n_bits = round(length(askkNoise)/fs+1);

fc = 1;
Am = 1;
Ac=1;
t = 1:1/fs:n_bits;
tm = 1:1:n_bits;

ct = Ac*cos(2*pi*fc*t);

% Doing synchronous demodulation
temp = askkNoise.*ct;

% Integration and Decision Making
dem_output = zeros(1,length(tm));
int_output = zeros(1,length(tm));
for i=1:n_bits-1
    for j=(i-1)*fs+1:(i-1)*fs+fs
        int_output(i) = int_output(i)+(temp(j));
    end
    if (int_output(i))>Am/2
        dem_output(i) = 1;
    else
        dem_output(i) = 0;
    end
end
%p = plotting(t,tm,temp,dem_output,askkNoise);
end

function pt = plotting(t,tm,temp,dem_output,askNoise)
pt = 1;
%SLICING
t_s = t(1:100);
tm_s = tm(1:11);
temp_s = temp(1:100);
dem_output_s = dem_output(1:11);
askNoise_s = askNoise(1:100);

subplot(3,1,1);
plot(t_s,askNoise_s);
title('Received Signal');
ylabel('magnitude');
xlabel('time');

subplot(3,1,2);
plot(t_s,temp_s);
title('Received Signal * Carrier Signal');
ylabel('magnitude');
xlabel('time');

subplot(3,1,3);
stairs(tm_s,dem_output_s);
title('Demodulated Signal');
ylabel('magnitude');
xlabel('time');
ylim([-2 2]);


end