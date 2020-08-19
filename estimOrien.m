function or = estimOrien(im,tileSize,tileOverlap)
    
if nargin < 3; tileOverlap = 2; end
if nargin < 2; tileSize = 150; end

if tileSize >= min(size(im,1),size(im,2))
    tileSize = min(size(im,1),size(im,2))-1;
end

    px = ceil(linspace(1,size(im,2),ceil(size(im,2)/tileSize)));
    py = ceil(linspace(1,size(im,1),ceil(size(im,1)/tileSize)));

    an = linspace(-90,90,21); an(end) = [];
    or = zeros(length(py)-tileOverlap,length(px)-tileOverlap);
    proj = zeros(length(an),1);
    
    for k = 1:length(py)-tileOverlap
        for j = 1:length(px)-tileOverlap
            ref = im(py(k):py(k+tileOverlap)-1,px(j):px(j+tileOverlap)-1);
            padSize = round(size(ref,1)*(sqrt(2)-1)/2);
            ref = padarray(ref,[padSize padSize],0);
            for h = 1:length(an)
                proj(h) = max(sum(imrotate(ref,an(h),'bilinear','crop'),2));
            end
            [~,ind] = max(proj);
            or(k,j) = an(ind);
            % refinement
            if ind == 1
                an2 = linspace(-100,an(2),length(an));
                an2(an2 < -90) = an2(an2 < -90) + 180;
            elseif ind == length(an)
                an2 = linspace(an(end-1),100,length(an));
                an2(an2 > 90) = an2(an2 > 90) - 180;
            else
                an2 = linspace(an(ind-1),an(ind+1),length(an));
            end
            
            for h = 1:length(an2)
                proj(h) = max(sum(imrotate(ref,an2(h),'bilinear','crop'),2));
            end
            [~,ind] = max(proj);
            or(k,j) = an2(ind);
        end
    end
    
    
end