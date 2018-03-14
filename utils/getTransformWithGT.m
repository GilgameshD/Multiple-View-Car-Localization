function R_GT = getTransformWithGT(model, groundtruth)    
%     vector_before = model(:,5)-model(:,6);
%     vector_after = groundtruth(:,5)-groundtruth(:,6);
%     
%     % - get rotation vector
%     rotation_axis = cross(vector_after, vector_before);
%     rotation_angle = acos(dot(vector_before, vector_after)/Normalize(vector_after)/Normalize(vector_before));
%     rotation_vector = Normalize(rotation_axis) .* repmat(rotation_angle,3,1);
%     
%     % - get rotation matrix
%     R_GT_test = rodrigues(rotation_vector);

    % FOR LINCON
%     angle_x = deg2rad(-90);
%     R_GT = [1,0,0;0,cos(angle_x),sin(angle_x);0,-sin(angle_x),cos(angle_x)];
    % FOR TOYOTA
    angle_x = deg2rad(-90);
    R_GT = [1,0,0;0,cos(angle_x),sin(angle_x);0,-sin(angle_x),cos(angle_x)];
    angle_y = deg2rad(-90);
    R_GT = [cos(-angle_y),0,sin(angle_y);0,1,0;-sin(angle_y),0,cos(-angle_y)]*R_GT;
    % FOR BWM
%     angle_x = deg2rad(-90);
%     R_GT = [1,0,0;0,cos(angle_x),sin(angle_x);0,-sin(angle_x),cos(angle_x)];
%     angle_y = deg2rad(90);
%     R_GT = [cos(-angle_y),0,sin(angle_y);0,1,0;-sin(angle_y),0,cos(-angle_y)]*R_GT;
end
