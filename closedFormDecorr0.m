% This function returns the closed form decorrelation of the input localization
% dataset (nm) data = [datax, datay] over the frequency range r (1/nm)

function d = closedFormDecorr0(data,r)


if size(data,2) ~= 2 
    error(['Incorrect input data size [',num2str(size(data)),']. Should be of the form [x, 2]'])
end


r = r(2:end); % r = 0 will always lead to d(1) = 0; save some computation

% define Fourier space sampling grid in a list
R = []; TH = []; map = [];
dr = r(3)-r(2); % radial sampling step
nTh = zeros(numel(r),1); % number of angular sample
for k = 1:numel(r)
   if round(2*pi*r(k)/dr) == 0
       th = linspace(0,2*pi,5); th(end) = [];
       disp('Nth == 1!! Fourier sampling might be too coarse')
   else
       tmp = floor(round(2*pi*r(k)/dr)/4)*4; % closest multiple of 4 
      th = linspace(0,2*pi,tmp+1); th(end) = [];
   end
   nTh(k) = numel(th);
   R = cat(2,R,repmat(r(k),[1, numel(th)]));
   TH = cat(2,TH,th);
   map = cat(2,map,repmat(k,[1, numel(th)]));
end

gridPol = [R.*cos(TH); R.*sin(TH)];

% figure(34539);
% plot(0,0,'x'); hold on
% plot(gridCart(1,:),gridCart(2,:),'k.');hold off

% square sampling
% Nx = 2*numel(r)+1;
% gridCart = zeros(2,Nx^2,'like',data);
% r2 = (1:Nx)-1;[-r(end:-1:1),0, r];
% count = 1;
% for xx = 1:Nx
%    for yy = Nx:-1:1
%        gridCart(1:2,count) = [r2(xx) r2(yy)];
%        count = count +1;
%    end
% end


% Compute the exact Fourier transform of the image
% Ik = sum(exp(1i*2*pi.*(data(:,2)*gridCart(1,:) + ...
% data(:,1)*gridCart(2,:))/Nx),1); % Matlab definition of fft 
Ik = sum(exp(1i*2*pi.*(data(:,2)*gridPol(1,:) + data(:,1)*gridPol(2,:))),1); 

% % compute corresponding real space image
% cam = zeros(Nx,Nx);
% weight = cam;
% mapx = round(linmap(gridCart(1,:),0,size(cam,1)-1,1,size(cam,1)));
% mapy = round(linmap(gridCart(2,:),0,size(cam,1)-1,1,size(cam,1)));
% for k = 1:size(gridCart,2)
%    cam(mapx(k),mapy(k)) = cam(mapx(k),mapy(k)) + gather(Ik(k));
%    weight(mapx(k),mapy(k)) = weight(mapx(k),mapy(k)) + 1;
% end
% 
% figure(89);imagesc(abs(cam))
% figure(90);imagesc(angle(cam))
% t = real((ifftn((cam))));
% figure(199);imagesc(t)

% double integration over t and th
cc = zeros(3,numel(r),'like',data);
for k = numel(R):-1:1
    cc(1,map(k)) = cc(1,map(k)) + abs(Ik(k));%.*conj(Ik(k)/abs(Ik(k)));
    cc(2,map(k)) = cc(2,map(k)) + abs(Ik(k)).^2;
    cc(3,map(k)) = cc(3,map(k)) + 1;
end
cc = gather(cc);
cc = cumsum(cc,2);

d(1) = 0;
d(2:numel(r)+1) = cc(1,:)./sqrt(cc(2,end).*cc(3,:)); % 
