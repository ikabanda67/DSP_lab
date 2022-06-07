function [ref_out, accum_out, state_out] = pll(ref_in, state_in);

% [ref_out] = pll(ref_in, state_in);
%
% Does PLL tracking of the input waveform.  Operates on complete waveform.
%
% Inputs:
%	ref_in		Input reference
%	state_in	State and parameters
% Outputs:
%	ref_out		Output reference
%	accum_out	Output accumulator

% Get parameters

state = state_in;

f0 = state.f0;
K = state.K;
a = state.a;
b = state.b;

N = length(ref_in);

ref_out = zeros(N, 1);
accum_out = zeros(N, 1);

%% Estimate amplitude of block
amp_est = mean(abs(ref_in))*(pi/2);

%% Get accumulator

%% Put your PLL code here !!!  

% Don't forget to use state variables properly!


for i=0:N-1
    x = state.ref_in_prev/amp_est;
    
    state.z_c=x*state.ref_out_prev;
    state.v_c=a*state.v_prev + b(1)*state.z_c + b(2)*state.z_prev;
 
    state.accum = state.accum+ f0 -K*state.v_c/(2*pi);
    state.accum = state.accum - floor(state.accum);
    
    accum_out(i+1)=state.accum;
    % calculate output using sine
    ref_out(i+1)=sin(2*pi*state.accum);
    
    % update state variables
    state.ref_out_prev=ref_out(i+1);
    state.z_p=state.z_c;
    state.v_p=state.v_c;
    state.ref_in_prev=ref_in(i+1);
end
state_out = state;
