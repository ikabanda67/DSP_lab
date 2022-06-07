function [state] = fir_init(h);

% [state] = fir_init(h);
%
% Initializes FIR filter state.
%
% Inputs:
%	h	Coefficients

% Store parameters
state.h = h;

% Set initial state
state.hr = h(end:-1:1);
K = length(h);
state.buff = zeros(K+1-1,1);
