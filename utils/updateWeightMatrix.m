function [D_out, associated_D] = updateWeightMatrix(error_L2R, error_R2L, D, associated_D, cam_num)
    
    % cross projection
    error_L2R = (error_L2R)./sum(error_L2R)*100;
    error_R2L = (error_R2L)./sum(error_R2L)*100;
    
    % socre between two camera
    visible_score_1 = associated_D{1}-associated_D{2};
    visible_score_2 = -visible_score_1;
    visible_score_1(visible_score_1<0)=0; 
    visible_score_2(visible_score_2<0)=0;
    
    visible_score_1 = visible_score_1./sum(visible_score_1)*100;
    visible_score_2 = visible_score_2./sum(visible_score_2)*100;
    
    % ===============================  UPDATE PRINCIPLE  ================================
    % (1) the larger the cross projection error is, the more adjustment it needs (compared to mean error)
    % (2) the larger the score is, the more accuracy it needs
    % (3) if one view has high score, the other has low score, higher the high one 
    % ===================================================================================
    c1 = 0.9;
    c2 = 0.05;
    c3 = 0.05;
    D_out{1} = diag(c1*D{1} + c2*diag(error_L2R)  + c3*diag(visible_score_1));  
    D_out{2} = diag(c1*D{2} + c2*diag(error_R2L) + c3*diag(visible_score_2));  
    
    % set negative value to 0
    D_out{1}(D_out{1}<0)=0; 
    D_out{2}(D_out{2}<0)=0;
    
    % normalizing
    [D_out, associated_D] = normalizeWeightMatrix(D_out, cam_num);
    
    % output
    D_out{1} = diag(D_out{1});
    D_out{2} = diag(D_out{2});

end