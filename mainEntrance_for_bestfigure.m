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

clear all; clc; close all;
warning('off');
addpath(genpath('utils'));
addpath(genpath('other_tools/paper_figures'));

% path for annotations
datapath = './realworld/';
% path for network output
predpath = './realworld/';
% path where the results are stored
savepath = 'result/';

% define some parameters
count = 1;
% this number can be arbitried, because any pair of calibration is ok
cam_pair = 12;
% this list is for image to be shown
camera_list = [5,6];

% load parameters
all_file_name = importdata(strcat(datapath, 'valid_images.txt'));
all_scale = h5read(strcat(datapath, 'valid.h5'),'/scale');
all_center = h5read(strcat(datapath, 'valid.h5'),'/center');
load(strcat(datapath, 'camera.mat'));
cad = load(strcat(datapath, 'car.mat'));
cad = cad.('car');
cad = cad(2);
dict = getPascalTemplate(cad);
model = centralize(dict.mu)';

% set initial model scale
model = model.*90;

%% --- input ---
for camera_ID = 1 : camera.camera_number
    imgname{camera_ID} = all_file_name(camera_list(camera_ID));
    center{camera_ID} = all_center(:,camera_list(camera_ID));
    scale{camera_ID} = all_scale(camera_list(camera_ID));

    % read heatmaps and detect maximum responses
    heatmap{camera_ID} = h5read(sprintf('%s/valid_%d.h5', predpath, camera_list(camera_ID)), '/heatmaps');
    % rotate the heatmap
    heatmap{camera_ID} = permute(heatmap{camera_ID}(:,:,46:57),[2,1,3]);

    % heatpoint_2D means the 2D coordinate of those keypoints
    [heatpoint_2D{camera_ID}, D{camera_ID}] = findWmax(heatmap{camera_ID});

    % transform form heatmap coordinate to <full image> coordinate 
    W_im{camera_ID} = transformHG(heatpoint_2D{camera_ID}, center{camera_ID}, scale{camera_ID}, size(heatmap{camera_ID}(:,:,1)), true);
    W_hg{camera_ID} = camera.cam{camera_ID}.K\[W_im{camera_ID};ones(1,size(W_im{camera_ID},2))];        
end


%% --- start to estimate pose ---
% - pose optimization - perspective projection
% - use common points to get a initial pose, and [keypoint_common] saves the common points 
[keypoint_common, initialPose] = getInitialPose(W_hg, D, model, camera);    
fprintf('Finishing initializing pose... \n');

% - use cameras' views to estimated pose
[fval, estimated_pose] = PoseEstimaedFromMultiview(heatpoint_2D, W_hg, initialPose, D, model, camera, center, scale);
fprintf('Finishing estimateing pose... \n');


%% --- visualization ---   
% - read imges
for camera_ID = 1 : camera.camera_number
    img_to_be_shown{camera_ID} = imread(sprintf('%s/%s',datapath, char(imgname{camera_ID})));
end 
% draw heatmap and projection
% [L, R] = visualize_all(heatpoint_2D, fval, img_to_be_shown, estimated_pose, heatmap, center, scale, camera, estimated_pose.S);
drawBigFigure(heatpoint_2D, img_to_be_shown, estimated_pose, heatmap, center, scale, camera, estimated_pose.S); 
drawProjectionInOriginalImage(img_to_be_shown, estimated_pose, center, scale, camera, estimated_pose.S)


%% --- output --- 
%savefile = sprintf('%s/valid_%d.mat', savepath, count); 
%count = count+1;
%save(savefile, 'estimated_pose');













