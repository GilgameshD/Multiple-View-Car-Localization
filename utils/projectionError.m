function error_2D = projectionError(type, R, T, heatpoint_2D, S,camera,center, scale)
    
    % transform to camera coordinate
    model_3D = bsxfun(@plus, R*S,T);
    
    % transform to another camera if necessary
    if strcmp(type, 'L2L') 
        % transform to CAM1 coordinate
        estimates_2D = camera.cam{1}.K*model_3D;
    elseif strcmp(type, 'L2R') 
        % transform to world coordinate
        model_3D_w = (bsxfun(@minus, model_3D, camera.cam{1}.T)'*camera.cam{1}.R')';
        % transform to CAM2 coordinate
        estimates_2D = camera.cam{2}.K*bsxfun(@plus, (model_3D_w'*camera.cam{2}.R)', camera.cam{2}.T);
    elseif strcmp(type, 'R2L')
        % transform to world coordinate
        model_3D_w = (bsxfun(@minus, model_3D, camera.cam{2}.T)'*camera.cam{2}.R')';
        % transform to CAM1 coordinate
        estimates_2D = camera.cam{1}.K*bsxfun(@plus, (model_3D_w'*camera.cam{1}.R)', camera.cam{1}.T);
    elseif strcmp(type, 'R2R')
        % transform to CAM1 coordinate
        estimates_2D = camera.cam{2}.K*model_3D;
    end    
            
    % transform to homogeneous coordinate
    estimates_2D = bsxfun(@rdivide, estimates_2D(1:2,:), estimates_2D(3,:));
    estimates_2D = transformHG(estimates_2D, center, scale, [64,64], false);
    
    % calculate distance
    difference = estimates_2D - heatpoint_2D;
    error_2D = sqrt(difference(1,:).^2 + difference(2,:).^2); 
end