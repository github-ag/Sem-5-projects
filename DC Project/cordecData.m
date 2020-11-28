function [decodedData] = cordecData(m, data)
% Correct and decode data using general algorithm


[hamm_corrected] = correctData(m, data);
[hamm_deocded] = decodeData(m, hamm_corrected);
decodedData = hamm_deocded;