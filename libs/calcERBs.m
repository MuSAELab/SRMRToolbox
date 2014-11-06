% [ERBs, cf] = calcERBs(lowFreq, fs, nCochlearFilters)
% -----------------------------------------------
% lowFreq: Lowest center frequency of the filterbank.
% fs: The sampling rate of the signal, s, in Hz.
% nCochlearFilters: The number of critical-band filters in the filterbank.
% 
% ERBs: Equivalent Rectangular Bandwidths for each channel of the
% filterbank
% cf: center frequencies for each channel of the filterbank.
% -----------------------------------------------
% Returns the ERBs and center frequencies of the cochlear filterbank
% designed with the corresponding parameters.


function [ERBs, cf] = calcERBs(lowFreq, fs, nCochlearFilters)
EarQ = 9.26449;				%  Glasberg and Moore Parameters
minBW = 24.7;
order = 1;
cf = ERBSpace(lowFreq, fs/2, nCochlearFilters);
ERBs = ((cf/EarQ).^order + minBW^order).^(1/order);
end