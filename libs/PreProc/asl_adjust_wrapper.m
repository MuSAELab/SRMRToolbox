function out = asl_adjust_wrapper( x, fs, asl )
%ASL_ADJUST_WRAPPER Calls the fastest ASL adjustment implementation
%available. If asl_adjust_mex exists (requires MATLAB Coder to generate), 
% then it is called. Otherwise, a standard MATLAB implementation is called.

if exist('asl_adjust_mex', 'file') == 3
    out = asl_adjust_mex(x, fs, asl);
else
    out = asl_adjust(x, fs, asl);
end

end

