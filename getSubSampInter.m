function int = getSubSampInter(f,v,x)

if nargin < 3
    x = 1:length(f);
end
order = 1;
if length(f) ~= length(x)
    int = 0;
else
    ind = find(f-v < 0);
    if ind == 1
        int = x(1);
    elseif ind == length(f)
        int = x(end);
    else
        ind = ind(1)-1;
        % linear interpolation
        x2 = x(ind:ind+1)';
        f2 = f(ind:ind+1)';
        M = [];
        for k = order:-1:0
            M = [M, x2.^k];
        end
        coef = M\f2;
        if numel(coef) == 2
            int = (v-coef(2))/coef(1);
        else
            int = (-coef(2) + sqrt(coef(2).^2-4*coef(1)*(coef(3)-v)))/(2*coef(1));
        end
%         figure(34256);
%         plot(x2,f2); hold on;
%         x3 = linspace(x2(1),x2(3),100);
%         f3 = zeros(1,numel(x3));
%         for k = 1:numel(coef)
%             f3 = f3 + coef(k).*x3.^(numel(coef)-k);
%         end
%         plot(x3,f3);
%         plot([int int],[min(f3) max(f3)],'--k')
%         hold off
    end
end
    
