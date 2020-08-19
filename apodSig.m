function [out,mask] = apodSig(in,N)

Nx = numel(in);

x = abs(linspace(-Nx/2,Nx/2,Nx));
if size(in,1) > 1
   x = x'; 
end
mapx = x > Nx/2 - N;

val = mean(mean(in(:)));

d = (-abs(x)- mean(-abs(x(mapx)))).*mapx;
d = linmap(d,-pi/2,pi/2);
d(not(mapx)) = pi/2;
mask = (sin(d)+1)/2;

out = (in-val).*mask + val;