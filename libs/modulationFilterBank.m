% y = modulationFilterBank(x, mcf, fs, q)
% -------------------------------------------------------------------------
% in: The input signal to be filtered, expected to be in row-vector form.
% mcf: A vector containing the center frequencies, in Hz, of each filter in
%   the filterbank. (Example: [2, 4, 8, 16, 32, 64, 128, 256])
% fs: The sampling rate, in Hz.
% q: The desired Q-value of the filters.
%
% out: The outputs of the modulation filterbank, organized as a matrix of
%   dimensions (length(mcf), length(x)).
% -----------------------------------------------
% Filters the input signal through the modulation filterbank described by
% Ewert and Dau in "Characterizing frequency selectivity for envelope
% fluctuations" (2000).  The original comment blocks are included. 

function out = modulationFilterBank(x, mcf, fs, q)

out = zeros(length(mcf),length(x));

B = zeros(length(mcf),3);
A = zeros(length(mcf),3);

for i = 1:length(mcf)

    w0 = 2*pi*mcf(i)/fs;
    [b3,a3] = makeModulationFilter(w0,q);
    B(i,:) = b3; A(i,:) = a3;
    out(i,:)= filter(b3, a3, x);   
end

end