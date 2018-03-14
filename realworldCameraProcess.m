% this function can transform real world camera parameters to the form we
% need

clear all; clc; close all;
camera_intrinc_path = './realworld/stereoParams.mat';
load(camera_intrinc_path);
% load('./realworld/cameraParams_lei.mat');
load('./realworld/cameraParams_zhang.mat');
cam_pair = 12;
% get [R T] between two cameras

K = stereoParams.CameraParameters2.IntrinsicMatrix';
K(2,3) = 1400;
K(1,3) = -400;
%K = cameraParams.IntrinsicMatrix';
camera.cam{1}.K = stereoParams.CameraParameters1.IntrinsicMatrix';
camera.cam{2}.K = K;
camera.cam{1}.R = stereoParams.CameraParameters1.RotationMatrices(:,:,cam_pair);
camera.cam{1}.T = stereoParams.CameraParameters1.TranslationVectors(cam_pair,:)';
camera.cam{2}.R = stereoParams.CameraParameters2.RotationMatrices(:,:,cam_pair);
camera.cam{2}.T = stereoParams.CameraParameters2.TranslationVectors(cam_pair,:)';
camera.camera_number = 2;

% save file
save('./realworld/camera.mat', 'camera', 'stereoParams');


% ===========================================================================
% visualize all cameras relationship, the original point is center

figure
showCameraForRealworld(stereoParams.CameraParameters1, cam_pair, 1);
hold on
showCameraForRealworld(stereoParams.CameraParameters2, cam_pair, 2);


