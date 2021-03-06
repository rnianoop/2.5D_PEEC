function [val] = getWb(rg,a_min_range, a_max_range, b_min_range, b_max_range)
%%%% Calulate only at center of the quadrilateral : Avoid integration %%%%%
[weights, x] = getRule(1);
[a_dt_mult, a_value] = transformVariable(a_min_range, a_max_range, x(1));
[b_dt_mult, b_value] = transformVariable(b_min_range, b_max_range, x(1));
delRgByDelA = getRgDelByDelA(rg,a_value,b_value);
delRgByDelB = getRgDelByDelB(rg,a_value,b_value);
hb = getMagnitude(delRgByDelB);
dp = (delRgByDelB(1)*delRgByDelA(2)) - (delRgByDelB(2)*delRgByDelA(1));
denom = abs(dp);
numer = hb;
bhat = delRgByDelB./hb;
val1 = ((weights(1)*weights(1)*a_dt_mult*b_dt_mult*numer)/denom);
val2 = bhat;
val = (((weights(1)*weights(1)*a_dt_mult*b_dt_mult*numer)/denom).*bhat);
