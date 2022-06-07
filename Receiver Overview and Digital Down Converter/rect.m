function [y] = rect(x, p);

% [y] = rect(x, p);
%
% Just does a rectangular function.
%
% Inputs:
%	x	Sample points
%	p.x1	Bottom sample of rect
%	p.x2	Top sample of rect

y = zeros(size(x));
idx = (x >= p.x1) & (x <= p.x2);
y(idx) = 1;
