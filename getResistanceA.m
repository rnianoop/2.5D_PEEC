function [val] = getResistanceA(rule,rg,a_min_range, a_max_range, b_min_range, b_max_range)
[weights, x] = getRule(rule);

sum = 0;

for i = 1:rule
   
    [a_dt_mult, a_value] = transformVariable(a_min_range, a_max_range, x(i));
    for j = 1:rule
        [b_dt_mult, b_value] = transformVariable(b_min_range, b_max_range, x(j));
           
        delRgByDelA = getRgDelByDelA(rg,a_value,b_value);
        delRgByDelB = getRgDelByDelB(rg,a_value,b_value);
        ha = getMagnitude(delRgByDelA);
        dp = (delRgByDelA(1)*delRgByDelB(2)) - (delRgByDelA(2)*delRgByDelB(1));
        
        denom = abs(dp);
        numer = ha*ha;
        sum = sum + ((weights(i)*weights(j)*a_dt_mult*b_dt_mult*numer)/denom);
    end
end
%val = sum*totallena*totallenb;
val = sum;
