function [xx,yy,map] = getLocalEnergy(im,N,Nsub)

if nargin < 3; Nsub = 3; end

x0 = round(linspace(1,size(im,2)-N,Nsub));
y0 = round(linspace(1,size(im,1)-N,Nsub));
enMap = zeros(Nsub); eMap = enMap;
for xx = 1:numel(x0)
    for yy = 1:numel(y0)
        enMap(yy,xx) = mean(mean(im(y0(yy):y0(yy)+N,x0(xx):x0(xx)+N)));
        eMap(yy,xx) = entropy(im(y0(yy):y0(yy)+N,x0(xx):x0(xx)+N));
    end
end

eMap = 1./(eMap+1); eMap = eMap./max(eMap(:));
enMap = enMap./max(enMap(:));
map = eMap.*enMap;
% pick the lowest entropy location
[yy,xx] = ind2sub(size(map),find(map == max(map(:))));
xx = x0(xx); 
yy = y0(yy);