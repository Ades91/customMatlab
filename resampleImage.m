function out = resampleImage(im,off)

im = double(im(1:end-not(mod(size(im,1),2)),1:end-not(mod(size(im,2),2)),:));
Ik = fftshift(fftn(im));
Ik = Ik(off:end-off,off:end-off,:);

out=  real(ifftn(ifftshift(Ik)));