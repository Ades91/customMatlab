function [rgb,mask] = stack2rgb(data,lut,T)

lut = imresize(lut,[size(data,3) 3],'bilinear');
rgb = zeros(size(data,1),size(data,2),3,'double');
mask = zeros(size(data));
% temp_mask = ones(size(data,1),size(data,2));

k = 1;
    temp = data(:,:,k);
    temp = (linmap(double(temp),double(min(temp(:))),double(max(temp(:))),0,1));
    temp_mask = double(temp >= T*max(max(temp)));
    mask(:,:,k) = temp_mask;
    for j = 1:3
        rgb(:,:,j) = rgb(:,:,j) + mask(:,:,k).*temp.*lut(k,j); 
    end

for k = 2:size(data,3)
    temp = data(:,:,k);
    temp = (linmap(double(temp),double(min(temp(:))),double(max(temp(:))),0,3));
    temp_mask = not(sum(mask,3)).*double(temp >= T*max(max(temp)));
    mask(:,:,k) = temp_mask;
    for j = 1:3
        rgb(:,:,j) = rgb(:,:,j) + temp_mask.*temp.*lut(k,j); 
    end
end