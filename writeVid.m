% save the data as in a video format
% Example : 
% writeVid('test.avi',rand(256,256,10),1);

function writeVid(filename,data,fps)


v = VideoWriter(filename,'Uncompressed AVI');
v.FrameRate = fps;
% set(v,'VideoFormat','Mono16');

% convert data to uint
data = ((linmap(data,min(data(:)),max(data(:)),0,1)));
open(v)
for k = 1:size(data,3)
    writeVideo(v,(data(:,:,k)))
end
close(v)