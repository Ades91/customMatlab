% coregister a 3D stack based on plane-to-plane phase
% cross-correlation
function [out,dx,dy] = coregStack(stack)

Nz = size(stack,3);
out(:,:,1) = stack(:,:,1); % first slice 
dx = zeros(Nz,1); dy = zeros(Nz,1);
for k = 1:Nz-1
    imRef = stack(:,:,k);
    imMov = stack(:,:,k+1);
    [dx(k+1),dy(k+1)] = ccrShiftEstimation(imRef,imMov,5);
end

dx = cumsum(dx);
dy = cumsum(dy);

for k = 2:Nz
    out(:,:,k) = imtranslate(stack(:,:,k),[dx(k),dy(k)]);
end