% map a kz,klat 2D CTF into its kx,ky,kz 3D counterpart

function out = map3D(in)

[Nz,Nx] = size(in);

temp_x = linspace(-1,1,Nx);temp_z = linspace(-1,1,Nz);
[tX,tY] = meshgrid(temp_x,temp_x);
r = sqrt(tX.^2 + tY.^2);
r(r > max(temp_x)) = max(temp_x);

mapr = (r-min(temp_x))./(max(temp_x)-min(temp_x)).*(length(temp_x)-2);
mapf = floor(mapr)+1; mapc = ceil(mapr)+1;
p = mapc-mapr-1;

out = zeros(length(temp_x),length(temp_x),length(temp_z),class(in));
for kk = 1:length(temp_z)
    
    CTF1D = in(kk,:);      % extract the 1D psf
    tempf = CTF1D(mapf);          % map the 1D psf on a polar grid
    tempc = CTF1D(mapc);          % map the 1D psf on a polar grid
        
    % local linear interpolation 
    temp     = p.*tempf + (1-p).*tempc;
    
    out(:,:,kk) = temp;        % store the 2D psf
end



end
