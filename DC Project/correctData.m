function [data_corrected] = correctData(m, data_hamm_rx)

% Generate matrices for hamming coding
[H, ~, ~, n, ~] = hmGenerator(m);
% H : parity-check matrix (3*7 matrix)
% G : generator matrix
% R : recover matrix
% n : block length
% k : message length

data_hamm_rx = reshape(data_hamm_rx, n, []);
nd = size(data_hamm_rx,2);

%% Parity-check received data
% Received matrix is of the shape(7*data_size)
% Multiply received data with parity-check matrix
data_hamm_error_corrected = data_hamm_rx;

data_hamm_parity_check = H * data_hamm_rx;
data_hamm_parity_check = rem(data_hamm_parity_check, 2);
%Finding the exact error bit.
data_parity_error = bi2de(data_hamm_parity_check', 'right-msb');

% Find out which data is broken and fix the data
% for each msg data(each column) correcting the error bit in that column.
for i=1:nd
    if data_parity_error(i)
        data_hamm_error_corrected(data_parity_error(i), i) = not(data_hamm_error_corrected(data_parity_error(i),i));
    end 
end

data_corrected = reshape(data_hamm_error_corrected, 1, []);