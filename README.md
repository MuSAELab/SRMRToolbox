# SRMR Toolbox

The speech-to-reverberation modulation energy ratio (SRMR) is a non-intrusive
metric for speech quality and intelligibility based on a modulation spectral
representation of the speech signal. The metric was proposed by Falk et al.
and recently updated for variability reduction and improved intelligibility
estimation both for normal hearing listeners and cochlear implant users.

This toolbox includes the following implementations of the SRMR metric: 

1. The original SRMR metric (used as one of the objective metrics in the [REVERB Challenge](http://reverb2014.dereverberation.com)).
2. The updated SRMR metric, incorporating updates for reduced variability.
3. A fast implementation of the original SRMR metric, using a
[gammatonegram](http://www.ee.columbia.edu/ln/rosa/matlab/gammatonegram/) to
replace the time-domain gammatone filterbank. The fast implementation can also
optionally use the updates for reduced variability.
4. A version tailored for cochlear implant users (SRMR-CI).

These implementations have been shown to perform well with sampling rates of 8
and 16 kHz. They will run for other sampling rates, but a warning will be
shown as the metrics have not been tested under such conditions.

## Setup

Prior to using the functions in the toolbox, the main folder and its
subfolders have to be added to the MATLAB path. This can be done as follows:

    addpath('/path/to/SRMRToolbox')
    addpath(genpath('/path/to/SRMRToolbox/libs'))

If you have access to MATLAB Coder, you can also call the script
`gen_mexfiles` prior to first using the toolbox. This will generate fast
versions of the voice activity detection and speech level adjustment functions
used by SRMR. If you do not have access to MATLAB Coder, slower versions of
these functions will be used.

## Usage

Implementations 1 to 3 are all called from the same M-file, `SRMR.m`. The function `SRMR` accepts a number of optional named parameters: 

    [ratio, energy] = SRMR(s, fs, 'fast', 0, 'norm', 0, 'minCF', 4, 'maxCF', 128)

- `s`: either the path to a WAV file or an array containing a single-channel speech sentence.
- `fs`: sampling rate of the data in `s`. If `s` is the path to a WAV file, this parameter has to be omitted.
- `'fast', F`: flag to activate (`F = 1`)/deactivate (`F = 0`) the fast implementation. The default is `'fast', 0` (this can be omitted).
- `'norm', N`: flag to activate (`N = 1`)/deactivate (`N = 0`) the normalization step in the modulation spectrum representation, used for variability reduction. The default is `'norm', 0`.
- `'minCF', cf1`: value of the center frequency of the first filter in the modulation filterbank. The default value is 4 Hz.
- `'maxCF', cf8`: value of the center frequency of the first filter in the modulation filterbank. The default value is 128 Hz if the normalization is off and 30 Hz if normalization is on.

The outputs are `ratio`, which is the SRMR score, and `energy`, a 3D matrix with the per-frame modulation spectrum extracted from the input.

## Examples

Calling original SRMR implementation with a file name as argument:

    file = 'test.wav';
    [ratio, energy] = SRMR(file);

Calling original SRMR with a vector and sampling rate as argument:

    [s, fs] = wavread('test.wav');
    [ratio, energy] = SRMR(s, fs);

Calling SRMRnorm with default parameters (i.e., `minCF = 4` and `maxCF = 30`):

    [ratio_norm, energy_norm] = SRMR(s, fs, 'norm', 1);

Calling SRMRnorm with the last modulation filterbank at 64 Hz:
    
    [ratio_norm64, energy_norm64] = SRMR(s, fs, 'norm', 1, 'maxCF', 64);

Calling fast versions, based on Dan Ellis' gammatonegram:

    [ratio_fast, energy_fast] = SRMR(s, fs, 'fast', 1);
    [ratio_fast_norm, energy_fast_norm] = SRMR(s, fs, 'fast', 1, 'norm', 1);

## References

If you use this toolbox in your research, please cite the reference below:

_**[TASLP2010]** Tiago H. Falk, Chenxi Zheng, and Way-Yip Chan. A Non-Intrusive Quality and Intelligibility Measure of Reverberant and Dereverberated Speech, IEEE Trans Audio Speech Lang Process, Vol. 18, No. 7, pp. 1766-1774, Sept. 2010. [doi:10.1109/TASL.2010.2052247](http://dx.doi.org/10.1109/TASL.2010.2052247)_

If you use the normalized version of the metric, please cite the following reference in addition to **[TASLP2010]**: 

_**[IWAENC2014]** João F. Santos, Mohammed Senoussaoui, and Tiago H. Falk. An updated objective intelligibility estimation metric for normal hearing listeners under noise and reverberation. In International Workshop on Acoustic Signal Enhancement (IWAENC). September 2014._

Likewise, if you use the CI-tailored version of the metric (with or without normalization), please cite this reference in addition to **[TASLP2010]**:

_**[TASLP2014]** João F. Santos and Tiago H. Falk. Updating the SRMR metric for improved intelligibility prediction for cochlear implant users. IEEE Transactions on Audio, Speech, and Language Processing, December 2014. [doi:10.1109/TASLP.2014.2363788](http://dx.doi.org/doi:10.1109/TASLP.2014.2363788)._
