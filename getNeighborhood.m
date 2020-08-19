% return a nxn neighborhood of pixel in(ind(2),ind(1)) following the border
% condition : '0', 'avrg', 'periodic', 'mirrored'
function out = getNeighborhood(in,ind,n,border)

if nargin < 4; border = 'avrg'; end
if nargin < 3; n = 3; end % return [3x3] neighborhood

if ~mod(n,2)
   n=n+1;
end
    
[Ny,Nx] = size(in);
off = (n-1)/2;

x0 = ind(2)-off; x1 = ind(2)+off;
y0 = ind(1)-off; y1 = ind(1)+off;

if (x0 > 0 && x1 <= Nx && y0 > 0 && y1 <= Ny) % 
    out = in(y0:y1,x0:x1);
else
    if strcmp(border,'0')
        temp = padarray(in,[n n],0);
        out = temp(x0+n:x1+n,y0+n:y1+n);
    elseif strcmp(border,'avrg')
        out = NaN(n);
        for x = 1:n
            for y = 1:n
                try 
                   out(y,x) = in(y0+y-1,x0+x-1);
                end
            end
        end
        out(isnan(out)) = nanmean(out(:));
    elseif strcmp(border,'periodic')
        x = x0:x1; y = y0:y1;
        x = mod(x,Nx); y = mod(y,Ny);
        x(x==0) = Nx; y(y==0) = Ny;
        out = in(y,x);
    elseif strcmp(border,'mirrored')
        temp = padarray(in,[n n],'symmetric');
        out = temp(x0+n:x1+n,y0+n:y1+n);
    else
        disp('Error : Could not find requested method !')
        disp('Available methods are : ''0'', ''avrg'', ''periodic'', ''mirrored'' ')
    end
end
