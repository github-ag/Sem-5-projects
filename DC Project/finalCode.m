clc;
clear;
clear all;
m = 3;
data_size = 1000;
[data, data_hamm] = encodeData(m, data_size);
%data = 2*data-1;
% data = 4*1000 matrix
% data_hamm = 7*1000 matrix

EbNo=1;
SNR = 10^(EbNo/10);
sgma = 1/sqrt(SNR);

%BPSk modulation
[bpsk_tx_data] = bpsk_mod(data_hamm);
bpsk_tx_data_noise = channel_awgn(bpsk_tx_data,sgma);
bpsk_demod_tx_data = bpsk_demod(bpsk_tx_data_noise);
bpsk_demod_tx_data = round(((bpsk_demod_tx_data)+1)/2);
%disp(bpsk_demod_tx_data);
bpsk_error = biterr(data_hamm,bpsk_demod_tx_data);
disp('bpsk error');
disp(bpsk_error);

bpsk_moddemode = bpsk_mod_demod(data_hamm,sgma);
bpsk_moddemode = round((bpsk_moddemode+1)/2);
temp_error = biterr(data_hamm,bpsk_moddemode);

%correcting the message signal
bpsk_corrected_data = correctData(m,bpsk_demod_tx_data);
final_bpsk_error = biterr(data_hamm,bpsk_corrected_data);
disp('error after correction');
disp(final_bpsk_error);

%decoding the message signal
decoded_data = decodeData(m,bpsk_corrected_data);
final_msg_error = biterr(decoded_data,data);

%ASK modulation
[ask_tx_data] = ask_mod(data_hamm);
ask_tx_data_noise = channel_awgn(ask_tx_data,sgma);
ask_demod_tx_data = ask_demod(ask_tx_data_noise);
ask_error = biterr(data_hamm,ask_demod_tx_data);
disp('working');
disp(data_hamm(1:10));
disp(ask_demod_tx_data(1:10));
disp(biterr(data_hamm(1:10),ask_demod_tx_data(1:10)));
ask_corrected_data = correctData(m,ask_demod_tx_data);
final_ask_error = biterr(data_hamm,ask_corrected_data);
disp('ask error');
disp(ask_error);
disp('error after correction');
disp(final_ask_error);

