function [str_state]=str_init(p); 

% create delay block
str_state.delay_state = delay_init(200, p.Tc/2);
 
% create pll for carrier recovery
str_state.pll_state = pll_init((1/p.Tc), p.T,p.xi, p.K);

str_state.accum_prev=0;