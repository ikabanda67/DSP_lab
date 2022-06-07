function [y, state_out] = fir(x, state_in);

% function [y, state_out] = fir(x, state_in);
%
% Implements efficient FIR filter.  Operates on a single
% block and generates a single output block.
%
% Inputs:
%	x		Block
%	state_in	Input state
% Outputs:
%	y	Output block

state = state_in;

K = length(state.h);
M = length(x);

% Generate empty output block
y = zeros(M, 1);

% Copy input samples into temp buffer
state.buff(K:K+M-1) = x;
% Implement with for loop

% Loop through input samples
for n=1:M,
  % Multiply and sum
  y(n) = sum(state.hr.*state.buff(n:n+K-1));
  % For loop implementation
end

% Copy last samples to beginning
state.buff(1:K-1) = state.buff(M+1:M+K-1);

% Store output state
state_out = state;


