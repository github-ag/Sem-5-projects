function [ tx_data ] = ask_mod(msgSignal)
fs = 10;
fc = 1;
Am = 1;
Ac = 1;
msgSignal = Am*msgSignal;
t = 1:1/fs:length(msgSignal);
tm = 1:1:length(msgSignal);

%Carrier Signal
ct = Ac*cos(2*pi*fc*t);

tempmsg = zeros(1,length(t));

for i=1:length(msgSignal)-1
    for j=(i-1)*fs+1:(i-1)*fs+fs
        if msgSignal(i)>0
            tempmsg(j) = Am;
        else
            tempmsg(j)=0;
        end
    end
end

% Generating ASK signal
tx_data = tempmsg.*ct;

%p = plotting(t,tm,msgSignal,ct,tx_data);
end

function pt = plotting(t,tm,msgSignal,ct,tx_data)
pt=1;
%SLICING
t_s = t(1:100);
tm_s = tm(1:11);
msgSignal_s = msgSignal(1:11);
tx_data_s = tx_data(1:100);
ct_s = ct(1:100);

subplot(3,1,1);
stairs(tm_s,msgSignal_s);
title('Message Signal');
ylabel('magnitude');
xlabel('time');
ylim([-2 2]);

subplot(3,1,2);
plot(t_s,ct_s);
title('Carrier Signal');
ylabel('magnitude');
xlabel('time');

subplot(3,1,3);
plot(t_s,tx_data_s);
title('ASK trabsmitted Signal');
ylabel('magnitude');
xlabel('time');
ylim([-2 2]);
end



