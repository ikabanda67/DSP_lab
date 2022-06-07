function [f] = ascii_to_symb_frame(bps, sync, N, ascii);

% [f] = ascii_to_symb_frame(bps, sync, N, ascii);

% Convert ascii message to symbols
symb = ascii_to_symb(bps, ascii);

% Fill out so even multiple of frame length
Nframe = floor(length(symb)/N);
payload = reshape(symb(1:Nframe*N), N, Nframe);
f = [sync(:)*ones(1,Nframe); payload];