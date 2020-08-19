function p = getNProfile(im,N)

%% 
p =[];
for k = 1:N
    p{k} = getProfile(im);
end
%% coalign profiles using xcorr
% figure(432)
cc = [];
pt = p;
for k = 1:numel(pt)-1
    [cc{k},lag]= xcorr(pt{k},pt{k+1});
    cc{k} = cc{k}./max(cc{k});
    [~,ind] = max(cc{k});
    shift(k) = lag(ind);
    pt{k+1} = imtranslate(pt{k+1},[shift(k) 0]);
%     plot(double(pt{k})+255*k); hold on
end
% hold off
%%
lmax = 0;
for k = 1:numel(pt)
    lmax = max(lmax,length(pt{k}));
end
temp = zeros(lmax,N);
for k = 1:numel(pt)
    temp(:,k) = padarray(pt{k},[0 lmax-length(pt{k})],0,'post');
end
p = temp;
