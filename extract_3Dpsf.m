
% data : 3D array containing sparse localized peak
% ROI  : half size of the extracted psf [pixels]
% N    : number of psf that will be extracted
function [psf,avrg_psf] = extract_3Dpsf(data,ROI,N)

% zero-pad the data
data = padarray(data,ROI);

% [nx,ny,nz] = size(data);
psf = cell(N,1);
for k = 1:N
% locate the first max position
[~,ind] = max(data(:));
[cy,cx,cz] = ind2sub(size(data),ind);

% extract the psf
psf{k} = data(cy-ROI(2):cy+ROI(2),cx-ROI(1):cx+ROI(1),cz-ROI(3):cz+ROI(3));
% clear the central area from the data set
data(cy-ROI(2):cy+ROI(2),cx-ROI(1):cx+ROI(1),cz-ROI(3):cz+ROI(3)) = ...
    data(cy-ROI(2):cy+ROI(2),cx-ROI(1):cx+ROI(1),cz-ROI(3):cz+ROI(3))./200;
end

avrg_psf = psf{1};
for k = 2:N
%     plotStack(psf{k})
    avrg_psf = avrg_psf + psf{k};
end
avrg_psf = avrg_psf./length(psf);

% plotStack(avrg_psf)