predpath = './pose-hg/pose-hg-demo/exp/webots/';
annotation_path = './pose-hg/pose-hg-demo/data/webots/annot/valid.h5';

ID = 5;
% read heatmaps and detect maximum responses
heatmap = h5read(sprintf('%svalid_%d.h5',predpath,ID), '/heatmaps');
heatmap = permute(heatmap(:, :, [1:12]),[2,1,3]);

% find the coordinate and score of heatmap
[W_hp, score] = findWmax(heatmap);

img = imread(sprintf('./pose-hg/pose-hg-demo/data/webots/images/5.png'));
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