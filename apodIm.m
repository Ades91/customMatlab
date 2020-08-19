% Author : Adrien Descloux (adrien.descloux@epfl.ch)
% basic function for 1d/2d/3d data apodisation
%
% function [out,mask] = apodIm(in,r,val,c)
% inputs :
%       in : input data stack
%       r : radius where apodisation starts [0,1]
%       val : offset of apodisation where "out = (in-val).*mask + val;"
%       c : apodisation strength in log scale
% outputs :
%       out : apodised input

function [out,mask] = apodIm(in,r,val,c)
if nargin < 4; c = 1.5; end
if nargin < 3; val = [];end
    
 
if length(size(in)) == 2 && sum(size(in) ==1) == 1 %% 1D data
    x = linspace(-1,1,length(in));
    mapL = x < -r; mapR = x > r;
    xL = linspace(-10^c,10^c,sum(mapL))';
    xR = linspace(10^c,-10^c,sum(mapR))';
    x = [xL; 10^c.*ones(sum(not(mapL|mapR)),1); xR];
    mask = (atan(x).*2/pi + 1)./2;
    
elseif length(size(in)) == 2 && sum(size(in) ==1) == 0 %% 2D data
    if size(in,1) == size(in,2)
        x = abs(linspace(-size(in,1)/2,size(in,1)/2,size(in,1)));
        map = x > size(in,1)/2 - r;
        if isempty(val)
            map2 = map2D(map); map2 = map2>0.1;
            val = mean(mean(in.*map2));
        end
        maxVal = tan(c);
        d = (-abs(x)- mean(-abs(x(map)))).*map;
        d = linmap(d,min(d),max(d),-pi/2,pi/2);
%         mask = map.*(atan(d).*2/pi + 1)./2;
        mask = (map.*sin(d)+1)/2;
        mask(not(map)) = max(mask);
        mask = map2D(mask);
    else
        if isempty(val)
            val = mean(in(:));
        end
        x = linspace(-1,1,size(in,2));
        mapL = x < -r; mapR = x > r;
        xL = linspace(-10^c,10^c,sum(mapL))';
        xR = linspace(10^c,-10^c,sum(mapR))';
        x = [xL; 10^c.*ones(sum(not(mapL|mapR)),1); xR];
        maskX = (atan(x).*2/pi + 1)./2;
        y = linspace(-1,1,size(in,1));
        mapL = y < -r; mapR = y > r;
        yL = linspace(-10^c,10^c,sum(mapL))';
        yR = linspace(10^c,-10^c,sum(mapR))';
        y = [yL; 10^c.*ones(sum(not(mapL|mapR)),1); yR];
        maskY = (atan(y).*2/pi + 1)./2;
        mask = maskY.*maskX';
        
    end
elseif length(size(in)) == 3 %% 3D data
    if length(r) == 1; r(2) = r; end
    if length(c) == 1; c(2) = c; end
    
    [x,~,z] = ndgrid(linspace(-1,1,size(in,1)),...
                     linspace(-1,1,size(in,2)),...
                     linspace(-1,1,size(in,3)));
    mapL = x < -r(1); mapR = x > r(1);
    xL = linspace(-10^c(1),10^c(1),sum(mapL(:,1,1)))';
    xR = linspace(10^c(1),-10^c(1),sum(mapR(:,1,1)))';
    x = [xL; 10^c(1).*ones(sum(not(mapL(:,1,1)|mapR(:,1,1))),1); xR];
    mask = (atan(x).*2/pi + 1)./2;
    mask3D = repmat(mask,[1 size(in,2) size(in,3)]);
    mask3D = mask3D.*permute(mask3D,[2 1 3]);

    mapL = z < -r(2); mapR = z > r(2);
    xL = linspace(-10^c(2),10^c(2),sum(mapL(1,1,:)))';
    xR = linspace(10^c(2),-10^c(2),sum(mapR(1,1,:)))';
    x = [xL; 10^c(2).*ones(sum(not(mapL(1,1,:)|mapR(1,1,:))),1); xR];
    mask = (atan(x).*2/pi + 1)./2;
    maskZ = repmat(permute(mask,[3 2 1]),[size(in,1) size(in,2) 1]);
    mask = mask3D.*maskZ;
    
end

out = (in-val).*mask + val;

end