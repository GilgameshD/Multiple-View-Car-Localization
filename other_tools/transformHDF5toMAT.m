clear all; clc; close all;

annotation_path = './pose-hg/pose-hg-demo/data/webots/annot/';
object_number = 10;
car_indices = 46:57;

% read heatmaps and detect maximum responses
center = h5read(sprintf('%svalid.h5',annotation_path), '/center');
center = center';
scale = h5read(sprintf('%svalid.h5',annotation_path), '/scale');
class = cell(object_number,1);
class_ID = cell(object_number,1);
imgname = cell(object_number,1);
indices = cell(object_number,1);
cad_index = zeros(object_number,1);

for i = 1 : object_number
    class{i} = 'car';
    classID{i} = 7;
    imgname{i} = strcat(num2str(i), '.png');
    indices{i} = car_indices;
    cad_index(i) = 3;
end

annot.center = center;
annot.scale = scale;
annot.class = class;
annot.classID = classID;
annot.imgname = imgname;
annot.indices = indices;
annot.cad_index = cad_index;

save_path = sprintf('%svalid.mat', annotation_path);
save(save_path, 'annot');








