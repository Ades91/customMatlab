function val = clamp(val,minval,maxval)

if isempty(minval) % no lower bound
    mapmax = val > maxval;
    val(mapmax) = maxval;
end
if isempty(maxval) % no upper bound
    mapmin = val < minval;
    val(mapmin) = minval;
end
if ~isempty(minval) && ~isempty(maxval)
    mapmax = val > maxval;
    val(mapmax) = maxval;
    
    mapmin = val < minval;
    val(mapmin) = minval;
end