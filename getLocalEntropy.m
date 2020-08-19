function [xx,yy,map] = getLocalEntropy(im,N,Nsub)

if nargin < 3; Nsub = 3; end

x0 = round(linspace(1,size(im,2)-N,Nsub));
y0 = round(linspace(1,size(im,1)-N,Nsub));
map = zeros(Nsub);
for xx = 1:numel(x0)
    for yy = 1:numel(y0)
        map(yy,xx) = entropy(im(y0(yy):y0(yy)+N,x0(xx):x0(xx)+N));
    end
end

% pick the lowest entropy location
[yy,xx] = ind2sub(size(map),find(map == min(map(:))));
xx = x0(xx); 
yy = y0(yy);