function [rgb,w] = normProj(data,lut,T)

[nx,ny,nz] = size(data);

lut = imresize(lut,[nz 3],'bilinear');

rgb = zeros(nx,ny,3,'double');
w = zeros(size(data));



[b,map] = sort(data,3,'descend');

mask = zeros(nx,ny,nz); % look at the axial energy distribution
eTot = sum(b,3);
for k = 1:12
   mask(:,:,k) = sum(b(:,:,1:k),3) <= T.*eTot;
   temp  = mask(:,:,k);
   tb = b(:,:,k);
   temp(temp == 1) = tb(temp == 1);
   mask(:,:,k) = temp;
end

for xx = 1:nx
    for yy = 1:ny     
        w(xx,yy,:) = mask(xx,yy,map(xx,yy,:));
    end
end

w = w./repmat(sum(w,3),[1 1 nz]);

for k = 1:nz
    temp = w(:,:,k).*(data(:,:,k).^T);
    temp = double(linmap(double(temp),double(min(temp(:))),double(max(temp(:))),0,1));
    for j = 1:3
        rgb(:,:,j) = rgb(:,:,j) + temp.*lut(k,j); 
    end
end
