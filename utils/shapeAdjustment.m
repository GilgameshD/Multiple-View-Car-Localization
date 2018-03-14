% --- level [1] --- ( order is defferent from others )
% car(1) --- left_front_wheel;
% car(2) --- left_back_wheel;
% car(3) --- right_front_wheel;
% car(4) --- right_back_wheel;
% --- level [2] ---
% car(5) --- upper_left_windshield;
% car(6) --- upper_right_windshield;
% car(7) --- upper_right_rearwindow;
% car(8) --- upper_left_rearwindow;
% --- level [3] ---
% car(9) --- left_front_light;
% car(10) --- right_front_light;
% car(11) --- right_back_trunk;
% car(12) --- left_back_trunk;

function S = shapeAdjustment(S, score, R1, R2, T1, T2, heatpoint_2D, camera, center, scale)
    
    % parameters for fminunc optimization
    global para;
    para.R1 = R1;
    para.R2 = R2;
    para.T1 = T1;
    para.T2 = T2;
    para.camera = camera;
    para.center = center;
    para.scale = scale;
    para.heatpoint_2D = heatpoint_2D;
   
    % left points and right points order
    left_order = [1,2,5,8,9,12];
    right_order = [3,4,6,7,10,11];
    
    % left points
    left_symm  = [S(:,1), S(:,2), S(:,5), S(:,8), S(:,9), S(:,12)];
    right_symm = [S(:,3), S(:,4), S(:,6), S(:,7), S(:,10), S(:,11)];
    
    middle_points = (left_symm+right_symm)/2;
    X = [ones(6,1), middle_points(1,:)', middle_points(2,:)'];
    % get plane
    plane_c = regress(middle_points(3,:)',X,95);     
   
    % level one -- wheels
    % level two -- lights  
    % level three -- glass
    for level = 1: 3
        
        % for every level, do optimization for four points
        for point_num = 1 : 4
            % initial point
            x0 = S(1:3, 4*(level-1)+point_num);
            para.point_order = 4*(level-1)+point_num;   
            options = optimset('Display','off');
            
            % using constrain optimization to update position
            delta = 100;
            l = x0 - [delta,delta,delta]';
            u = x0 + [delta,delta,delta]';
            [point{point_num}, fval{point_num}] = fmincon(@energyFunction, x0, [],[],[],[],l,u,[], options);   
        end
        
        % level 1 is different from the other
        if level == 1
            point_1 = 3+(level-1)*4;
            point_2 = 4+(level-1)*4;
            
            % get symmetric points
            original_point(:,1) = point{1};
            original_point(:,2) = point{2};
            A = plane_c(2); B = plane_c(3); C = -1; D = plane_c(1);
            k = -(A*original_point(1,:)+B*original_point(2,:)+C*original_point(3,:)+D)/(A^2+B^2+C^2);    
            symm_point(1,:) = 2*(original_point(1,:)+A*k)-original_point(1,:);
            symm_point(2,:) = 2*(original_point(2,:)+B*k)-original_point(2,:);
            symm_point(3,:) = 2*(original_point(3,:)+C*k)-original_point(3,:);  
            
            % normalize the fval 
            fval_normal_1 = fval{1}/(fval{1}+fval{3});
            fval_normal_2 = fval{2}/(fval{2}+fval{4});
            fval_normal_3 = fval{3}/(fval{1}+fval{3});
            fval_normal_4 = fval{4}/(fval{2}+fval{4});
            
            % get weight mean points
            chosen_point(1,:) = symm_point(:,1)*fval_normal_1 + point{3}*fval_normal_3;
            chosen_point(2,:) = symm_point(:,2)*fval_normal_2 + point{4}*fval_normal_4;
        else
            point_1 = 2+(level-1)*4;
            point_2 = 4+(level-1)*4;  
            
            % get symmetric points
            original_point(:,1) = point{1};
            original_point(:,2) = point{3};
            A = plane_c(2); B = plane_c(3); C = -1; D = plane_c(1);
            k = -(A*original_point(1,:)+B*original_point(2,:)+C*original_point(3,:)+D)/(A^2+B^2+C^2);    
            symm_point(1,:) = 2*(original_point(1,:)+A*k)-original_point(1,:);
            symm_point(2,:) = 2*(original_point(2,:)+B*k)-original_point(2,:);
            symm_point(3,:) = 2*(original_point(3,:)+C*k)-original_point(3,:);  
            
            % get weight mean points
            chosen_point(1,:) = symm_point(:,1)*0.5 + point{2}*0.5;
            chosen_point(2,:) = symm_point(:,2)*0.5 + point{4}*0.5;
        end
        
        % get symmtric points
        original_point(:,1) = chosen_point(1,:);
        original_point(:,2) = chosen_point(2,:);
        A = plane_c(2); B = plane_c(3); C = -1; D = plane_c(1);
        k = -(A*original_point(1,:)+B*original_point(2,:)+C*original_point(3,:)+D)/(A^2+B^2+C^2);    
        symm_point(1,:) = 2*(chosen_point(1:2,1)'+A*k)-chosen_point(1:2,1)';
        symm_point(2,:) = 2*(chosen_point(1:2,2)'+B*k)-chosen_point(1:2,2)';
        symm_point(3,:) = 2*(chosen_point(1:2,3)'+C*k)-chosen_point(1:2,3)';
       
        % get the other side  position
        point_3_position = find(left_order == point_1);
        if isempty(point_3_position)
            point_3_position = find(right_order == point_1);
            point_3 = left_order(point_3_position);
        else
            point_3 = right_order(point_3_position);
        end
        point_4_position = find(left_order == point_2);
        if isempty(point_4_position)
            point_4_position = find(right_order == point_2);
            point_4 = left_order(point_4_position);
        else
            point_4 = right_order(point_4_position);
        end
        
        % update a new model level
        S(:,point_1) = chosen_point(1,:)';
        S(:,point_2) = chosen_point(2,:)';
        S(:,point_3) = symm_point(:,1);
        S(:,point_4) = symm_point(:,2);
    end
   
end




