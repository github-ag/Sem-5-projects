clear;
clc;
Ebno = 12;
SNR = 10^(Ebno/10);
sgma = 1/sqrt(SNR);
inoise = randn(1,1000).*sgma;
upper = max(inoise);
lower = min(inoise);
plot(inoise);