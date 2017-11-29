function [dt_mult, originalVariable] = transformVariable(min_range, max_range, integralVariable)

if((min_range == -1) && (max_range == 1))
    dt_mult = 1;
    originalVariable = integralVariable;
end

dt_mult = (max_range-min_range)/2.0;
originalVariable = (max_range-min_range)*integralVariable/2.0 + (max_range+min_range)/2.0;
    