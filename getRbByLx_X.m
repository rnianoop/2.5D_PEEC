function [val] = getRbByLx_X(rule,rg,a_min_range, a_max_range, b_min_range, b_max_range, binnodes)
[weights, x] = getRule(rule);

sum = 0;

for i = 1:rule
   
    [a_dt_mult, a_value] = transformVariable(a_min_range, a_max_range, x(i));
    for j = 1:rule
        [b_dt_mult, b_value] = transformVariable(b_min_range, b_max_range, x(j));
        
        delRgByDelA = getRgDelByDelA(rg,a_value,b_value);
        delRgByDelB = getRgDelByDelB(rg,a_value,b_value);
      
        kx = delRgByDelA(1); ky = delRgByDelA(2);
        lx = delRgByDelB(1); ly = delRgByDelB(2);

        numer = ((2*lx)*(((lx*ky) - (ly*kx))^2)) - (ky*((lx*lx)+(ly*ly))*((lx*ky) - (ly*kx)));
        denom = (((lx*ky) - (ly*kx))^2)*(abs((lx*ky)-(ly*kx)));
        
        delLByDelX = getDelLByDelX_1(binnodes,a_value);
        
        sum = sum + ((weights(i)*weights(j)*a_dt_mult*b_dt_mult*numer*delLByDelX)/denom);
    end
end

val = sum;
