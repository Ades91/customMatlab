% apodize the input image in with a cosine edge mask over a length of N
% pixels
function [out,mask] = apodImRect3D(in,N)

Nx = min(size(in,1),size(in,2));
Nz = size(in,3);
x = abs(linspace(-Nx/2,Nx/2,Nx));
z = abs(linspace(-Nz/2,Nz/2,Nz));

map = x > Nx/2 - N(1);
mapz = z > Nz/2 - N(2);

val = mean(in(:));

d = (-abs(x)- mean(-abs(x(map)))).*map;
d = linmap(d,-pi/2,pi/2);
d(not(map)) = pi/2;
mask = (sin(d)+1)/2;

dz = (-abs(z)- mean(-abs(z(mapz)))).*mapz;
dz = linmap(dz,-pi/2,pi/2);
dz(not(mapz)) = pi/2;
maskz = (sin(dz)+1)/2;

% make it 2D
if size(in,1) > size(in,2)
    mask = mask.*imresize(mask',[size(in,1) 1],'bilinear');
elseif size(in,1) < size(in,2)
    mask = imresize(mask,[1 size(in,2)],'bilinear').*mask';
else
    mask = mask.*mask';
end

% mask it 3D
maskXY = repmat(mask,[1 1 Nz]);
temp = []; 
temp(1,1,:) = maskz;
maskZ = repmat(temp,[size(in,1) size(in,2) 1]);

mask = maskXY.*maskZ;
out = (in-val).*mask + val;