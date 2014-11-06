function x_vad = vad_s_wrapper( x, fs )
%VAD_S_WRAPPER Calls the fastest VAD implementation available
%   If vad_s_mex exists (requires MATLAB Coder to generate), then it is
%   called. Otherwise, a standard MATLAB implementation is called.
if exist('vad_s_mex', 'file') == 3
    x_vad = vad_s_mex(x, fs);
else
    x_vad = vad_s(x, fs);
end

end

