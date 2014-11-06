function x_new = vad_s(x,fs)
% a simple Voice Activity Detection program for speech processing

if nargin <1
    error('no data ???');
end
if nargin <2
    fs = 8000;
end

% an energy threshold is used to remove the silence parts of speech signal
% the speech is assumed to be clean
idx = find(x.^2>max(abs(x))^2/(10^(50/10))); % or 30db?
diff = idx(2:end)-idx(1:end-1);
thresh = 0.05*fs; % set threshold to 50ms
idx2 = [idx(diff>thresh)'; idx(find(diff>thresh)+1)'];
idx2 = idx2(:);

if ~isempty(idx2)
    if length(idx2)>2
        x_new = x(idx(1):idx2(1));
        for ii = 2:2:length(idx2)-2
            x_new = [x_new ; x(idx2(ii):idx2(ii+1))];
        end
        x_new = [x_new ; x(idx2(end):idx(end))];
    else
        x_new = [x(idx(1):idx2(1)) ; x(idx2(1):idx(end))];
    end
else
    x_new = x(idx(1):idx(end));
end





