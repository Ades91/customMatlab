% Compute a sequential maxProjection where the first/last plane is prefered
% Improved quality of maxProj for crowded images

function maxProj(data)

[nx,ny,nz] = size(data);

lut = jet;
lut = imresize(lut,[nz,3],'bilinear');

% parameters definition
% data are in uint16 format
data = uint16(data);
id = 1;

c_im = data(:,:,id); % current image
t_im = zeros(nx,ny,nz,'uint16');
o_im = t_im;

t_im(:,:,id) = c_im.*uint16(c_im>round(mean(mean(c_im)))); % temporary image

%% create figure and widgets
if nargin == 1
f = figure('visible','off','position',[360 500 400 285],'WindowScrollWheelFcn',@figScroll);
else
try close(figID);end
f = figure(figID);
set(f,'visible','off','position',[360 500 400 285],'WindowScrollWheelFcn',@figScroll);
end

ha = axes('Units','pixels','Position',[50,60,260,185]);
rgb = stack2rbg(t_im,lut);
him = image(rgb); colorbar

dmin = min(min(c_im))
dmax = max(max(c_im))


set(f,'name',inputname(1))

hslide = uicontrol('style','slider','String','z',...
            'position',[330 30 30 200],...
            'Callback',{@slider_Callback});
set(hslide,'Min',dmin);set(hslide,'Max',dmax);
set(hslide,'value',dmax/2-dmin/2);
% set(hslide,'SliderStep',[0.05 0.05]);
addlistener(hslide,'Value','PreSet',@slider_Callback);

hnext = uicontrol('style','pushbutton','String','Next slice',...
                'position',[330 250 30 30],...
                'Callback',@next);

set(f,'toolbar','figure');
set(f,'Units','normalized');
set(ha,'Units','normalized');
set(hslide,'Units','normalized');
set(hnext,'Units','normalized');


set(f,'position',[0.0891    0.3417    0.3885    0.5037]);
set(f,'Visible','on');

h.data = data;
h.id = id;
h.c_im = c_im;
h.t_im = t_im;
h.o_im = o_im;

h.im = him;
h.slide = hslide;
% h.edit = hedit;
h.lut = lut;
h.f = f;

guidata(f,h)
end

function drawIm()
h = guidata(gcf);
val = get(h.slide,'value');
h.t_im(:,:,h.id) = uint16(not(sum(h.o_im,3))).*h.c_im.*uint16(h.c_im>val); % temporary image

rgb = stack2rbg(h.t_im,h.lut);
set(h.im,'Cdata',rgb)

guidata(h.f,h);
end


function next(src,e)
h = guidata(gcf);
h.o_im = h.t_im;
h.id = h.id +1;
if h.id > size(h.data,3)
    % save data
    % close figure
end
h.c_im = h.data(:,:,h.id);
drawIm();
plotStack(h.o_im)
pause(1)
guidata(h.f,h)
end

function slider_Callback(src,e)
h = guidata(gcf);
val = get(h.slide,'value')
drawIm();
end

function figScroll(source,event)

dir = event.VerticalScrollCount;

h = guidata(gcf);
val = get(h.slide,'value');


val = val - dir.*256;

set(h.slide,'value',val);
slider_Callback(source,event);

end

function rgb = stack2rbg(data,lut)
rgb = zeros(size(data,1),size(data,2),3,'uint16');
for k = 1:size(data,3)
    temp = data(:,:,k);
    temp = uint16(linmap(double(temp),double(min(temp(:))),double(max(temp(:))),0,2^16-1));
    for j = 1:3
        rgb(:,:,j) = rgb(:,:,j) + temp.*lut(k,j); 
    end
end



end