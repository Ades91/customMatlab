function an = ccrRotEstimation(imRef,im,Na,Amax)
if nargin < 4; Amax = 10; end % default angle range
if nargin < 3; Na = 21; end % default number of angles

% circular mask to ignore edges
[X,Y] = meshgrid(linspace(-1,1,size(imRef,2)),linspace(-1,1,size(imRef,1)));
mask = sqrt(X.^2 + Y.^2) < 0.95;

% set images means equal to 0 to avoid biais
imRef = mask.*(imRef - mean(imRef(mask)));
im = mask.*(im - mean(im(mask)));

% the absolute Fourier transform is translation invariant
IkRef = abs(fftshift(fftn(imRef)));
Ik = abs(fftshift(fftn(im)));

% correlate the absolute Fourier transform as a function of angle
an = linspace(-Amax,Amax,Na);
cc = zeros(Na,1);
for k = 1:length(an)
   cc(k) = sum(sum(mask.*IkRef.*imrotate(Ik,an(k),'crop')));
end

% look for the angle of maximum correlations
[~,ind] = max(cc);
an = an(ind);