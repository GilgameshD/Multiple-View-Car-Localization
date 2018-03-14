clear all; clc; close all;


dataset_path = '../../pose-hg/pose-hg-demo/data/webots/images/';
output_path = '../../pose-hg/pose-hg-demo/data/webots/annot/';
image_num = 9;
delete(strcat(output_path, '/valid.h5'))
h5create(strcat(output_path, '/valid.h5'), '/center',[2, image_num]);
h5create(strcat(output_path, '/valid.h5'), '/scale', image_num);

% claim some vars
all_centers = double(zeros(image_num,2));
all_scales = double(zeros(image_num,1));

count = 1;
for item = 1 : image_num
    
    img = imread(strcat(dataset_path, num2str(item), '.png'));
    imshow(img);
    hold on
    for number = 1 : 1
        
        temp_1 = ginput;
        bbox_file(1) = temp_1(1);
        bbox_file(2) = temp_1(2);
        
        temp_2 = ginput;
        bbox_file(3) = temp_2(1)-temp_1(1);
        bbox_file(4) = temp_2(2)-temp_1(2);
        
        center_x = bbox_file(1) + bbox_file(3)/2;
        center_y = bbox_file(2) + bbox_file(4)/2;

        % calculate the scale
        scale = max(bbox_file(3), bbox_file(4))/200;
        
        all_scales(count) = scale;
        all_centers(count,:) = [center_x, center_y];
       
        fprintf(' >>>  finish writing one car, this is No.[%d] \n', count)
        count = count + 1;
    end
    close all;
end

% write hdf5 files
h5write(strcat(output_path, '/valid.h5'), '/center', all_centers');
h5write(strcat(output_path, '/valid.h5'), '/scale', all_scales);



