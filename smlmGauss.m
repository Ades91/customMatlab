
function [im,pps] = smlmGauss(data,pps,FOV,sig)
% input handling
if nargin < 3
FOVx = max(data(:,1));
FOVy = max(data(:,2));
else
    FOVx = FOV;
    if numel(FOV) == 1
        FOVy = FOV;
    else
        FOVy = FOV(2);
    end
end

% compute the number of pixels in the image
Nx = ceil(FOVx/pps);
Ny = ceil(FOVy/pps);
% if FOV is not a integer multiple of pps, adapt the pixel size
pps = FOVx/Nx;
FOVy = pps*Ny;

% map data in image space
data(:,1) = linmap(data(:,1),0,FOVx,1,Nx);
data(:,2) = linmap(data(:,2),0,FOVy,1,Ny);
% filter data out of the range [0, FOV]
x0 = floor(data(:,1)); y0 = floor(data(:,2));
map = x0 < Nx & x0 > 0 & y0 < Ny & y0 > 0;
x0 = x0(map); y0 = y0(map);
% rendering loop
im = zeros(Ny,Nx);
for k = 1:size(y0,1)
    im(y0(k),x0(k)) = im(y0(k),x0(k)) +1;
end
g = fspecial('gaussian',ceil(2.2*6*sig/pps),sig/pps);g = g./max(g(:));
im = conv2(im,g,'same');
