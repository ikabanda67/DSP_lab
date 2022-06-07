function [param] = system_param;

% [param] = system_param;
%
% Get system parameters.

% Sample rate
fs = 96000;
% Nominal frequency of carrier
f0 = 24000;
% Nominal frequency of pilot tone
ft = 8000;
% Symbol rate
fc = 16000;
% Cycles per symbol
cps = f0/fc;

% Store global parameters
param.fs = fs;
param.f0 = f0;
param.ft = ft;
param.fc = fc;
param.cps = cps;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DDC Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%
%% Filter to isolate pilot tone

fmin = 5000;
fmax = 11000;

% Need a band-pass filter centered at 8kHz +- 2 kHz.

% Length of the filter
N = 32;

% Do a hamming window
wtype = 1;
p.x1 = fmin/fs; p.x2 = fmax/fs;
[h_bp, f_bp, Ha_bp, Hi_bp, w] = win_method('rect', p, 1.0, 1, N, wtype);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLL params for locking to tone

K = 2;
T = 100;
xi = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%
%% Matched filter on receiver (Root-raised cosine)

fmin = 0;
fmax = 12000;

% Length of the filter
N = 128;

% Do a hamming window
wtype = 1;
p.beta = 0.5;
p.fs = fc/fs;
p.root = 1;
[h_lp, f_lp, Ha_lp, Hi_lp, w] = win_method('rc_filt', p, 1.0, 1, N, wtype);

% Make sure matched filter has unit peak response.
nf = max(abs(conv(h_lp, h_lp)));
h_lp = h_lp/sqrt(nf);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Store needed parameters

param.ddc.h_lp = h_lp;
param.ddc.Ha_lp = Ha_lp;
param.ddc.f_lp = f_lp;
param.ddc.h_bp = h_bp;
param.ddc.Ha_bp = Ha_bp;
param.ddc.f_bp = f_bp;
param.ddc.f0 = f0/fs;
param.ddc.ft = ft/fs;
param.ddc.T = T;
param.ddc.K = K;
param.ddc.xi = xi;
param.ddc.fm = f0/ft;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Symbol timing recovery
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Loop filter
K = 2;
T = 100*fs/fc;  % Number of samples for pll time constant (100 symbols)
xi = 1;
[a b tau1 tau2 K p] = loop_filter1(T, xi, K);

param.str.K = K;
param.str.T = T;
param.str.xi = xi;
param.str.a = a;
param.str.b = b;
param.str.Tc = 1/(fc/fs);
param.str.K = K;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Signal Generation parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Rectangular pulses (easier to visualize)
%sps = round(fs/f0*cps);
%param.h_ps = ones(sps,1);

% Matched filtering
param.h_ps = param.ddc.h_lp;

% Frame sync symbol
param.frame.sync = [0 1 2 3];
param.frame.N    = 32;

