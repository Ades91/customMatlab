function out = binIm(im,n)

[Ny,Nx] = size(im);
im2 = im(:);
temp = im2;
for k = 2:n
    temp = temp(1:end-k+1) + im2(k:end); 
    temp(end:Ny*Nx) = 0;
end
temp = reshape(temp,[Ny Nx])';

temp = temp(:);
im2 = temp;
for k = 2:n
    temp = temp(1:end-k+1) + im2(k:end);
    temp(end:Ny*Nx) = 0;
end

temp = reshape(temp,[Ny Nx])';

out = temp(1:n:end,1:n:end);