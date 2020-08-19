function [p,pts] = getProfile(im,pts,width)

%%
if nargin < 3; width = 1; end
if nargin < 2
f = figure(11);imagesc(im);colormap(hot)
    h = imline;
    position = wait(h); 
    pts.point1 = position(1,:); pts.point2 = position(2,:);
end

th = atan2d(pts.point2(2)-pts.point1(2),pts.point2(1)-pts.point1(1));

alpha = th;
x1 = pts.point1(1); y1 = pts.point1(2);
x2 = pts.point2(1); y2 = pts.point2(2);

off = ceil(0.4.*max(size(im,1),size(im,2)));
imR = padarray(im,[off off]);

A = pts.point1(:);
B = pts.point2(:);

sz = size(im)';
sz = sz(1:2);
A = A - sz./2;
B = B - sz./2;

M = [cosd(th) sind(th); -sind(th) cosd(th)];

A = M*A; B = M*B;


A = round(A + (sz./2+off));
B = round(B + (sz./2+off));

imR = imrotate(imR,th,'crop');

p = mean(imR(A(2)-ceil(width/2):A(2)+ceil(width/2),A(1):B(1)),1);

% figure(35);imagesc(im); hold on
% plot([pts.point1(1) pts.point2(1)],[pts.point1(2) pts.point2(2)],'w');
% 
% figure(36);imagesc(imR); hold on
% plot([A(1) B(1)],[A(2) B(2)],'w'); hold off