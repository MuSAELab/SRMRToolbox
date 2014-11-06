function [fcoefs, bandwidths] = MakeCIFilters(fs,numChannels,lowFreq)
% function [fcoefs]=MakeCIFilters(fs,numChannels,lowFreq)
% This function is based on MakeERBFilters from the Auditory Toolbox, but
% computes the filter coefficients for a bank of filters emulating the 
% filterbank of a Nucleus CI device.

% Based on code by Malcolm Slaney@Interval.  June 11, 1998.
% (c) 1998 Interval Research Corporation  

% Modified 2006-07-19 by Peter Chng.
% Changes: Also output a vector corresponding to the ERBs of each filter.
% Previous usage unaffected. 

T = 1/fs;
if length(numChannels) == 1
	cf = ERBSpace(lowFreq, fs/2, numChannels);
else
	cf = numChannels(1:end);
	if size(cf,2) > size(cf,1)
		cf = cf';
	end
end

% Change the followFreqing three parameters if you wish to use a different
% ERB scale.  Must change in ERBSpace too.
EarQ = 9.26449;				%  Glasberg and Moore Parameters
minBW = 24.7;
order = 1;

% Bandwidths for emulating a Nucleus device
bandwidths = [1000;875;750;625;625;500;500;375;375;250;250;250;250;125;125;125;125;125;125;125;125;125];

B=1.019*2*pi*bandwidths;

A0 = T;
A2 = 0;
B0 = 1;
B1 = -2*cos(2*cf*pi*T)./exp(B*T);
B2 = exp(-2*B*T);

A11 = -(2*T*cos(2*cf*pi*T)./exp(B*T) + 2*sqrt(3+2^1.5)*T*sin(2*cf*pi*T)./ ...
		exp(B*T))/2;
A12 = -(2*T*cos(2*cf*pi*T)./exp(B*T) - 2*sqrt(3+2^1.5)*T*sin(2*cf*pi*T)./ ...
		exp(B*T))/2;
A13 = -(2*T*cos(2*cf*pi*T)./exp(B*T) + 2*sqrt(3-2^1.5)*T*sin(2*cf*pi*T)./ ...
		exp(B*T))/2;
A14 = -(2*T*cos(2*cf*pi*T)./exp(B*T) - 2*sqrt(3-2^1.5)*T*sin(2*cf*pi*T)./ ...
		exp(B*T))/2;

gain = abs((-2*exp(4*i*cf*pi*T)*T + ...
                 2*exp(-(B*T) + 2*i*cf*pi*T).*T.* ...
                         (cos(2*cf*pi*T) - sqrt(3 - 2^(3/2))* ...
                          sin(2*cf*pi*T))) .* ...
           (-2*exp(4*i*cf*pi*T)*T + ...
             2*exp(-(B*T) + 2*i*cf*pi*T).*T.* ...
              (cos(2*cf*pi*T) + sqrt(3 - 2^(3/2)) * ...
               sin(2*cf*pi*T))).* ...
           (-2*exp(4*i*cf*pi*T)*T + ...
             2*exp(-(B*T) + 2*i*cf*pi*T).*T.* ...
              (cos(2*cf*pi*T) - ...
               sqrt(3 + 2^(3/2))*sin(2*cf*pi*T))) .* ...
           (-2*exp(4*i*cf*pi*T)*T + 2*exp(-(B*T) + 2*i*cf*pi*T).*T.* ...
           (cos(2*cf*pi*T) + sqrt(3 + 2^(3/2))*sin(2*cf*pi*T))) ./ ...
          (-2 ./ exp(2*B*T) - 2*exp(4*i*cf*pi*T) +  ...
           2*(1 + exp(4*i*cf*pi*T))./exp(B*T)).^4);
	
allfilts = ones(length(cf),1);
fcoefs = [A0*allfilts A11 A12 A13 A14 A2*allfilts B0*allfilts B1 B2 gain];

end