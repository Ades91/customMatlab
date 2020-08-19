function plotIm(x,y,logScale,figID)

if nargin < 4; figure; else; figure(figID); end
if nargin < 3; logScale = 0;end
if nargin < 2; y =x; x = 1:length(y);end


if logScale
    subplot(211)
        plot(x,log(abs(y)+1),'linewidth',2)
            hold on
        plot(x,angle(y),'linewidth',2)
            hold off
        legend('log(abs+1)','angle')
        xlim([min(x) max(x)])
    subplot(212)
        plot(x,real(y),'linewidth',2)
            hold on
        plot(x,imag(y),'linewidth',2)
            hold off
        legend('real','imag') 
        xlim([min(x) max(x)])
else
    subplot(211)
        plot(x,abs(y),'linewidth',2)
            hold on
        plot(x,angle(y),'linewidth',2)
            hold off
        legend('Abs','angle')
        xlim([min(x) max(x)])
    subplot(212)
        plot(x,real(y),'linewidth',2)
            hold on
        plot(x,imag(y),'linewidth',2)
            hold off
        legend('real','imag')
        xlim([min(x) max(x)])
end