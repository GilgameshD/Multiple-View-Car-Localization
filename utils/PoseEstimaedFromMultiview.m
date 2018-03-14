% this function uses multiple cameras' view to estimate 3D pose of a car, there will be four stages, each for one camera projection.

% -----------------  there are some parameters can be adjusted -----------------
% [1] max_iterations
% [2] shape adjustment minminal error;
% [3] balance weight matrix methods (two methods)
% [4] shape adjustment start point
% [5] shape adjustment count
% [6] do shape adjustment every time or not
% [7] shape adjustment max distance tolerance
% [8] model initial size
% ------------------------------------------------------------------------------

function [fval, estimated_pose] = PoseEstimaedFromMultiview(heatpoint_2D, W_hg, initialPose, D, model, camera, center, scale)
    
    % initialize const parameters
    max_iterations = 4000;
    min_error = 1e-19;
    shape_adjustment_error = 1e-2;
    curr_value = inf;
    min_shape = 3000;
    shape_count = 6;
        
    % normalize weight matrix, in order to communite with each other
    % associated_D means normalizing all cameras' score, this var can be used to combine two camera
    [D, associated_D] = balanceWeightMatrix(D, camera);
    
    % when doing ierations, the model must be in left camera coordinate
    S = model';
    
%     D{1}(9) = 0;
%     D{1}(10) = 0;
%     D{2}(5) = 0;
%     D{2}(6) = 0;
%     D{2}(7) = 0;
%     D{2}(8) = 0;
%     D{2}(9) = 0;
%     D{2}(10) = 0;
%     D{2}(11) = 0;
%     D{2}(12) = 0;

    
    D{1} = diag(D{1});
    D{2} = diag(D{2});
    
    % initialize pose parameters
    R1 = [1,0,0;0,1,0;0,0,1];%initialPose.R1; 
    R2 = R1;
    T1 = mean(W_hg{1},2)*mean(std(R1(1:2,:)*S,1,2))/(mean(std(W_hg{1},1,2))+eps); 
    T2 = T1;
    
    W1 = W_hg{1}; 
    W2 = W_hg{2}; 
    
    start_to_shape = 0;
    t0 = tic;
    for iteration = 1 : max_iterations
        %% [stage one]   --- projection between CAM1 and 3D model
        % - get depth of 2D position
        % - maybe this method can give 2D point a depth form the view of 3D model
        Z1 = sum(W1.*bsxfun(@plus,R1*S,T1),1)./(sum(W1.^2,1)+eps);
        % - update R and T by aligning S to W*diag(Z) (normalized)
        % - Sp represents the view of left camera
        Sp1 = W1*diag(Z1);
        T1 = sum((Sp1-R1*S)*D{1},2)/(sum(diag(D{1}))+eps);
        St = bsxfun(@minus,Sp1,T1);
        [U,~,V] = svd(St*D{1}*S'); 
        R1 = U*diag([1,1,sign(det(U*V'))])*V';
        % - get error function 
        %fval{1}(iteration) = norm((St-R1*S)*sqrt(D{1}), 'fro')^2;
        
        
        %% [stage two]   --- projection between CAM2 and 3D model 
        % - get depth of 2D position
        Z2 = sum(W2.*bsxfun(@plus,R2*S,T2),1)./(sum(W2.^2,1)+eps);
        % - update R and T by aligning S to W*diag(Z) (normalized)
        Sp2 = W2*diag(Z2);
        T2 = sum((Sp2-R2*S)*D{2},2)/(sum(diag(D{2}))+eps);
        St = bsxfun(@minus,Sp2,T2);
        [U,~,V] = svd(St*D{2}*S'); 
        R2 = U*diag([1,1,sign(det(U*V'))])*V';
        
        
        %% [stage three] --- update weight according to two cameras' projection error
        % - get four projection error
        error_L2L = projectionError('L2L', R1, T1, heatpoint_2D{1}, S, camera, center{1}, scale{1});
        error_L2R = projectionError('L2R', R1, T1, heatpoint_2D{2}, S, camera, center{2}, scale{2});
        error_R2L = projectionError('R2L', R2, T2, heatpoint_2D{1}, S, camera, center{1}, scale{1});
        error_R2R = projectionError('R2R', R2, T2, heatpoint_2D{2}, S, camera, center{2}, scale{2});
        %[D, associated_D] = updateWeightMatrix(error_L2R, error_R2L, D, associated_D, camera.camera_number);       
        
        
        %% [stage four] --- shape adjustment, using hierarchical wireframe model
        fval{1}(iteration) = sum(error_L2L.*sqrt(diag(D{1})'))+sum(error_L2R.*sqrt(diag(D{2})'));
        fval{2}(iteration) = sum(error_R2R.*sqrt(diag(D{1})'))+sum(error_R2L.*sqrt(diag(D{2})'));
        fval{3}(iteration) = fval{1}(iteration) + fval{2}(iteration);
        last_value = curr_value;
        curr_value = fval{3}(iteration);
       
        if (abs(last_value-curr_value)/(last_value+eps) < shape_adjustment_error || start_to_shape == 1) && iteration > min_shape
            start_to_shape = 1;
            
            S = shapeAdjustment(S, D, R1, R2, T1, T2, heatpoint_2D, camera, center, scale);
            
            shape_count = shape_count - 1;
            fprintf('Done shape adjustment --- [ITERATION]: %d [SHAPE ADJUSTMENT]: %d\n', iteration, shape_count);
        else
            fprintf('NO shape adjustment --- [ITERATION]: %d \n', iteration);
        end
       
        
        %% [stage five]  --- get energetic function and check convergence
        % - save last value 
        % - check convergence
        if abs(last_value-curr_value)/(last_value+eps) < min_error
            break;
        end
        
        if shape_count == 0
            break;
        end
        
    end
   
    % outputs
    estimated_pose.R1 = R1;
    estimated_pose.T1 = T1;
    estimated_pose.R2 = R2;
    estimated_pose.T2 = T2;
    estimated_pose.score = D;
    estimated_pose.S = S';
    estimated_pose.time = toc(t0);
end






