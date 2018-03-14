clear all; clc; close all;

imagenet_car_image_path = './data/car_imagenet/images/';
imagenet_annotation_path = './data/PASCAL3D/Annotations/car_imagenet/';

dir_output = dir(imagenet_car_image_path);
filename = {dir_output.name}';

fid = fopen('./data/car_imagenet/annot/train_images.txt', 'a');

for i = 3 : 5477
    fprintf(fid, filename{i});
    fprintf(fid, '\n');
end