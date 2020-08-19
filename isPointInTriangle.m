% this function evaluate if the point p = (px,py) is inside the triangle of
% vertex coordinate tx = (t0x,t1x,t2x) and ty = (t0y,t1y,t2y)
function bool = isPointInTriangle(px,py,tx,ty)

t0x = tx(1); t1x = tx(2); t2x = tx(3);
t0y = ty(1); t1y = ty(2); t2y = ty(3);

Area = 0.5 *(-t1y*t2x + t0y*(-t1x + t2x) + t0x*(t1y - t2y) + t1x*t2y);

s = 1/(2*Area)*(t0y*t2x - t0x*t2y + (t2y - t0y)*px + (t0x - t2x)*py);
t = 1/(2*Area)*(t0x*t1y - t0y*t1x + (t0y - t1y)*px + (t1x - t0x)*py);

% if s, t and 1-s-t are all positive the point is inside the triangle

bool = (s>0 & t>0 & 1-s-t>0).*(1/Area);
