%%
% -------------------------------------------------------------------------------------------------------
% This code is for ICRA 2018 paper " Multi-view Vihcle Localization Based on Keypoint Detection ConvNet "
% we assume that you have got heatmaps from CNN, and this code can estimate car pose from multiple 
% camera views (all calibrated).
%
% Author : Wenhao Ding
% Data : 8/8/2017
% Copyright 2017 | All right reserved.
% -------------------------------------------------------------------------------------------------------
%%

clear all; clc;
warning('off');
addpath(genpath('utils'));
addpath(genpath('other_tools'));

% path for annotations
camera_path = './realworld/';
datapath_1 = './realworld/l31_sup_sup/';
datapath_2 = './realworld/z31_sup_sup/';

% define some parameters
count = 1;
% this number can be arbitried, because any pair of calibration is ok
cam_pair = 7;
num_of_frame = 74;

% load parameters
all_file_name_1 = importdata(strcat(datapath_1, 'valid_images.txt'));
all_scale_1 = h5read(strcat(datapath_1, 'valid.h5'),'/scale');
all_center_1 = h5read(strcat(datapath_1, 'valid.h5'),'/center');

all_file_name_2 = importdata(strcat(datapath_2, 'valid_images.txt'));
all_scale_2 = h5read(strcat(datapath_2, 'valid.h5'),'/scale');
all_center_2 = h5read(strcat(datapath_2, 'valid.h5'),'/center');


load(strcat(camera_path, 'camera.mat'));
cad = load(strcat(camera_path, 'car.mat'));
cad = cad.('car');
cad = cad(2);
dict = getPascalTemplate(cad);
model = centralize(dict.mu)';

% set initial model scale
model = model.*80;

%% main loop
for index = 74 : num_of_frame
    
    %% --- input ---
    %%%%%%% camera 1
    imgname{1} = all_file_name_1(index);
    center{1} = all_center_1(:,index);
    scale{1} = all_scale_1(index);

    % read heatmaps and detect maximum responses
    heatmap{1} = h5read(sprintf('%s/valid_%d.h5', datapath_1, index), '/heatmaps');
    % rotate the heatmap
    heatmap{1} = permute(heatmap{1}(:,:,46:57),[2,1,3]);

    % heatpoint_2D means the 2D coordinate of those keypoints
    [heatpoint_2D{1}, D{1}] = findWmax(heatmap{1});

    % transform form heatmap coordinate to <full image> coordinate 
    W_im{1} = transformHG(heatpoint_2D{1}, center{1}, scale{1}, size(heatmap{1}(:,:,1)), true);
    W_hg{1} = camera.cam{1}.K \ [W_im{1};ones(1,size(W_im{1},2))];        
    
    %%%%%%%% camera 2
    imgname{2} = all_file_name_2(index);
    center{2} = all_center_2(:,index);
    scale{2} = all_scale_2(index);

    % read heatmaps and detect maximum responses
    heatmap{2} = h5read(sprintf('%s/valid_%d.h5', datapath_2, index), '/heatmaps');
    % rotate the heatmap
    heatmap{2} = permute(heatmap{2}(:,:,46:57),[2,1,3]);

    % heatpoint_2D means the 2D coordinate of those keypoints
    [heatpoint_2D{2}, D{2}] = findWmax(heatmap{2});

    % transform form heatmap coordinate to <full image> coordinate 
    W_im{2} = transformHG(heatpoint_2D{2}, center{2}, scale{2}, size(heatmap{2}(:,:,1)), true);
    W_hg{2} = camera.cam{2}.K \ [W_im{2};ones(1,size(W_im{2},2))];   
    
    
    %% --- start to estimate pose ---
    % - pose optimization - perspective projection
    % - use common points to get a initial pose, and [keypoint_common] saves the common points 
    [keypoint_common, initialPose] = getInitialPose(W_hg, D, model, camera);    

    % - use cameras' views to estimated pose
    [fval, estimated_pose] = PoseEstimaedFromMultiview(heatpoint_2D, W_hg, initialPose, D, model, camera, center, scale);
    fprintf('Finishing estimateing pose... this is frame [%d] \n', index);
    
    
    %% --- visualization ---   
    % - read imges
    img_to_be_shown{1} = imread(sprintf('%s/%s',datapath_1, char(imgname{1})));
    img_to_be_shown{2} = imread(sprintf('%s/%s',datapath_2, char(imgname{2})));
  
    [h, h_left, h_right] = saveVideoFigures(heatpoint_2D, img_to_be_shown, estimated_pose, heatmap, center, scale, camera, estimated_pose.S);
    [L, R] = visualize_all(heatpoint_2D, fval, img_to_be_shown, estimated_pose, heatmap, center, scale, camera, estimated_pose.S);

    %% --- output --- 
    filename = ['../video_output/clip3_3/' num2str(index) '.jpg'];
    saveas(h, filename)    
    %filename = ['../video_output/clip3_left_3/' num2str(ID) '.jpg'];
    %saveas(h_left, filename)    
    %filename = ['../video_output/clip3_right_3/' num2str(ID) '.jpg'];
    %saveas(h_right, filename)
    close(gcf)
end













