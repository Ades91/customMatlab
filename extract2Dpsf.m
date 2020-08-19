function [psf,psfAv] = extract2Dpsf(im,r,N)

x = linspace(-1,1,2*r+1);
[X,Y] = meshgrid(x);
mask = X.^2 + Y.^2 < 1;

temp = im;
k = 0;
while k < N
    [~,ind] = max(temp(:));
    [cy,cx] = ind2sub(size(temp),ind);
    if cy > r && cy < size(im,1)-r && cx > r && cx < size(im,2)-r
        k = k+1;
        psf(:,:,k) = temp(cy-r:cy+r,cx-r:cx+r);
        temp(cy-r:cy+r,cx-r:cx+r) = temp(cy-r:cy+r,cx-r:cx+r).*not(mask);
    else
        cx = clamp(cx,1,size(im,2));
        cy = clamp(cy,1,size(im,1));
        temp(cy:cy,cx:cx) = 0;
    end
    
end

psfAv = mean(psf,3);