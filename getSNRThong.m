% SNR = getSNRThong(im)
% This code is based on Thong2001_Single-Image Signal-to-Noise Ratio Estimation
function SNR = getSNRThong(im)

%% compute autocorelation around the center
cc = zeros(3);
w = 3;
for x = 1:2*w-1
    for y = 1:2*w-1
        temp = imtranslate(im,[x-w y-w]);
        cc(y,x) = mean(im(:).*temp(:));
    end
end

% Noise free cc estimation
ccNF = mean([cc(w,1) cc(1,w) cc(w,end) cc(end,w)]);

m = mean(im(:));
sig = std(im(:));

rho = (ccNF - m^2)/sig^2;
SNR = rho/(1-rho);