function drawBestFigure_CAD(cad, angle_x, angle_y, trans_x, trans_y, trans_z)
    
    % rotate with X axis
    angle = deg2rad(angle_x);
    rotation_X = [1,0,0;...
                  0,cos(angle),-sin(angle);...
                  0,sin(angle),cos(angle)];
    model_3D_w = cad.vertices * rotation_X;
    
    % rotate with Y axis
    angle = deg2rad(angle_y);
    rotation_Y = [cos(angle),0,sin(-angle);...
                  0,1,0;...
                  -sin(-angle),0,cos(angle)];
    model_3D_w = model_3D_w * rotation_Y;
    
    model_3D_w = bsxfun(@plus, model_3D_w', trans_x);
    %%%%%%%%%%%

    % for a better view
    angle = deg2rad(90);
    rotation_X = [1,0,0;...
                  0,cos(angle),-sin(angle);...
                  0,sin(angle),cos(angle)];
    model_3D_w = (model_3D_w' * rotation_X)';          
    model_3D_w = bsxfun(@plus, model_3D_w, trans_y);
    model_3D_w = bsxfun(@plus, model_3D_w, trans_z)';
        
    trisurf(cad.faces, model_3D_w(:,1), model_3D_w(:,2), model_3D_w(:,3), 'EdgeColor', 'b');
    
   
end