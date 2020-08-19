% This function returns the closed form FRC of the input localization
% dataset (nm) data = [datax, datay] over the frequency range r (1/nm)
% Inspired from the work from User
% CLOSED-FORM EXPRESSION OF THE FOURIER RING-CORRELATION FORSINGLE-MOLECULE LOCALIZATION MICROSCOPY

function frc = closedFormFRC(data,r)


if size(data,2) ~= 2 
    error(['Incorrect input data size [',num2str(size(data)),']. Should be of the form [x, 2]'])
end
Nloc = size(data,1);
data = data(randperm(Nloc,Nloc),:);
data1 = data(1:floor(end/2),:);
data2 = data(size(data1,1)+1:2*size(data1,1),:);
N = size(data1,1);

r = r(2:end); % r = 0 will always lead to frc(1) = 1; save some computation

ms = round(linspace(1,N,11));
v0 = 1:N;
cc = zeros(3,numel(r),1,'like',data);
for m = 1:N-1
    % compute all correlations
	cc(1,:) = cc(1,:) + sum(besselj(0,sqrt(sum((data1(v0,:)-data2).^2,2))*r),1);
    cc(2,:) = cc(2,:) + sum(besselj(0,sqrt(sum((data1(v0,:)-data1).^2,2))*r),1);
    cc(3,:) = cc(3,:) + sum(besselj(0,sqrt(sum((data2(v0,:)-data2).^2,2))*r),1);
    % circshift the index of one array
    v0 = circshift(v0,-1,2);
    if sum(m == ms)
        fprintf([num2str(100*(m-1)/N,3),','])
    end
end
fprintf('\n');

% gather from GPU
cc  = gather(cc);
% compute frc from the correlations
frc = 1;
cc  = gather(cc);
% frc(2:numel(r)+1) = gather(cc./sqrt(c1.*c2));
frc(1,2:numel(r)+1) = cc(1,:)./sqrt(cc(2,:).*cc(3,:));
