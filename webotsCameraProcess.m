clear all; clc;

% L = R1*R2^(-1)*R + T1-R1*R2^(-1)*T2
% --------
% R = R1*R2^(-1)
% T = T1-R1*R2^(-1)*T2

camera_intrinc_path = './webots/cameraParams.mat';
load(camera_intrinc_path);
[~,~, cam_all_num] = size(cameraParams.RotationMatrices);

for i = 1 : cam_all_num
    rotation_matrix{i} = cameraParams.RotationMatrices(:,:,i);
    position(i,:) = cameraParams.TranslationVectors(i,:)';
end

% get [R T] between two cameras
cam1 = 2;
cam2 = 3;
camera.cam{1}.K = cameraParams.IntrinsicMatrix';
camera.cam{2}.K = cameraParams.IntrinsicMatrix';
camera.cam{1}.R = rotation_matrix{cam1};
camera.cam{1}.T = position(cam1,:)';
camera.cam{2}.R = rotation_matrix{cam2};
camera.cam{2}.T = position(cam2,:)';
camera.camera_number = 2;

% save file
save('./webots/camera.mat', 'camera', 'cameraParams');


% ===========================================================================
% visualize all cameras relationship, the original point is center

figure
showExtrinsics(cameraParams, 'patternCentric', 'HighlightIndex', []);


