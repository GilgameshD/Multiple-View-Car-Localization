clear all; clc; close all;

pascal_annotation_path = './data/PASCAL3D/Annotations/car_imagenet/';
write_dataset_path = './data/car_imagenet/annot/';
hdf5_name = strcat(write_dataset_path, 'train.h5');

count = 1;
sequence_length = 5475;
numebr_of_part = 12;

delete(hdf5_name)
h5create(hdf5_name, '/center',[2, sequence_length]);
h5create(hdf5_name, '/part', [2,12,sequence_length]);
h5create(hdf5_name, '/scale', sequence_length);

% claim some vars
all_centers = double(zeros(sequence_length,2));
all_parts = double(zeros(2, 12, sequence_length));
all_scales = double(zeros(sequence_length,1));

all_file_name = importdata(strcat(write_dataset_path, 'train_images.txt'));

for file_name_number = 1 : sequence_length
    current_name = all_file_name{file_name_number};
    anno_file_name = strcat(pascal_annotation_path, current_name, '.mat');
    load(anno_file_name);
    
    % select one car part from the objects
    car_number = 1;
    [~, all_part_number] = size(record.objects);
    for all_part_i = 1 : all_part_number
       if strcmp(record.objects(all_part_i).class, 'car')
           car_number = all_part_i;
       end
    end

    % get attrbution from .mat file
    % centers
    center_x = (record.objects(car_number).bbox(1) + record.objects(car_number).bbox(3))/2;
    center_y = (record.objects(car_number).bbox(2) + record.objects(car_number).bbox(4))/2;
    all_centers(count,:) = [center_x, center_y];
    % scales
    scale = max(record.objects(car_number).bbox(3)-record.objects(car_number).bbox(1), record.objects(car_number).bbox(4)-record.objects(car_number).bbox(2))/200;
    all_scales(count) = scale;
    % parts
    all_parts(:,1,count) = judge_empty_part(record.objects(car_number).anchors.left_front_wheel.location);
    all_parts(:,2,count) = judge_empty_part(record.objects(car_number).anchors.right_front_wheel.location);
    all_parts(:,3,count) = judge_empty_part(record.objects(car_number).anchors.left_back_wheel.location);
    all_parts(:,4,count) = judge_empty_part(record.objects(car_number).anchors.right_back_wheel.location);
    all_parts(:,5,count) = judge_empty_part(record.objects(car_number).anchors.left_front_light.location);
    all_parts(:,6,count) = judge_empty_part(record.objects(car_number).anchors.right_front_light.location);
    all_parts(:,7,count) = judge_empty_part(record.objects(car_number).anchors.left_back_trunk.location);
    all_parts(:,8,count) = judge_empty_part(record.objects(car_number).anchors.right_back_trunk.location);
    all_parts(:,9,count) = judge_empty_part(record.objects(car_number).anchors.upper_left_windshield.location);
    all_parts(:,10,count) = judge_empty_part(record.objects(car_number).anchors.upper_right_windshield.location);
    all_parts(:,11,count) = judge_empty_part(record.objects(car_number).anchors.upper_left_rearwindow.location);
    all_parts(:,12,count) = judge_empty_part(record.objects(car_number).anchors.upper_right_rearwindow.location);
    fprintf('finish one image... and this is [%d]\n', count);

    count = count + 1;
end
    
    
h5write(hdf5_name, '/center', all_centers');
h5write(hdf5_name, '/scale', all_scales);
h5write(hdf5_name, '/part', all_parts);