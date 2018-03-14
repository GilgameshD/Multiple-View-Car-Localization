% this function calculate the error between estimated pose and ground truth
% GT is provided by real world measurment or webots 

clc; clear all;
load('../webots/camera.mat');

% load valid file
load('../result/valid_1.mat');
model = estimated_pose.S;
camera_list = [1,3];

% load ground truth and transform to chessboard coordinate
load('../result/groundtruth/groundtruth_lincon.mat');
groundtruth = transformToChessboard(groundtruth);

% change model points order
model =[...
model(3,:);...   % 右前轮 --> 左前轮
model(1,:);...   % 右后轮 --> 右前轮
model(2,:);...   % 左前轮 --> 右后轮
model(4,:);...   % 左后轮 --> 左后轮
model(10,:);...  % 右前挡风 --> 左前灯
model(9,:);...   % 左前挡风 --> 右前灯 
model(12,:);...  % 左后挡风 --> 右后灯
model(11,:);...  % 右后挡风 --> 左后灯
model(6,:);...   % 右前灯 --> 左前挡风
model(5,:);...   % 左前灯 --> 右前挡风
model(8,:);...   % 左后灯 --> 右后挡风
model(7,:);...   % 右后灯 --> 左后挡风
];


%% CAM 1
% transform to estimated position
model_3D_1 = bsxfun(@plus, estimated_pose.R1*model', estimated_pose.T1);
% transform to world coordinate
model_3D_w = (bsxfun(@minus, model_3D_1, camera.cam{1}.T)'*camera.cam{1}.R')';


%% [1] --- calculate every point error
error_avg_1 = 0;
for i = 1 : 12
    error_log_1(i) = sqrt(sum((groundtruth{1}(:,i)-model_3D_w(:,i)).^2));
    error_avg_1 = error_avg_1 + error_log_1(i);
end
error_avg_1 = error_avg_1/12;
fprintf('Average error for estimation 1 is : %f \n', error_avg_1)


%% [2] --- calculate rotation and translation error
% translation comes from centroid 
centroid_GT = sum(groundtruth{1},2)/12;
centroid_ES = sum(model_3D_w,2)/12;
translation_error_1 = sqrt(sum((centroid_GT-centroid_ES).^2));
% ratation error using [geodesic distance function]
% we only use front light vector to calculate the rotation matrix
% groundtruth depends on the position of the chessboard
R_GT = getTransformWithGT(model', groundtruth{1});
R_ES = camera.cam{1}.R * estimated_pose.R1;
rotation_error_1 = 180/pi*norm(logm(R_GT'*R_ES),'fro')/sqrt(2);
fprintf('Rotation error is : %f degree \n', rotation_error_1)


%% [3] --- calculate overlap area
GT_width = abs(groundtruth{1}(1,3)-groundtruth{1}(1,1));
GT_height = abs(groundtruth{1}(3,5)-groundtruth{1}(3,12));
ES_width = abs(model_3D_w(1,3)-model_3D_w(1,1));
ES_height = abs(model_3D_w(3,5)-model_3D_w(3,12));

overlap_ratio_1 = calculateOverlapArea([groundtruth{1}(1,1),groundtruth{1}(3,5),GT_width,GT_height],...
                                       [model_3D_w(1,1),model_3D_w(3,5),ES_width,ES_height]);
fprintf('Overlap ratio is : %f%% \n', overlap_ratio_1*100)

% save results
result.error_log_1 = error_log_1;
result.error_avg_1 = error_avg_1;
result.translation_error_1 = translation_error_1;
result.rotation_error_1 = rotation_error_1;
result.overlap_ratio_1 = overlap_ratio_1;
% draw results, red points represents GT
figure
drawCameraAndCarGT(estimated_pose.R1, estimated_pose.T1, estimated_pose.S, camera, 1);
showCameraForWebotsGT(cameraParams, camera_list); hold on
drawModelofGT(groundtruth, model_3D_w)


%%
% ============================  Do the same thing for CAM 2  ==============================
% CAM 2
% transform to estimated position
model_3D_2 = bsxfun(@plus, estimated_pose.R2*model', estimated_pose.T2);
% transform to world coordinate
model_3D_w = (bsxfun(@minus, model_3D_2, camera.cam{2}.T)'*camera.cam{2}.R')';


%% [1] --- calculate every point error
error_avg_2 = 0;
for i = 1 : 12
    error_log_2(i) = sqrt(sum((groundtruth{1}(:,i)-model_3D_w(:,i)).^2));
    error_avg_2 = error_avg_2 + error_log_2(i);
end
error_avg_2 = error_avg_2 / 12;
fprintf('Average error for estimation 2 is : %f \n', error_avg_2)


%% [2] --- calculate rotation error
% translation comes from centroid 
centroid_ES = sum(model_3D_w,2)/12;
translation_error_2 = sqrt(sum((centroid_GT-centroid_ES).^2));
% ratation error using [geodesic distance function]
R_ES = camera.cam{2}.R * estimated_pose.R2;
rotation_error_2 = 180/pi*norm(logm(R_GT'*R_ES),'fro')/sqrt(2);
fprintf('Rotation error is : %f degree \n', rotation_error_2)


%% [3] --- calculate overlap error
overlap_ratio_2 = calculateOverlapArea([groundtruth{1}(1,1),groundtruth{1}(3,5),GT_width,GT_height],...
                                       [model_3D_w(1,1),model_3D_w(3,5),ES_width,ES_height]);
fprintf('Overlap ratio is : %f%% \n', overlap_ratio_2*100)

% save results
result.error_log_2 = error_log_2;
result.error_avg_2 = error_avg_2;
result.translation_error_2 = translation_error_2;
result.rotation_error_2 = rotation_error_2;
result.overlap_ratio_2 = overlap_ratio_2;

% draw the result
figure
drawCameraAndCarGT(estimated_pose.R2, estimated_pose.T2, estimated_pose.S, camera, 2);
showCameraForWebotsGT(cameraParams, camera_list); hold on
drawModelofGT(groundtruth, model_3D_w)










