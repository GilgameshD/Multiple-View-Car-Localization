close all; clc; clear all;

writerObj = VideoWriter('../../video_output/clip1.mp4', 'MPEG-4'); 
writerObj.FrameRate = 15;
open(writerObj);

for i = 1 : 224
    file_num = int2str(i);
    fname = strcat('../../video_output/clip1/', file_num, '.jpg');
    adata = imread(fname);
    writeVideo(writerObj,adata);
    fprintf('This is frame [%d]\n', i);
end

close(writerObj);