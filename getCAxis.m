function [cmin,cmax] = getCAxis(im,N,Nsub)

if nargin < 3; Nsub = 9; end
Nsubsqrt = floor(sqrt(Nsub));
x0 = round(linspace(1,size(im,2)-N,Nsubsqrt));
y0 = round(linspace(1,size(im,1)-N,Nsubsqrt));
for xx = 1:numel(x0)
    for yy = 1:numel(y0)
        n = yy + Nsubsqrt*xx;
        cmin(n) = min(min(im(y0(yy):y0(yy)+N,x0(xx):x0(xx)+N)));
        cmax(n) = max(max(im(y0(yy):y0(yy)+N,x0(xx):x0(xx)+N)));
    end
end

cmin = mean(cmin);
cmax = mean(cmax);