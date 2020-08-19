function [dx,dy] = getSMLMdrift(data,Nfr,pps0,FOV)

if size(data,1) == 2
    data = data';
end

% compute polar Fourier space
Nr = 50;
kr = linspace(0,1/pps0,Nr); dkr = kr(2)-kr(1);
r = linspace(0,FOV,Nr);
rmap = []; R = []; TH = []; KX = []; KY = []; XX = []; YY = [];
for kkr = 1:Nr
    nTh = 2*pi*kr(kkr)/dkr;
    nTh = 4.*floor(nTh/4);
    if nTh == 0; nTh = 1; end
    th = linspace(0,2*pi,nTh+1);
    for kth = 1:numel(th)-1
       rmap = [rmap, kkr];
       R = [R, kr(kkr)];
       TH = [TH, th(kth)];
       KX = [KX, kr(kkr).*cos(th(kth))];
       KY = [KY, kr(kkr).*sin(th(kth))];
       XX = [XX, r(kkr).*cos(th(kth))];
       YY = [YY, r(kkr).*sin(th(kth))];
    end
end

% rearange data
nfr = floor(linspace(1,size(data,1),Nfr+1)); nfr(1) = 0;
xx = zeros(max(diff(nfr)),Nfr); yy = xx;
for k = 1:Nfr
   xx(1:(nfr(k+1)-nfr(k)),k) =  data(nfr(k)+1:nfr(k+1),1);
   yy(1:(nfr(k+1)-nfr(k)),k) =  data(nfr(k)+1:nfr(k+1),2);
end

% compute data Fourier transform
Ik = zeros(numel(R),Nfr);
for k = 1:numel(R)
    Ik(k,:) = sum(exp(-2*pi*1i.*(KX(k).*xx + KY(k).*yy)),1);
end

figure(235432);
nrm = max(abs(Ik(:,1)));
tx = round(linmap(KX,1,101));
ty = round(linmap(KY,1,101));
im = zeros(101);
for k = 1:numel(R)
im(ty(k),tx(k)) =  angle(Ik(k,1));
end
figure(345);imagesc(im)
% Fourier normalization
Ik = Ik./abs(Ik);
% compute cross-correlation
cc = zeros(numel(R),Nfr-1);
for k = 1:Nfr-1
    cc(:,k) = Ik(:,k).*conj(Ik(:,k+1));
end

% inverse Fourier transform
xy = zeros(numel(R),Nfr-1);
for k = 1:numel(R)
    xy(k,:) = real(sum(cc.*exp(1i.*(KX(k).*XX(k) + KY(k).*XX(k))),1));
end

[~,ind] = max(xy);
dx = XX(ind);
dy = YY(ind);