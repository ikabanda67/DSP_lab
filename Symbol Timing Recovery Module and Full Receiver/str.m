function [si, state_out, d] = str(Ib, Qb, state_in);

% Inputs:
%   Ib, Qb      Raw I/Q samples after ddc
%   p       Parameters
%           .Tc Symbol time (samples)
%           .a,.b   Filter coefficients for PLL loop filter
%           .K  Loop gain for PLL
%  state_in    Input state
%  Outputs:
%   si      Sample indicator output
%   state_out   Output state
%   d       Debug info

state = state_in;
% Generate sample indicator output
si = zeros(length(Ib), 1);

% Generate waveform delayed by 1/2 nominal symbol time
[state.delay_state, Ib_d] = delay(state.delay_state, Ib);
% Take product
xp = Ib_d.*Ib;

% Track component at fc=1/Tc with PLL
[ref, accum, state.pll_state] = pll(xp, state.pll_state);


% Do boundary sample
if (state.accum_prev < 0.75) && (accum(1) >= 0.75)
    si(1) = 1;
end

for ii=2:length(Ib),
    if (accum(ii-1) < 0.75) && (accum(ii) >= 0.75)
        si(ii) = 1;
    end
end

state.accum_prev = accum(end);
state_out = state;

if (nargout >= 3),
    d.xp = xp;
    d.ref = ref;
    d.accum = accum;
end
