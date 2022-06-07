function [ddc_state] = ddc_init(p);

% [ddc_state] = ddc_init(p);
%
% Initializes state of DDC according to parameters in ddc_param.
%
% Inputs:
%	p	Parameters of DDC.  
%		.h_bp	Coefficients of band-pass filter
%		.f0	Nominal center frequency (discrete)
%		.ft	Nominal center frequency of tone (discrete)
%		.a, .b	Coefficients of the IIR filter for PLL
%		.K	Loop gain of PLL
%		.fm	Frequency multiple (carrier relative to tone)

% Store required variables in ddc state
ddc_state.fm = p.fm;

% Get required shift of accumulator to compensate for delay of BPF
ddc_state.del = p.ft*((length(p.h_bp)-1)/2);

% Create band-pass filter
ddc_state.bpf_state = fir_init(p.h_bp);

% Create PLL for carrier recovery
ddc_state.pll_state = pll_init(p.ft, p.T, p.xi, p.K);

% Create matched filters
ddc_state.lpf1_state = fir_init(p.h_lp);
ddc_state.lpf2_state = fir_init(p.h_lp);






