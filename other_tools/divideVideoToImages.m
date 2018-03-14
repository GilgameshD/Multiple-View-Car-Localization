close all; clc; clear all;

fileName_1 = '../../video_clips/l0.mp4'; 
fileName_2 = '../../video_clips/z0.mp4'; 

obj_1 = VideoReader(fileName_1);
numFrames_1 = obj_1.NumberOfFrames;
obj_2 = VideoReader(fileName_2);
numFrames_2 = obj_2.NumberOfFrames;
image_count = 1;
steps = 2;

fprintf('There are [%d] frames to be saved\n', numFrames_2)
 for k = 1 : steps : numFrames_1
     
     frame_1 = read(obj_1, k);
     frame_2 = read(obj_2, k);
     %imshow(frame);
     imwrite(frame_1, strcat('../../video_clips/l0/', num2str(image_count),'.jpg'),'jpg');
     imwrite(frame_2, strcat('../../video_clips/z0/', num2str(image_count),'.jpg'),'jpg');
     image_count = image_count + 1;
     fprintf('finish one frame [%d] \n', k);
end