function cfs = computeModulationCFs(minCF, maxCF, nModFilters)
% cfs = computeModulationCFs(minCF, maxCF, nModFilters)
% Computes the center frequencies of the filters needed for the modulation
% filterbank used on the temporal envelope (or modulation spectrum) of the
% cochlear channels.
% -----------------------------------------------
% minCF: Center frequency of the first modulation filter
% maxCF: Center frequency of the last modulation filter
% nModFilters: Number of modulation filters between minCF and maxCF
%
% cfs: The center frequencies of the filters needed for the modulation
% filterbank.

% Spacing factor between filters.  Assumes constant (logarithmic) spacing.
spacingFactor = (maxCF/minCF)^(1/(nModFilters-1));

% Computes the center frequencies
cfs = zeros(nModFilters, 1);
cfs(1) = minCF;
for i = 2:nModFilters
  cfs(i) = cfs(i - 1)*spacingFactor;
end

end