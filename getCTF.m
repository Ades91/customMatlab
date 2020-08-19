function ctf = getCTF(stack,N,sub)

[Nx,Ny,Nz] = size(stack);

if nargin <3; sub = floor([0.8*Nx,0.8*Ny,0.8*Nz]); end
if nargin < 2; N = 10;end

% create a list of all possible subROI
try dx = 1:10:Nx-sub(1); catch; dx = 1; end
try dy = 1:10:Ny-sub(2); catch; dy = 1; end
try dz = 1:10:Nz-sub(3); catch; dz = 1; end
if isempty(dz); dz =1;end

positions = zeros(3,length(dx)*length(dy)*length(dz));
count = 1;
for a = 1:length(dx)
    for b = 1:length(dy)
        for c = 1:length(dz)
            positions(1,count) = dx(a);
            positions(2,count) = dy(b);
            positions(3,count) = dz(c);
            count = count +1;
        end
    end
end

% suffle the positions 
randLoc = positions(:,randperm(size(positions,2)));

temp = zeros(sub);
ctf = temp;
for k = 1:N
    loc = randLoc(:,k);
    subStack = stack(loc(1):loc(1)+sub(1)-1,loc(2):loc(2)+sub(2)-1,loc(3):loc(3)+sub(3)-1);
    subStack = subStack - mean(subStack(:));
    
    subStack(end+1:2*end,:,:) = subStack(end:-1:1,:,:);
    subStack(:,end+1:2*end,:) = subStack(:,end:-1:1,:);
    subStack(:,:,end+1:2*end) = subStack(:,:,end:-1:1);
    
    temp = fftshift(fftn(fftshift(subStack)));
    ctf = ctf + abs(temp(sub(1)-floor(sub(1)/2)+1:sub(1)+ceil(sub(1)/2),...
                     sub(2)-floor(sub(2)/2)+1:sub(2)+ceil(sub(2)/2),...
                     sub(3)-floor(sub(3)/2)+1:sub(3)+ceil(sub(3)/2)));
end
