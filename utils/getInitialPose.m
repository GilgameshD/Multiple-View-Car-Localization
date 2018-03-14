% this function uses common 2D keypoints and camera parameters to generate
% 3D coordinates of some points if possible.

function [keypoint_common, initialPose] = getInitialPose(W_hg, score, model, camera)

    % check if there are common keypoints, and the rule is score higher than a threshhold
    threshhold = 0.5;              % this value is depend on experiment
    keypoint_common = ones(12,1);  % assume that all points are common firstly
    for part_number = 1 : 12
        for cam_num = 1 : camera.camera_number
            if score{cam_num}(part_number) < threshhold
                keypoint_common(part_number) = 0;
                break;
            end
        end
    end
    
    % have no common keypoint
    initialPose.R1 = [1,0,0;0,1,0;0,0,1];
    initialPose.T1 = [0,0,0]'; 
    if sum(keypoint_common) == 0
        return;
    end
    
    % get transform matrix
    M1 = camera.cam{1}.R; 
    M1(:,4) = camera.cam{1}.T;
    M2 = camera.cam{2}.R; 
    M2(:,4) = camera.cam{2}.T;
    % M3 ...
    % M4 ...
    
    wireframe_mean = [0,0,0];     % use non-homogeneous coordinates
    reprojection_mean = [0,0,0];  % use non-homogeneous coordinates
    P = zeros(12, 4);
    
    % get 3D coordinates of common parts
    for part_num = 1 : 12
        
        if keypoint_common(part_num) == 0
            continue;
        end
        
        p1 = W_hg{1}(:,part_num);
        p2 = W_hg{2}(:,part_num);
        
        % skew symmetric matrix
        p1x = [    0,   -p1(3),  p1(2);...
                p1(3),    0     -p1(1);...
               -p1(2),  p1(1),    0  ];
        p2x = [    0,   -p2(3),  p2(2);...
                p2(3),    0     -p2(1);...
               -p2(2),  p2(1),    0  ];
           
        % get 3D position using least-square (SVD)
        A = [p1x * M1; p2x * M2];
        [~, ~, V] = svd(A);
        P_part = V(:,4);
        P_part = P_part/P_part(4);
        P(part_num,:) = P_part;
        
        % get mean coordinates
        reprojection_mean = reprojection_mean + P(part_num, 1:3);
        wireframe_mean = wireframe_mean + model(part_num);
    end
    
    % --- using common keypoints to generate initial pose
    % initial T (easy, only one point is enough)
    initialPose.T1 = ((wireframe_mean - reprojection_mean) / sum(keypoint_common))';
    
    % --- initial R (hard, at least two points, use two high score keypoints to get R)
    % - get sum score of every points 
    all_sum_score = zeros(12,1);
    for part_num = 1 : 12
        if keypoint_common(part_num) ~= 0
            for cam_num = 1 : camera.camera_number
                all_sum_score(part_num) = all_sum_score(part_num) + score{cam_num}(part_num);
            end
        end
    end
    
    % - find max two score position
    [~, max_position_1] = max(all_sum_score);
    all_sum_score(max_position_1) = 0;
    [~, max_position_2] = max(all_sum_score);
    
    % - get two best vectors
    wireframe_vector = model(max_position_1,:) - model(max_position_2,:);
    reprojection_vector = P(max_position_1, 1:3) - P(max_position_2, 1:3);
    
    % - get rotation vector
    rotation_axis = cross(wireframe_vector, reprojection_vector);
    rotation_angle = acos(dot(wireframe_vector, reprojection_vector)/Normalize(wireframe_vector)/Normalize(reprojection_vector));
    rotation_vector = Normalize(rotation_axis) .* repmat(rotation_angle,3,1);
    
    % - get rotation matrix
    initialPose.R1 = rodrigues(rotation_vector);
    
end


function result = Normalize(v)
    result = sqrt(v(1)*v(1) + v(2)*v(2) + v(3)*v(3));
end



