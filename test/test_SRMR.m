% Before using this test script, set up the path and compile the MEX extensions
% as instructed in the README file.

% First possible syntax: pass filename as argument, without sampling rate
file = 'test.wav';
[ratio, energy] = SRMR(file);

% Second possible syntax: pass vector and sampling rate as argument
[s, fs] = wavread('test.wav');
[ratio, energy] = SRMR(s, fs);

% SRMRnorm optionally supports controlling the bandwidth of the
% modulation filterbank third and fourth arguments are the center
% frequencies of the first and last filters.
[ratio_norm, energy_norm] = SRMR(s, fs, 'norm', 1);

% Testing fast versions, based on Dan Ellis' gammatonegram
[ratio_fast, energy_fast] = SRMR(s, fs, 'fast', 1);
[ratio_fast_norm, energy_fast_norm] = SRMR(s, fs, 'fast', 1, 'norm', 1);

% Comparing results with precomputed results
load test.mat

fprintf('test_SRMR: Comparing results with precomputed results...\n');

if sum(abs(correct_ratios - [ratio ratio_fast ratio_fast_norm ratio_norm])) ~= 0
    error('Results are different from precomputed results! Please check your setup and make sure there are no functions conflicting with the functions used by this toolbox in the MATLAB path.');
else
    fprintf('Results equal to precomputed results!\n');
end
