function [normalized_D, associated_D] = normalizeWeightMatrix(D, cam)
    
    % we can sum two camera score together because they come from the same ConvNet
    total_score = 0;
    for cam_num = 1 : cam
        total_score = sum(D{cam_num}) + total_score;
    end
    
    for cam_num = 1 : cam
        normalized_D{cam_num} = D{cam_num}./sum(D{cam_num})*100;
        associated_D{cam_num} = D{cam_num}./total_score*100;
    end   
end