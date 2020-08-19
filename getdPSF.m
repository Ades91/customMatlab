function [dPSF,F,cam] = getdPSF(psf,nPhotons,display)

if nargin < 3; display = 0; end
if nargin < 2; nPhotons = 5000; end

psf = abs(psf); % real-positivity constrain

% normalize
psf = psf./sum(psf(:));
% compute the discrete pdf
[pdf,map] = sort(cumsum(psf(:)));

% define the output matrix
dPSF = zeros(size(psf));

tempMap = 10:50:nPhotons;
cam = zeros(length(dPSF),length(dPSF));
for k = 1:nPhotons
    
    % solve the 2D inverse stochatic distribution problem
    a = rand;
    [~,temp] = min(abs(pdf-a));
    [y,x] = ind2sub(size(psf),map(temp));
    dPSF(y,x) = dPSF(y,x)+1;
    if sum(k == tempMap)
       % snapshot
       cam(:,:,end+1) = dPSF./max(dPSF(:));
    end
end
cam(:,:,end+1) = psf./max(psf(:));

temp = dPSF./sum(dPSF(:));
% F = corr2(psf,temp);
F = 1;

if display 
   figure(display)
   subplot(221)
    imagesc(psf)
    title('Input probability function')
   subplot(222)
    imagesc(dPSF)
    title('Stochasticly discretized version')
end