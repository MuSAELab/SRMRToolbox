% This scripts compiles two MEX functions (VAD and ASL adjustment) used by the toolbox.
% If you do not have access to MATLAB Coder, the toolbox will use the slower, M-file based
% versions of these functions.  

fprintf('Compiling MEX files (if needed)...\n');

% generate mex files if MATLAB Coder is installed
v = ver;
if any(strcmp('MATLAB Coder', {v.Name}))
    fprintf('MATLAB Coder installed, generating code and compiling additional MEX functions (if needed).\n');
    if isempty(dir(['libs/vad/vad_s_mex.' mexext]))
        fprintf('Generating MEX file for vad_s...\n');
        cfg = coder.config('mex');
        cfg.DynamicMemoryAllocation = 'AllVariableSizeArrays';
        cd libs/vad; codegen -config cfg vad_s.m -args {coder.typeof(10,[inf,1]), 16000}
        cd ../..;
    end
    if isempty(dir(['libs/PreProc/asl_adjust_mex.' mexext]))
        cfg = coder.config('mex');
        cfg.DynamicMemoryAllocation = 'AllVariableSizeArrays';
        fprintf('Generating MEX file for asl_adjust...\n');
        cd libs/PreProc; codegen -config cfg asl_adjust.m -args {coder.typeof(10,[inf,1]), 16000, -29.0}
        cd ../..;
    end
else
    fprintf('MATLAB Coder toolbox not installed, using (slower) MATLAB functions\n');
end

fprintf('Done!\n');