function [ratio, energy] = SRMR_CI(s,varargin)
%SRMR Computes the SRMR-CI score of the given signal.
% [ratio, energy] = SRMR_CI(s, fs, 'norm', 0, 'minCF', 4, 'maxCF', 128)
%
% s: either the path to a WAV file or an array containing a single-channel speech sentence.
% fs: sampling rate of the data in `s`. If `s` is the path to a WAV file, this parameter 
%     has to be omitted.
% 'norm', N: flag to activate (`N = 1`)/deactivate (`N = 0`) the normalization step in the 
%            modulation spectrum representation, used for variability reduction. The default is `'norm', 0`.
% 'minCF', cf1: value of the center frequency of the first filter in the modulation filterbank.
%               The default value is 4 Hz.
% 'maxCF', cf8: value of the center frequency of the first filter in the modulation filterbank. 
%               The default value is 128 Hz if the normalization is off and 30 Hz if normalization is on.
%
% ratio: the SRMR-CI score.
% energy: a 3D matrix with the per-frame modulation spectrum extracted from the input.

% Load (if needed) and preprocess file
if ischar(s)
    fs = [];
    args = {varargin{:}};
else
    if isempty(varargin)
        error('Second argument must be the sampling rate if input is a vector');
    else
        if ~isnumeric(varargin{1})
            error('Second argument must be the sampling rate if input is a vector');
        else
            fs = varargin{1};
        end
    end
    args = {varargin{2:end}};
end

[s, fs] = preprocess(s, fs);

if fs ~= 8000 && fs ~= 16000
    warning('fs = %d, but SRMR has only been tested for fs = 8/16 kHz.', fs);
end

fast = 0;
norm = 0;

% Parameter parsing
for i = 1 : 2 : length(args)
    name = args{i};
    value = args{i+1};
    switch name
        case 'fast'
            error('SRMR-CI does not have a fast implementation yet.');
        case 'norm'
            norm = value;
        case 'minCF'
            minCF = value;
        case 'maxCF'
            maxCF = value;
        otherwise
            error('Wrong parameter in parameter list');
    end
end

%% Fixed parameters:
% Cochlear filterbank
nCochlearFilters = 22;
lowFreq = 150;

% Modulation filterbank
nModFilters = 8;

if ~exist('minCF','var')
    minCF = 4;
end
if ~exist('maxCF', 'var')
    if norm == 1
        maxCF = 30;
    else
        maxCF = 64;
    end
end

wLengthS = 0.256; % Window length in seconds. 
wIncS = 0.064; % Window increment in seconds;

wLength = ceil(wLengthS*fs); % Window length in samples
wInc = ceil(wIncS*fs); % window increment in samples

%% Cochlear filterbank/envelope computation

    % Pass the signal through the cochlear filter bank to produce the cochlear
    % outputs at each critical band.
    % The dimensions will be: cochlearOutputs(nCochlearFilters, nSamples), with 
    % the last being lowest frequency, and the first being highest frequency. 
    [cochlearOutputs, bandwidths] = CIFilterBank(fs, nCochlearFilters, lowFreq, s);

    % Compute the temporal envelope for each critical band.  The dimensions will
    % be: temporalEnvelopes(nCochlearFilters, nSamples)
    tempEnv = abs(hilbert(cochlearOutputs'))';    

%% Modulation spectrum
modFilterCFs = computeModulationCFs(minCF, maxCF, nModFilters);        
w = hamming(wLength);

for k=1:nCochlearFilters
    modulationOutput = modulationFilterBank(tempEnv(k,:), modFilterCFs, fs, 2);
    for m=1:nModFilters
        % Window frames with Hamming window
        modOutFrame = buffer(modulationOutput(m,:), wLength, (wLength-wInc));
        energy(k,m,:) = sum((w(:,ones(1,size(modOutFrame,2))).*modOutFrame).^ 2);
    end
end

%% Modulation energy thresholding
if norm
    peak_energy = max(max(mean(energy)));
    min_energy = peak_energy*0.001;
    energy(energy < min_energy) = min_energy;
    energy(energy > peak_energy) = peak_energy;
end

%% Computation of K*
cochFilt_BW = flipud(bandwidths);

avg_energy = mean(energy,3);

total_energy = sum(sum(avg_energy));

AC_energy = sum(avg_energy,2);
AC_perc = AC_energy*100./total_energy;

AC_perc_cumsum=cumsum(flipud(AC_perc));
K90perc = find(AC_perc_cumsum>90);

BW = cochFilt_BW(K90perc(1));

cutoffs = calc_cutoffs(modFilterCFs, fs, 2);

if (BW > cutoffs(5)) && (BW < cutoffs(6))
    Kstar=5;
elseif (BW > cutoffs(6)) && (BW < cutoffs(7))
    Kstar=6;
elseif (BW > cutoffs(7)) && (BW < cutoffs(8))
    Kstar=7;
elseif (BW > cutoffs(8))
    Kstar=8;
end

%% Modulation energy ratio
ratio = sum(sum(avg_energy(:,1:4)))/sum(sum(avg_energy(:,5:Kstar)));

end
