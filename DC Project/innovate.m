close all;
clear all;
clc;

% Parameter
m = 3;
data_size = 1000;

% Simulation Parameters
%ml = 1;         % Modulation Level : BPSK
%M = 2^ml;
EbNo = -10:1:10;
u = length(EbNo);
pb_bpsk = zeros(1,u);
pb_ask = zeros(1,u);

bpsk_error = zeros(1,u);
ask_error = zeros(1,u);
for i = 1:u
    SNR = 10^(EbNo(i)/10);
    SNR_ask = 10^(EbNo(i));
    SNR = 1/sgma^2;
    sgma = 1/sqrt(SNR); % sgma = noise variance
    sgma_ask = 1/sqrt(SNR_ask);
    nod = 0;
    
    %bpsk_error_after_correction = 0;
    bpsk_data_error = 0;
    ask_data_error = 0;
    final_bpsk_msg_error = 0;
    %ask_error_after_correction = 0;
    final_ask_msg_error = 0;
    
   for j = 1:20
        [data, data_hamm] = encodeData(m, data_size);
        
        bpsk_data_moddemode = bpsk_mod_demod(data,sgma);
        bpsk_data_moddemode = round((bpsk_data_moddemode+1)/2);
        bpsk_data_error = bpsk_data_error+biterr(data,bpsk_data_moddemode);
        
        ask_data_moddemode = ask_mod_demod(data,sgma);
        ask_data_error = ask_data_error+biterr(data,ask_data_moddemode);

        %%%%%%%%%%%%%%%%%% BPSK MODULATION   %%%%%%%%%%%%%%%%%%%%%%
        bpsk_moddemode = bpsk_mod_demod(data_hamm,sgma);
        bpsk_moddemode = round((bpsk_moddemode+1)/2);
        %bpsk_error(i) = bpsk_error(i) + biterr(data_hamm,bpsk_moddemode);
        %disp(bpsk_error);
        
        %Correcting and decoding 
        %correcting the message signal
        bpsk_corrected_data = correctData(m,bpsk_moddemode);
        %bpsk_error_after_correction = bpsk_error_after_correction + biterr(data_hamm,bpsk_corrected_data);

        %decoding the message signal
        decoded_data = decodeData(m,bpsk_corrected_data);
        final_bpsk_msg_error = final_bpsk_msg_error + biterr(decoded_data,data);
        
        %%%%%%%%%%%%%%%%%%% ASK MODULATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ask_moddemode = ask_mod_demod(data_hamm,sgma);
        %ask_error(i) = ask_error(i) + biterr(data_hamm,ask_moddemode);
        
        ask_corrected_data = correctData(m,ask_moddemode);
        %ask_error_after_correction = ask_error_after_correction + biterr(data_hamm,ask_corrected_data);

        %decoding the message signal
        decoded_data = decodeData(m,ask_corrected_data);
        final_ask_msg_error = final_ask_msg_error + biterr(decoded_data,data);
        
        
        nod = nod+length(data_hamm);
        
   end
   bpsk_error_wo_hamming(i) = bpsk_data_error;
   ask_error_wo_hamming(i) = ask_data_error;
   %bpsk_errors_after_correction(i) = bpsk_error_after_correction;
   final_bpsk_msg_errors(i) = final_bpsk_msg_error;
   %ask_errors_after_correction(i) = ask_error_after_correction;
   final_ask_msg_errors(i) = final_ask_msg_error;
   
   pb_bpsk(i) = bpsk_error_wo_hamming(i)/nod;
   pb_bpsk_hamm(i) = final_bpsk_msg_errors(i)/nod;
   pb_ask(i) = ask_error_wo_hamming(i)/nod;
   pb_ask_hamm(i) = final_ask_msg_errors(i)/nod;
   theory_bpsk(i) = (1/2)*erfc(sqrt(SNR));
   %theory_ask(i) = ((3/8)*erfc(sqrt((2/5)*SNR))-(9/64)*erfc(sqrt((2/5)*SNR)).^2);
   theory_ask(i) = (0.5)*erfc(0.5*(sqrt(SNR)));
   
end

disp(bpsk_error_wo_hamming);
disp(ask_error_wo_hamming);

subplot(6,1,1);
plot(EbNo,pb_ask);
title('ASK simulation without hamming code');
xlabel('EbNo');

subplot(6,1,2);
plot(EbNo,pb_ask_hamm);
title('ASK Simulation with hamming code')
xlabel('EbNo');

subplot(6,1,3);
plot(EbNo,pb_bpsk);
title('BPSK Simulation without hamming code');
xlabel('EbNo');

subplot(6,1,4);
plot(EbNo,pb_bpsk_hamm);
title('BPSK Simulation with hamming code');
xlabel('EbNo');

subplot(6,1,5);
plot(EbNo,theory_bpsk);
title('theory bpsk');
xlabel('EbNo');

subplot(6,1,6);
plot(EbNo,theory_ask);
title('theory ask');
xlabel('EbNo');


  
        