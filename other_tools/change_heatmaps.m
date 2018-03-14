close all; clear all; clc;

addpath('../utils');
predpath = '../realworld/';

% 1 右前轮 
% 2 右后轮 
% 3 左前轮 
% 4 左后轮 
% 5 右前挡风 
% 6 左前挡风 
% 7 左后挡风 
% 8 右后挡风
% 9 右前灯 
% 10 左前灯
% 11 左后灯 
% 12 右后灯

ID = 6;
change_position = 6;
% read heatmaps and detect maximum responses
heatmap = h5read(sprintf('%svalid_%d.h5',predpath,ID), '/heatmaps');
heatmap_car = permute(heatmap(:, :, [46:57]),[2,1,3]);

figure
subplot(1,2,1);
imshow(heatmap_car(:,:,change_position));
temp = heatmap_car(:,:,change_position);
for i = 1:64
    for j = 1 : 64
        if temp(i,j) < 0.01
            temp(i,j) = 0;
        end
        heatmap_car(:,:,change_position) = 0;
    end
end

select_region = [17, 37, 28, 49];
length_x = (select_region(3)-select_region(1));
length_y = (select_region(4)-select_region(2));
center_x = 24;
center_y = 49;
temp_x = select_region(1);
temp_y = select_region(2);
for i = center_x-length_x : center_x
    for j = center_y-length_y : center_y
        heatmap_car(i,j, change_position) = temp(temp_x, temp_y) * 1;
        temp_y = temp_y +1;
    end
    temp_x = temp_x +1;
    temp_y = select_region(2);
end
subplot(1,2,2);
imshow(heatmap_car(:,:,change_position));
% find the coordinate and score of heatmap
[W_hp, score] = findWmax(heatmap_car);

img = imread(sprintf(strcat('../realworld/', num2str(ID), '.jpg')));
scale_file = h5read(strcat(predpath, 'valid.h5'), '/scale');
scale = scale_file(ID,1);
center_file = h5read(strcat(predpath, 'valid.h5'), '/center');
center = center_file(:,ID);

img_crop = cropImage(img,center,scale);

% process the heatmap and image
response = sum(heatmap_car,3);
max_value = max(max(response));
mapIm = imresize(mat2im(response, jet(100), [0 max_value]),[200,200],'nearest');
imToShow = mapIm*0.5 + (single(img_crop)/255)*0.5;

figure
subplot(2,2,1);
imshow(img);
hold on
rectangle('Position', [center(1)-200*scale/2, center(2)-200*scale/2, 200*scale, 200*scale], 'linewidth', 3, 'edgecolor', 'r');
subplot(2,2,2);
imshow(img_crop);
subplot(2,2,3);
imagesc(imToShow)
subplot(2,2,4)
imshow(response)

heatmap_car = permute(heatmap_car(:, :, [1:12]),[2,1,3]);
heatmap(:,:,46+change_position-1) = heatmap_car(:,:,change_position);

delete(sprintf('%svalid_%d_new.h5',predpath,ID));
h5create(sprintf('%svalid_%d_new.h5',predpath,ID), '/heatmaps',[64, 64, 102]);
h5write(sprintf('%svalid_%d_new.h5',predpath,ID), '/heatmaps', heatmap);