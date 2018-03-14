% This function will show all results in figures

function [model_2D_l_1, model_2D_r_1] = showBetterThanMono(img_to_be_shown, estimated_pose, heatmap, center, scale, camera, model)
    
    img_crop{1} = cropImage(img_to_be_shown{1},center{1},scale{1});
    img_crop{2} = cropImage(img_to_be_shown{2},center{2},scale{2});
    
    figure_position{1} = [0 1/2  1 1/2];
    figure_position{2} = [0 0 1 1/2];

   
    %% CAM1 result project to 2D image
    
    % left
    % transform to estimated position
    model_3D = bsxfun(@plus, estimated_pose.R1*model', estimated_pose.T1);
    % transform to world coordinate
    model_3D_w = (bsxfun(@minus, model_3D, camera.cam{1}.T)'*camera.cam{1}.R')';
    % transform to CAM1 coordinate
    model_3D = bsxfun(@plus, (model_3D_w'*camera.cam{1}.R)', camera.cam{1}.T);
    % projection
    model_2D_l_1 = camera.cam{1}.K * model_3D;
    model_2D_l_1 = bsxfun(@rdivide, model_2D_l_1(1:2,:),model_2D_l_1(3,:));
    % transform to homogeneous coordinate
    model_2D_l_1 = transformHG(model_2D_l_1, center{1}, scale{1}, size(heatmap{1}(:,:,1)),false)*200/size(heatmap{1},2);
    % right
    % transform to CAM2 coordinate
    model_3D = bsxfun(@plus, (model_3D_w'*camera.cam{2}.R)', camera.cam{2}.T);
    % projection
    model_2D_r_1 = camera.cam{2}.K * model_3D;
    model_2D_r_1 = bsxfun(@rdivide, model_2D_r_1(1:2,:), model_2D_r_1(3,:));
    % transform to homogeneous coordinate
    model_2D_r_1 = transformHG(model_2D_r_1, center{2}, scale{2}, size(heatmap{2}(:,:,1)),false)*200/size(heatmap{2},2);

    
    %% CAM2 result project to 2D image
    % left
    % transform to estimated position
    model_3D = bsxfun(@plus, estimated_pose.R2*model', estimated_pose.T2);
    % transform to world coordinate
    model_3D_w = (bsxfun(@minus, model_3D, camera.cam{2}.T)'*camera.cam{2}.R')';
    % transform to CAM1 coordinate
    model_3D = bsxfun(@plus, (model_3D_w'*camera.cam{1}.R)', camera.cam{1}.T);
    % projection
    model_2D_l_2 = camera.cam{1}.K * model_3D;
    model_2D_l_2 = bsxfun(@rdivide, model_2D_l_2(1:2,:),model_2D_l_2(3,:));
    % transform to homogeneous coordinate
    model_2D_l_2 = transformHG(model_2D_l_2, center{1}, scale{1}, size(heatmap{1}(:,:,1)),false)*200/size(heatmap{1},2);
    % right
    % transform to CAM2 coordinate
    model_3D = bsxfun(@plus, (model_3D_w'*camera.cam{2}.R)', camera.cam{2}.T);
    % projection
    model_2D_r_2 = camera.cam{2}.K * model_3D;
    model_2D_r_2 = bsxfun(@rdivide, model_2D_r_2(1:2,:), model_2D_r_2(3,:));
    % transform to homogeneous coordinate
    model_2D_r_2 = transformHG(model_2D_r_2, center{2}, scale{2}, size(heatmap{2}(:,:,1)),false)*200/size(heatmap{2},2);

    
    % left figure (mono result)
    figure('position',[300,300,300,2*300]);
    subplot('position',figure_position{1}); imshow(img_crop{1}); hold on;
    drawFrame(model_2D_l_1(1,:), model_2D_l_1(2,:), 2);
    plot(model_2D_l_1(1,:), model_2D_l_1(2,:), '.', 'markersize', 40);
    
    subplot('position',figure_position{2}); imshow(img_crop{2}); hold on;
    drawFrame(model_2D_r_1(1,:), model_2D_r_1(2,:), 2);
    plot(model_2D_r_1(1,:), model_2D_r_1(2,:), '.', 'markersize', 40);
    
    
    % right figure (mono result)
    figure('position',[300,300,300,2*300]);
    subplot('position',figure_position{2}); imshow(img_crop{1}); hold on;
    drawFrame(model_2D_l_2(1,:), model_2D_l_2(2,:), 2);
    plot(model_2D_l_2(1,:), model_2D_l_2(2,:), '.', 'markersize', 40);
    
    subplot('position',figure_position{1}); imshow(img_crop{2}); hold on;
    drawFrame(model_2D_r_2(1,:), model_2D_r_2(2,:), 2);
    plot(model_2D_r_2(1,:), model_2D_r_2(2,:), '.', 'markersize', 40);
    
end







