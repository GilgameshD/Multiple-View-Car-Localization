% This function will show all results in figures

function [handle_figure, left_figure, right_figure] = drawInOneFigure(heatpoint_2D, img_to_be_shown, estimated_pose, heatmap, center, scale, camera, model)
    
    original_size = 500;

    figure_position{1} = [0   0  1/2 1];
    figure_position{2} = [1/2   0  1/2 1];
    
    %% CAM1 result project to 2D image
    
    % left
    % transform to estimated position
    model_3D = bsxfun(@plus, estimated_pose.R1*model', estimated_pose.T1);
    % transform to world coordinate
    model_3D_w = (bsxfun(@minus, model_3D, camera.cam{1}.T)'*camera.cam{1}.R')';
    % transform to CAM1 coordinate
    model_3D = bsxfun(@plus, (model_3D_w'*camera.cam{1}.R)', camera.cam{1}.T);
    % projection
    model_2D_1 = camera.cam{1}.K * model_3D;
    model_2D_1 = bsxfun(@rdivide, model_2D_1(1:2,:),model_2D_1(3,:));
    % transform to homogeneous coordinate
    model_2D_1 = transformHG(model_2D_1, center{1}, scale{1}, [64,64],false);
    
    
    %% CAM2 result project to 2D image
    % right
    % transform to estimated position
    model_3D = bsxfun(@plus, estimated_pose.R2*model', estimated_pose.T2);
    % transform to world coordinate
    model_3D_w = (bsxfun(@minus, model_3D, camera.cam{2}.T)'*camera.cam{2}.R')';
    % transform to CAM2 coordinate
    model_3D = bsxfun(@plus, (model_3D_w'*camera.cam{2}.R)', camera.cam{2}.T);
    % projection
    model_2D_2 = camera.cam{2}.K * model_3D;
    model_2D_2 = bsxfun(@rdivide, model_2D_2(1:2,:), model_2D_2(3,:));
    % transform to homogeneous coordinate
    model_2D_2 = transformHG(model_2D_2, center{2}, scale{2}, [64,64], false);
    
    % left
    model_3D = bsxfun(@plus, estimated_pose.R2*model', estimated_pose.T2);
    % transform to world coordinate
    model_3D_w = (bsxfun(@minus, model_3D, camera.cam{2}.T)'*camera.cam{2}.R')';
    % transform to CAM1 coordinate
    model_3D = bsxfun(@plus, (model_3D_w'*camera.cam{1}.R)', camera.cam{1}.T);
    % projection
    for_correct = camera.cam{1}.K * model_3D;
    for_correct = bsxfun(@rdivide, for_correct(1:2,:),for_correct(3,:));
    % transform to homogeneous coordinate
    for_correct = transformHG(for_correct, center{1}, scale{1}, [64,64],false);
    % draw points and lines
    drawFrame(for_correct(1,:), for_correct(2,:), 2);
    plot(for_correct(1,:), for_correct(2,:), '.', 'markersize', 40);
    
    
    %% transform 200*200 to original image size
    model_2D_1 = transform_to_original_coordinate(model_2D_1, center{1}, scale{1});
    model_2D_2 = transform_to_original_coordinate(model_2D_2, center{2}, scale{2});
    
    handle_figure = figure('position',[original_size,original_size,2*original_size,original_size]);%,'visible','off');
    subplot('position',figure_position{1}); imshow(img_to_be_shown{1}); hold on;
    drawFrame(model_2D_1(1,:), model_2D_1(2,:), 2);
    plot(model_2D_1(1,:), model_2D_1(2,:), '.', 'markersize', 15);
    
    subplot('position',figure_position{2}); imshow(img_to_be_shown{2}); hold on;
    % draw points and lines
    drawFrame(model_2D_2(1,:), model_2D_2(2,:), 2);
    plot(model_2D_2(1,:), model_2D_2(2,:), '.', 'markersize', 15);
    
    
    % save left and right images desperatly
    left_figure = figure('position',[0,0,original_size,original_size],'visible','off');
    subplot('position',[0,0,1,1]); 
    imshow(img_to_be_shown{1}); hold on;
    drawFrame(model_2D_1(1,:), model_2D_1(2,:), 2);
    plot(model_2D_1(1,:), model_2D_1(2,:), '.', 'markersize', 15);
    
    right_figure = figure('position',[0,0,original_size,original_size],'visible','off');
    subplot('position',[0,0,1,1]); 
    imshow(img_to_be_shown{2}); hold on;
    % draw points and lines
    drawFrame(model_2D_2(1,:), model_2D_2(2,:), 2);
    plot(model_2D_2(1,:), model_2D_2(2,:), '.', 'markersize', 15);
end







