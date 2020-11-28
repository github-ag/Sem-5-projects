function [data, data_hamm] = encodeData(m, data_size)
% Encode Hamming code using general algorithm
% Generate matrices for hamming coding
[~, G, ~, ~, k] = hmGenerator(m);
% H : parity-check matrix
% G : generator matrix
% R : recover matrix
% n : block length
% k : message length

% G : 7*4 matrix
% k : 4

nd = k*data_size;   % Number of data
data = randi([0, 1], 1, nd);
data_reshape = reshape(data, k, []); % (4*1000 matrix)

% Encode data
data_hamm = G * data_reshape; % (7*1000 matrix)
data_hamm = rem(data_hamm, 2);
data_hamm = reshape(data_hamm, 1, []); % (1*7000 matrix)
end
