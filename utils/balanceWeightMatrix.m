% this function balance the wight of CAM1 and CAM2, using the visibility of the keypoint 
% and the viewpoint of the 2D image. 

function [D, associated_D] = balanceWeightMatrix(score, camera)
    
    % how to judge visibility?
    % we use mean value of the score, those below mean value is unvisible,
    % and this point from the other view score will be higher
    scale = 0.05;
    index_plus = zeros(1,12);
    index_minus = zeros(1,12);
    
    visibility_minus = score{1}-score{2};
    index_plus(visibility_minus>0) = 1;
    index_minus(visibility_minus<0) = 1;
    
    score{1} = score{1} + index_plus.*score{1}*scale - index_minus.*score{1}*scale;
    score{2} = score{2} - index_plus.*score{2}*scale + index_minus.*score{2}*scale;
    
    % enlarge the difference
    D{1} = score{1}.^15;
    D{2} = score{2}.^15;
    
    [D, associated_D] = normalizeWeightMatrix(D, camera.camera_number);
end










