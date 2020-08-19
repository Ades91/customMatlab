function cc = getCorrcoef(I1,I2,c1,c2)

% I1 and I2 should have zero mean
if nargin < 4
    c2 = sqrt(sum(sum(abs(I2).^2)));
end
if nargin < 3
	c1 = sqrt(sum(sum(abs(I1).^2)));
end

% N = (numel(I1)-1);
cc = real(sum(sum(I1.*conj(I2))))/((c1*c2));