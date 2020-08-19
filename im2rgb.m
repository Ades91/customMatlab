function out = im2rgb(data,cmap)
    data = round(linmap(data,1,256));
    cmap = imresize(cmap,[256 3]);
    out(:,:,1) =  reshape(cmap(data(:),1),size(data));
    out(:,:,2) =  reshape(cmap(data(:),2),size(data));
    out(:,:,3) =  reshape(cmap(data(:),3),size(data));
end