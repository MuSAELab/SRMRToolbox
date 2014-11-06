function [L, R] = calc_cutoffs(cfs, fs, q)
%calc_cutoffs Calculates cutoff frequencies (3 dB) for 2nd order bandpass
w0 = 2*pi*cfs/fs;
B0 = tan(w0/2)/q;
L = cfs - (B0 * fs / (2*pi));
R = cfs + (B0 * fs / (2*pi));

end

