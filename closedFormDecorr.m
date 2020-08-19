% This function returns the closed form decorrelation of the input localization
% dataset (nm) data = [datax, datay] over the frequency range r (1/nm)
% Ng is the number of high-pass filtering steps
function dg = closedFormDecorr(data,r,Ng)


if size(data,2) ~= 2 
    error(['Incorrect input data size [',num2str(size(data)),']. Should be of the form [x, 2]'])
end
% splits the datasets in 2
Nloc = size(data,1);
data = data(randperm(Nloc,Nloc),:);
data1 = data(1:floor(end/2),:);
N = size(data1,1);
data2 = data(N+1:2*N,:);

r = r(2:end); % r = 0 will always lead to frc(1) = 1; save some computation

ms = round(linspace(1,N,11));
FOV = max(max(data(:,1))-min(data(:,1)),max(data(:,2))-min(data(:,2)));
sig(1) = FOV;
sig(2:Ng) = exp(linspace(log(FOV/100),log(2),Ng-1));
for h = 1:Ng
fprintf('Ng : %d; ',h);
v0 = 1:N; v0 = circshift(v0,-1,2);
g = 1 - exp(-2*sig(h)*sig(h)*(r).^2);
cc = zeros(3,numel(r),1,'like',data);
for m = 1:N-1
    % compute all correlations
	cc(1,:) = cc(1,:) + sum(besselj(1,sqrt(sum((data1(v0,:)-data2).^2,2))*r)./sqrt(sum((data1(v0,:)-data2).^2,2)),1).*g;
    cc(2,:) = cc(2,:) + sum(besselj(1,sqrt(sum((data1(v0,:)-data1).^2,2))*r)./sqrt(sum((data1(v0,:)-data1).^2,2)),1).*g;
    cc(3,:) = cc(3,:) + sum(besselj(1,sqrt(sum((data2(v0,:)-data2).^2,2))*r)./sqrt(sum((data2(v0,:)-data2).^2,2)),1);
    % circshift the index of one array
    v0 = circshift(v0,-1,2);
    if sum(m == ms)
        fprintf([num2str(100*(m-1)/N,3),','])
    end
end
fprintf('\n');
% gather from GPU
cc  = gather(cc);

% compute decorrelations from FRC rings
% simply integrate the correlations over a disk
for k = 1:numel(r)
    d(1,k+1) = sum(cc(1,1:k),2);
    d(2,k+1) = sum(cc(2,:),2);
    d(3,k+1) = sum(cc(3,1:k),2);
end
d = d(1,:)./sqrt(d(2,:).*d(3,:));
d(1) = 0;

dg(h,:) = d;
end