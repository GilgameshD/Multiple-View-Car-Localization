% This function will show all results in figures

function drawFiguresForVideo(heatpoint_2D, img_to_be_shown, estimated_pose, heatmap, center, scale, camera, model)
    
    img_crop{1} = cropImage(img_to_be_shown{1},center{1},scale{1});
    img_crop{2} = cropImage(img_to_be_shown{2},center{2},scale{2});

    image_size = 500;
    %% original image
    figure('position',[image_size,image_size,image_size,image_size]);
    subplot('position',[0,0,1,1]);   
    imshow(img_crop{1});
    figure('position',[image_size,image_size,image_size,image_size]);
    subplot('position',[0,0,1,1]);   
    imshow(img_crop{2});
    
    %% heatmaps
    figure('position',[image_size,image_size,image_size,image_size]);
    subplot('position',[0,0,1,1]);   
    response = sum(heatmap{1},3);
    max_value = max(max(response));
    mapIm = imresize(mat2im(response, jet(100), [0 max_value]),[200,200],'nearest');
    imToShow = mapIm*0.5 + (single(img_crop{1})/255)*0.5;
    imagesc(imToShow); axis equal off;
    
    figure('position',[image_size,image_size,image_size,image_size]);
    subplot('position',[0,0,1,1]);   
    response = sum(heatmap{2},3);
    max_value = max(max(response));
    mapIm = imresize(mat2im(response, jet(100), [0 max_value]),[200,200],'nearest');
    imToShow = mapIm*0.5 + (single(img_crop{2})/255)*0.5;
    imagesc(imToShow); axis equal off;
   
    
    %% draw max value point on image
    scale_new = 200.0/64.0;
    figure('position',[image_size,image_size,image_size,image_size]);
    subplot('position',[0,0,1,1]);   
    imshow(img_crop{1}); hold on;
    plot(heatpoint_2D{1}(1,:).*scale_new,heatpoint_2D{1}(2,:).*scale_new,'g.', 'markersize', 60);
    figure('position',[image_size,image_size,image_size,image_size]);
    subplot('position',[0,0,1,1]);   
    imshow(img_crop{2}); hold on;
    plot(heatpoint_2D{2}(1,:).*scale_new,heatpoint_2D{2}(2,:).*scale_new,'g.', 'markersize', 60);
   
    
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

    
    %% CAM2 result project to 2D image
    % transform to estimated position
    model_3D = bsxfun(@plus, estimated_pose.R2*model', estimated_pose.T2);
    % transform to world coordinate
    model_3D_w = (bsxfun(@minus, model_3D, camera.cam{2}.T)'*camera.cam{2}.R')';
    % right
    % transform to CAM2 coordinate
    model_3D = bsxfun(@plus, (model_3D_w'*camera.cam{2}.R)', camera.cam{2}.T);
    % projection
    model_2D_r_2 = camera.cam{2}.K * model_3D;
    model_2D_r_2 = bsxfun(@rdivide, model_2D_r_2(1:2,:), model_2D_r_2(3,:));
    % transform to homogeneous coordinate
    model_2D_r_2 = transformHG(model_2D_r_2, center{2}, scale{2}, size(heatmap{2}(:,:,1)),false)*200/size(heatmap{2},2);

    
    figure('position',[image_size,image_size,image_size,image_size]);
    subplot('position',[0,0,1,1]); imshow(img_crop{1}); hold on;
    % draw points and lines
    drawFrame(model_2D_l_1(1,:), model_2D_l_1(2,:), 2);
    plot(model_2D_l_1(1,:), model_2D_l_1(2,:), '.', 'markersize', 40);

    figure('position',[image_size,image_size,image_size,image_size]);
    subplot('position',[0,0,1,1]); imshow(img_crop{2}); hold on; 
    % draw points and lines
    drawFrame(model_2D_r_2(1,:), model_2D_r_2(2,:), 2);
    plot(model_2D_r_2(1,:), model_2D_r_2(2,:), '.', 'markersize', 40);
end







