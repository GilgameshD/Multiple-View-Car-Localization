function result = transformToChessboard(groundtruth)

    angle_x = deg2rad(90);
    angle_y = deg2rad(-90);
    angle_z = deg2rad(90);
    rotation_X = [1,0,0;0,cos(angle_x),sin(angle_x);0,-sin(angle_x),cos(angle_x)]; 
    rotation_Y = [cos(-angle_y),0,sin(angle_y);0,1,0;-sin(angle_y),0,cos(-angle_y)];
    rotation_Z = [cos(angle_z),sin(angle_z),0;-sin(angle_z),cos(angle_z),0;0,0,1]; 
     
    for i = 1 : 2
        % flip Y-axis
        groundtruth{i}(:,2) = -groundtruth{i}(:,2);
        groundtruth{i}(:,3) = -groundtruth{i}(:,3);
        % from [m] to [cm]
        groundtruth{i} = groundtruth{i}'*100;
        
        % FOR LINCON (NONE)
        % FOR TOYOTA £¨Y-(-90degree)£©
        groundtruth{i} = rotation_Y * groundtruth{i};
        % FOR BWM£¨Y-(90degree)£©
        %groundtruth{i} = rotation_Y * groundtruth{i};
    end
   
    orginal_GT = [groundtruth{2}(1,1), groundtruth{2}(2,1), groundtruth{2}(3,1)]';
    
    % the original points is not the margin of chessboard
    translation = orginal_GT + [20,20,0]';
    groundtruth{1} = bsxfun(@minus, groundtruth{1},translation);
    groundtruth{2} = bsxfun(@minus, groundtruth{2},translation);
    result = groundtruth;
end