function [s, d] = make_signal_4psk(fs, f0, ft, cps, h, as, at, symb);

% [s, d] = make_signal_4psk(fs, f0, ft, cps, h, as, at, symb);
%
% This function generates a modulated 4PSK test signal.
%
% Inputs:
%	fs	Sample rate
%	f0	Carrier frequency
%	ft	Frequency of reference tone
%	cps	Cycles of carrier per symbol
%	h	Pulse shaping filter
%	as	Amplitude of signal
%	at	Amplitude of tone
%	symb	Symbols (values of 0-3)
%
% Outputs:
%	s	Modulated waveform
%	d	Debug information
%		.c	Carrier signal
%		.t	Tone signal
%		.mod	Modulation signal

M = length(symb);

% Samples per symbol
sps = round(fs/f0*cps);

% Random staring time (to get random phase)
n_start = fs/min(ft,f0)*rand;

% Generate modulation
gray_code = [1+j; -1+j; 1-j; -1-j];
mod1 = gray_code(symb(:)+1);
pt1 = [mod1(:).'; zeros(sps-1, length(mod1))];
pt1 = pt1(:);
mod2 = conv(pt1, h); mod2 = mod2(:);

% Remove delay
[val idx] = max(abs(h));
mod2 = mod2(idx:end);
d.mod = mod2;

% Get length of signal
N = length(mod2);
n = [0:N-1].';

% Generate carrier
c = exp(j*2*pi*f0/fs*(n+n_start));
d.c = c;

% Generate tone
t = exp(j*2*pi*ft/fs*(n+n_start));
d.t = t;

% Generate total signal
s = real(as*mod2.*c + at*t);



