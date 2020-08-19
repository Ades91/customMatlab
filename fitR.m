% fit line to r-rcor data
function [rx,ry] = fitR(r,rcor,pval,figID)
if nargin < 3; figID = 0;end


ft = fittype('-a.*x +a');


[f,goodness] = fit(r(round(0.8*length(r)):end).^2,rcor(round(0.8*length(r)):end).^2,ft,'StartPoint',[0.01]);
goodness.rmse
f.a
% compute the distance between the curve and the fit
% d = abs(f.a.*r.^2 + rcor.^2 - f.a)./(f.a^2 +1);
d = rcor.^2-(-f.a.*r.^2+f.a);
p = exp(-d./f.a); % probability that the point belongs to the fit

ind = find(p > 1-pval);
ind(1);
res = r(ind(1)).^2

if figID
figure(figID);
plot(r.^2,rcor.^2);hold on
plot(r.^2,-f.a.*r.^2+f.a); 
plot(r.^2,rcor.^2-(-f.a.*r.^2+f.a));
plot([res res],[0 max(rcor.^2)])

hold off
end