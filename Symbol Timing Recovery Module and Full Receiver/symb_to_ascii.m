function [ascii] = symb_to_ascii(bps, symb);

symb_per_char = 8/bps;
Nchar = floor(length(symb)/symb_per_char);
symb1 = reshape(symb(1:Nchar*symb_per_char), symb_per_char, Nchar);
ascii = zeros(1, Nchar);
mult = 1;
for ii=1:symb_per_char,
  ascii = ascii + bitshift(symb1(ii,:), (ii-1)*bps);
end
ascii = char(ascii);