function [state] = pll_init(f0, T, xi, K);

% [state] = pll_init(f0, T, xi, K);
%
% Initializes state the PLL.
%
% Inputs:
%	f0	Center frequency
%	T	Time constant of loop
%	xi	Damping factor
%	K	Loop gain

% Get loop filter
[a b tau1 tau2 K p] = loop_filter1(T, xi, K);

% Store needed parameters
state.f0 = f0;
state.K = K;
state.a = a;
state.b = b;

state.T = T;
state.xi = xi;
state.K = K;

% Set initial state
state.ref_in_prev = 0;
state.ref_out_prev = 0;
state.v_prev = 0;
state.z_prev = 0;
state.accum = 0;
