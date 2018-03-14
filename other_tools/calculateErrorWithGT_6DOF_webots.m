% this function calculate the error between estimated pose and ground truth
% GT is provided by real world measurment or webots 
format short 
close all;clc; clear all;
load('../webots/camera.mat');

% load valid file
load('../webots/result.mat');

% load ground truth and transform to chessboard coordinate
load('../result/groundtruth/groundtruth_toyota.mat');
groundtruth{1}(:,:) = groundtruth{1}(:,:)/1;
groundtruth = transformToChessboard(groundtruth);

vis = 1;

for ID = 1 : 9
    % generate camera parameters
    all_camera{ID}.R = cameraParams.RotationMatrices(:,:,ID);
    all_camera{ID}.T = cameraParams.TranslationVectors(ID,:)';  
    
    model = output_fp{ID}.S';
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


    %% FULL perception
    % transform to estimated position
    model_3D_fp = bsxfun(@plus, output_fp{ID}.R*model', output_fp{ID}.T);
    % transform to world coordinate
    model_3D_w = (bsxfun(@minus, model_3D_fp, all_camera{ID}.T)'*all_camera{ID}.R')';


    %% [1] --- calculate every point error
    error_avg_fp = 0;
    for i = 1 : 12
        error_log_fp(i) = sqrt(sum((groundtruth{1}(:,i)-model_3D_w(:,i)).^2));
        error_avg_fp = error_avg_fp + error_log_fp(i);
    end
    error_avg_fp = error_avg_fp/12;
    fprintf('Average error for estimationis : %f cm\n', error_avg_fp)

    %% [2] --- calculate rotation and translation error
    % translation comes from centroid 
    centroid_GT = sum(groundtruth{1},2)/12;
    centroid_ES = sum(model_3D_w,2)/12;
    translation_error_fp = sqrt(sum((centroid_GT-centroid_ES).^2));
    % ratation error using [geodesic distance function]
    % we only use front light vector to calculate the rotation matrix
    % groundtruth depends on the position of the chessboard
    R_GT = getTransformWithGT(model', groundtruth{1});
    R_ES = all_camera{ID}.R * output_fp{ID}.R;
    rotation_error_fp = 180/pi*norm(logm(R_GT'*R_ES),'fro')/sqrt(2);
    fprintf('Full Perception Rotation Error is : %f degree \n', rotation_error_fp)
    fprintf('Full Perception Translation Error is : %f cm \n', translation_error_fp)
    
    % draw results, red points represents GT
    if vis == 1
        figure
        % choose one point to check the order of the model
        show_number = 2;
        one_point_es = model(show_number,:);
        one_point_gt = groundtruth{1}(:,show_number);
        model_3D = bsxfun(@plus, output_fp{ID}.R*one_point_es', output_fp{ID}.T);
        ES_temp = (bsxfun(@minus, model_3D, all_camera{ID}.T)'*all_camera{ID}.R')';
    
        plot3(ES_temp(1), ES_temp(2), ES_temp(3), '.', 'markersize', 50);
        hold on
        plot3(one_point_gt(1), one_point_gt(2), one_point_gt(3), '.', 'markersize', 50);
        hold on
        drawCameraAndCarGT(output_fp{ID}.R, output_fp{ID}.T, model, all_camera, ID);
        drawModelofGT(groundtruth, model_3D_w)
        title('Full Perception result')
    end
    
    %% WEAK perception
    output_wp{ID}.T(3) = 1;
    % transform to estimated position
    model_3D_fp = bsxfun(@plus, output_wp{ID}.R*model', output_wp{ID}.T);
    % transform to world coordinate
    model_3D_w = (bsxfun(@minus, model_3D_fp, all_camera{ID}.T)'*all_camera{ID}.R')';

    %% [2] --- calculate rotation error
    % ratation error using [geodesic distance function]
    R_ES = all_camera{ID}.R * output_wp{ID}.R;
    rotation_error_weak = 180/pi*norm(logm(R_GT'*R_ES),'fro')/sqrt(2);
    fprintf('Weak Perception Rotation Error is : %f degree \n', rotation_error_weak)

    % save results
    result{ID}.error_log_fp = error_log_fp;
    result{ID}.error_avg_fp = error_avg_fp;
    result{ID}.translation_error_fp = translation_error_fp;
    result{ID}.rotation_error_fp = rotation_error_fp;
    result{ID}.rotation_error_weak = rotation_error_weak;
    pause
end


save('../result/6dof_result_toyota.mat', 'result')












