close all
clear all
clc

% Parameter
m = 3;
data_size = 1000;

% Simulation Parameters
%ml = 1;         % Modulation Level : BPSK
%M = 2^ml;
EbNo = 0:1:12;
u = length(EbNo);

for iii = 1:u           % ebn0 loop
    
    tic
    
    nloop = 2;       % # of simulation loop
    noe_bpsk = 0;       % # of awgn error
    noe_bpsk_hamm = 0;
    noe_ask = 0;
    noe_ask_hamm = 0;
    nod = 0;            % # of data
        
    SNR = 10^(EbNo(iii)/10);
    sgma = 1/sqrt(SNR);
    
    for ii = 1:5
        % Generate prbs data and encode the data using Hamming code
        % general algorithm
        [data, data_hamm] = encodeData(m, data_size);
        
        % BPSK MOD/DEMOD ( AWGN Channel )
        rdata_bpsk = bpsk_mod_demod(data, sgma);
        rdata_bpsk = round((rdata_bpsk+1)/2);
        rdata_bpsk_hamm = bpsk_mod_demod(data_hamm, sgma);
        rdata_bpsk_hamm = round((rdata_bpsk_hamm+1)/2);
        
        % ASK MOD/DEMOD ( AWGN Channel )
        rdata_ask = ask_mod_demod(data, EbNo(iii));
        rdata_ask_hamm = ask_mod_demod(data_hamm, EbNo(iii));
        
        % Hamming Code error correction and decode
        rdata_bpsk_hamm_deocded = cordecData(m, rdata_bpsk_hamm);
        rdata_ask_hamm_deocded = cordecData(m, rdata_ask_hamm);
        
        % Error calculation
        [err_bpsk(iii,ii), ber_bpsk] = biterr(rdata_bpsk, data);
        [err_bpsk_hamm(iii,ii), ber_bpsk_hamm] = biterr(rdata_bpsk_hamm_deocded, data);
        [err_ask(iii,ii), ber_ask] = biterr(rdata_ask, data);
        [err_ask_hamm(iii,ii), ber_ask_hamm] = biterr(rdata_ask_hamm_deocded, data);
        
        % Calculating BER
        noe_bpsk = noe_bpsk + err_bpsk(iii,ii);
        noe_bpsk_hamm = noe_bpsk_hamm + err_bpsk_hamm(iii,ii);
        noe_ask = noe_ask + err_ask(iii,ii);
        noe_ask_hamm = noe_ask_hamm + err_ask_hamm(iii,ii);
        nod = nod + length(data);
    end
    
    % Calculating probability of error
    pb_bpsk(iii) = noe_bpsk/nod;
    pb_bpsk_hamm(iii) = noe_bpsk_hamm/nod;
    pb_ask(iii) = noe_ask/nod;
    pb_ask_hamm(iii) = noe_ask_hamm/nod;
    %theory_bpsk(iii) = (1/2)*erfc(sqrt(SNR));
    %theory_ask(iii) = ((3/8)*erfc(sqrt((2/5)*SNR))-(9/64)*erfc(sqrt((2/5)*SNR)).^2);
    
    toc
    
end

% Plot graph

figure(1)
%EbNo, theory_bpsk,
%theory_ask, 'k-d', EbNo,
semilogy(EbNo, pb_bpsk, 'b-o', EbNo, pb_bpsk_hamm, 'r-o', EbNo,  pb_ask, 'b-d', EbNo, pb_ask_hamm,'r-d');
grid on
xlabel('Eb/N0, dB')
ylabel('Probability of error')
legend('BPSK BER')
title('Comparison of BER when using Hamming Code[15,11] in BPSK & ASK')
axis([0 12 0.000000001 1])
legend( 'BPSK Simulation', 'Hamming Code BPSK Simulation',  'ASK Simulation', 'Hamming Code ASK Simulation');