% apodize the input image in with a cosine edge mask over a length of N
% pixels
function out = apodImRect(in,N)

Nx = size(in,2);
Ny = size(in,1);

x = abs(linspace(-Nx/2,Nx/2,Nx));
y = abs(linspace(-Ny/2,Ny/2,Ny));
mapx = x > Nx/2 - N;
mapy = y > Ny/2 - N;

val = mean(mean(in(:)));

dx = (-abs(x)- mean(-abs(x(mapx)))).*mapx;
dx = linmap(dx,-pi/2,pi/2);
dx(not(mapx)) = pi/2;
maskx = (sin(dx)+1)/2;

dy = (-abs(y)- mean(-abs(y(mapy)))).*mapy;
dy = linmap(dy,-pi/2,pi/2);
dy(not(mapy)) = pi/2;
masky = (sin(dy)+1)/2;

% make it 2D
mask = (masky')*maskx;

out = bsxfun(@times,(in-val),mask) + val;