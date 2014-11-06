% [b, a] = makeModulationFilter(w0, q)
% -------------------------------------------------------------------------
% w0: normalized center frequency of the 2nd order bandpass filter
% q: The desired Q-value
%
% b, a: filter coefficients

function [b,a] = makeModulationFilter(w0,Q)
% w0 is cf of 2nd-order bandpass filter
% Q is the Q of the filter
W0 = tan(w0/2);
B0 = W0/Q;
 
b = [B0; 0; -B0];
a = [1 + B0 + W0^2; 2*W0^2 - 2; 1 - B0 + W0^2];

b = b/a(1);
a = a/a(1);

end