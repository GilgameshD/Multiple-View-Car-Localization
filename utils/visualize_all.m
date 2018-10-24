getIpOptionsgetIpOptions% This function will show all results in figures

function [model_2D_l, model_2D_r] = visualize_all(heatpoint_2D, fval, img_to_be_shown, estimated_pose, heatmap, center, scale, camera, model)
    
    % project model to two cameras in 2D images
%     nplot = 2;
%     figure('position', [200,200,nplot*400,400]);
%     subplot('position', [0,0,1/nplot,1]);
%     drawLeftCamera(estimated_pose, model, camera);
%     title('From Left Pose'); axis equal
%     subplot('position',[1/nplot,0,1/nplot,1]);
%     drawRightCamera(estimated_pose, model, camera);
%     title('From Right Pose'); axis equal
       
    img_crop{1} = cropImage(img_to_be_shown{1},center{1},scale{1});
    img_crop{2} = cropImage(img_to_be_shown{2},center{2},scale{2});

    %% heatmaps
    figure('position',[300,300,4*300,2*300]);
    subplot('position',[0 1/2 1/4 1/2]);   
    response = sum(heatmap{1},3);
    max_value = max(max(response));
    mapIm = imresize(mat2im(response, jet(100), [0 max_value]),[200,200],'nearest');
    imToShow = mapIm*0.5 + (single(img_crop{1})/255)*0.5;
    imagesc(imToShow); axis equal off;
    subplot('position',[0 0 1/4 1/2]);
    response = sum(heatmap{2},3);
    max_value = max(max(response));
    mapIm = imresize(mat2im(response, jet(100), [0 max_value]),[200,200],'nearest');
    imToShow = mapIm*0.5 + (single(img_crop{2})/255)*0.5;
    imagesc(imToShow); axis equal off;
    
    %% draw max value point on image
    scale_new = 200.0/64.0;
    subplot('position',[1/4 1/2 1/4 1/2]);
    imshow(img_crop{1}); hold on;
    plot(heatpoint_2D{1}(1,:).*scale_new,heatpoint_2D{1}(2,:).*scale_new,'g.', 'markersize', 40);
    subplot('position',[1/4 0 1/4 1/2]);
    imshow(img_crop{2}); hold on;
    plot(heatpoint_2D{2}(1,:).*scale_new,heatpoint_2D{2}(2,:).*scale_new,'g.', 'markersize', 40);
     
    %% CAM1 result project to 2D image
    % left
    subplot('position',[1/2 1/2 1/4 1/2]); imshow(img_crop{1}); hold on;
    % transform to estimated position
    model_3D = bsxfun(@plus, estimated_pose.R1*model', estimated_pose.T1);
    % transform to world coordinate
    model_3D_w = (bsxfun(@minus, model_3D, camera.cam{1}.T)'*camera.cam{1}.R')';
    % transform to CAM1 coordinate
    model_3D = bsxfun(@plus, (model_3D_w'*camera.cam{1}.R)', camera.cam{1}.T);
    % projection
    model_2D_l = camera.cam{1}.K * model_3D;
    model_2D_l = bsxfun(@rdivide, model_2D_l(1:2,:),model_2D_l(3,:));
    % transform to homogeneous coordinate
    model_2D_l = transformHG(model_2D_l, center{1}, scale{1}, size(heatmap{1}(:,:,1)),false)*200/size(heatmap{1},2);
    % draw points and lines
    drawFrame(model_2D_l(1,:), model_2D_l(2,:), 2);
    plot(model_2D_l(1,:), model_2D_l(2,:), '.', 'markersize', 40);
    
    % right
    subplot('position',[3/4 1/2 1/4 1/2]); imshow(img_crop{2}); hold on;
    % transform to CAM2 coordinate
    model_3D = bsxfun(@plus, (model_3D_w'*camera.cam{2}.R)', camera.cam{2}.T);
    % projection
    model_2D_r = camera.cam{2}.K * model_3D;
    model_2D_r = bsxfun(@rdivide, model_2D_r(1:2,:), model_2D_r(3,:));
    % transform to homogeneous coordinate
    model_2D_r = transformHG(model_2D_r, center{2}, scale{2}, size(heatmap{2}(:,:,1)),false)*200/size(heatmap{2},2);
    % draw points and lines
    drawFrame(model_2D_r(1,:), model_2D_r(2,:), 2);
    plot(model_2D_r(1,:), model_2D_r(2,:), '.', 'markersize', 40);
    
    
    %% CAM2 result project to 2D image
    % left
    subplot('position',[3/4 0 1/4 1/2]); imshow(img_crop{1}); hold on;
    % transform to estimated position
    model_3D = bsxfun(@plus, estimated_pose.R2*model', estimated_pose.T2);
    % transform to world coordinate
    model_3D_w = (bsxfun(@minus, model_3D, camera.cam{2}.T)'*camera.cam{2}.R')';
    % transform to CAM1 coordinate
    model_3D = bsxfun(@plus, (model_3D_w'*camera.cam{1}.R)', camera.cam{1}.T);
    % projection
    model_2D_l = camera.cam{1}.K * model_3D;
    model_2D_l = bsxfun(@rdivide, model_2D_l(1:2,:),model_2D_l(3,:));
    % transform to homogeneous coordinate
    model_2D_l = transformHG(model_2D_l, center{1}, scale{1}, size(heatmap{1}(:,:,1)),false)*200/size(heatmap{1},2);
    % draw points and lines
    drawFrame(model_2D_l(1,:), model_2D_l(2,:), 2);
    plot(model_2D_l(1,:), model_2D_l(2,:), '.', 'markersize', 40);
    
    % right
    subplot('position',[1/2 0 1/4 1/2]); imshow(img_crop{2}); hold on;
    % transform to CAM2 coordinate
    model_3D = bsxfun(@plus, (model_3D_w'*camera.cam{2}.R)', camera.cam{2}.T);
    % projection
    model_2D_r = camera.cam{2}.K * model_3D;
    model_2D_r = bsxfun(@rdivide, model_2D_r(1:2,:), model_2D_r(3,:));
    % transform to homogeneous coordinate
    model_2D_r = transformHG(model_2D_r, center{2}, scale{2}, size(heatmap{2}(:,:,1)),false)*200/size(heatmap{2},2);
    % draw points and lines
    drawFrame(model_2D_r(1,:), model_2D_r(2,:), 2);
    plot(model_2D_r(1,:), model_2D_r(2,:), '.', 'markersize', 40);
    
    
    %% show reprojection error
    axis_scale = 1;
    figure
    subplot(1,3,1); plot(fval{1}/axis_scale, 'color', [250/255,128/255,114/255], 'linewidth', 2); grid on; 
    title('left cam error'); xlabel('iteration'); %axis([0,1500,0,10])
    subplot(1,3,2); plot(fval{2}/axis_scale, 'color', [84/255,1,159/255], 'linewidth', 2); grid on; 
    title('right cam error'); xlabel('iteration'); %axis([0,1500,0,10])
    subplot(1,3,3); plot(fval{3}/axis_scale, 'color', [0,191/255,1], 'linewidth', 2); grid on; 
    title('total error'); xlabel('iteration'); %axis([0,1500,0,10])
    
end







