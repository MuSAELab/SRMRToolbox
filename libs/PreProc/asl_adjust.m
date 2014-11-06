function sam_out=asl_adjust(sam,fs,asl)
% sam_out=asl_adjust(sam,fs,asl)
% sam: input vector
% fs: sampling frequency
% asl: target ASL value, e.g., -26 

sam_asl=asl_meter(sam,fs);
sam_out=sam/(10^((sam_asl-asl)/20));

end