% this file can be used to draw a 1*2 image to show the result of CNN
% output

close all; clc; clear all;

predpath = './paper_CNNoutput/exp/';
annotation_path = './paper_CNNoutput/annot/valid.h5';

ID = 15;

% read heatmaps and detect maximum responses
heatmap = h5read(sprintf('%svalid_%d.h5',predpath,ID), '/heatmaps');
heatmap = permute(heatmap(:,:,[46:57]),[2,1,3]);

% find the coordinate and score of heatmap
[W_hp, score] = findWmax(heatmap);
img = imread(sprintf(sprintf('./paper_CNNoutput/images/%d.jpg', ID)));
scale_file = h5read(annotation_path, '/scale');
scale = scale_file(ID,1);
center_file = h5read(annotation_path, '/center');
center = center_file(:,ID);

img_crop = cropImage(img,center,scale);

% process the heatmap and image
response = sum(heatmap,3);
max_value = max(max(response));
mapIm = imresize(mat2im(response, jet(100), [0 max_value]),[200,200],'nearest');
imToShow = mapIm*0.5 + (single(img_crop)/255)*0.5;

figure('position',[300,300,2*300,300]);
subplot('position',[0 0 1/2 1]); 
imshow(img_crop);
subplot('position',[1/2 0 1/2 1]); 
imagesc(imToShow)
%imshow(response)