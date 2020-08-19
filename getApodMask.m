function mask = getApodMask(dim,r0,r1)

[x,y] = meshgrid(linspace(-1,1,dim(1)),linspace(-1,1,dim(2)));
r = sqrt(x.^2 + y.^2);

mask = r.*(r > r0 & r < r1);

mask = cos(linmap(mask,min(mask(mask>0)),max(mask(:)),0,pi/2));
mask = mask.*(r < r1);