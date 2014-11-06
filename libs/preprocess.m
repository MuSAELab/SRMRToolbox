function [ y, yfs ] = preprocess(s, fs)

% read the .wav file if needed
if ischar(s)
    [smpl,yfs]=wavread(s);
else
    smpl = s;
    yfs = fs;
end

% Simple energy-thresholding voice activity detection. A more advanced VAD
% should be used with noise-corrupted speech files
smpl_vad = vad_s_wrapper(smpl, yfs);

% ITU-T P.56 energy normalization to -26dBov
y=asl_adjust_wrapper(smpl_vad,yfs,-26);

end

