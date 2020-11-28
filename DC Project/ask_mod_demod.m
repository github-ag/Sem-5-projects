function [demodata] = ask_mod_demod(data, sgma)

% BPSK Modulation
[tx_data] = ask_mod(data);

% AWGN channel
[awgn_data] = channel_awgn(tx_data, sgma);

% BPSK Demodulation
[demodata] = ask_demod(awgn_data);