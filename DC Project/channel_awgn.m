function [awgn_data] = channel_awgn(tx_data,sgma)

t = 1:1/10:length(tx_data);
inoise = randn(1,length(tx_data)).*sgma;
%qnoise = 1j.*randn(1,length(tx_data)).*sgma;
awgn_data = tx_data + inoise; %+ qnoise;

%p = plotting(t,tx_data,awgn_data,inoise);
end

function pt = plotting(t,tx_data,awgn_data,inoise)
pt=1;
%SAMPLING
t_s = t(1:100);
tx_data_s = tx_data(1:100);
awgn_data_s = awgn_data(1:100);
inoise_s = inoise(1:100);

subplot(3,1,1);
plot(t_s,tx_data_s);
title('transmitted Signal');
ylabel('magnitude');
xlabel('time');
ylim([-5 5]);

subplot(3,1,2);
plot(t_s,inoise_s);
title('noise Signal');
ylabel('magnitude');
xlabel('time');
%ylim([-5 5]);


subplot(3,1,3);
plot(t_s,awgn_data_s);
title('signal with noise');
ylabel('magnitude');
xlabel('time');
ylim([-5 5]);
end

