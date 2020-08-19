% display the log of fourier transform of an image
function imagescf(im,figID)


Ik = fftshift(fftn(fftshift(apodImRect(double(im),20))));
if nargin == 1
    figure;
else
    figure(figID);
end

imagesc(log(abs(Ik)+1));colorbar