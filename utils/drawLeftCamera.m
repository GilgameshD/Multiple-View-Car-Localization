function drawLeftCamera(pose, model, camera)
    
    % model coordinates are in CAM1 
    model_3D = bsxfun(@plus, pose.R1*model', pose.T1);
    % transform to world coordinate
    model_3D_w = camera.cam{1}.R' * bsxfun(@minus, model_3D, camera.cam{1}.T);
    % transform to CAM1 coordinate
    model_3D = bsxfun(@plus, camera.cam{1}.R*model_3D_w, camera.cam{1}.T);
    % draw car points 
    plot3(model_3D(1,:), model_3D(2,:), model_3D(3,:), '.', 'markersize', 20);
    hold on
    
    mean_shape_x = model_3D(1,:);
    mean_shape_y = model_3D(2,:);
    mean_shape_z = model_3D(3,:);
    linewidth = 2;
    
    % draw wheels' lines
    line(mean_shape_x(1:2), mean_shape_y(1:2), mean_shape_z(1:2), 'linewidth', linewidth, 'color', 'y')
    line(mean_shape_x(3:4), mean_shape_y(3:4), mean_shape_z(3:4), 'linewidth', linewidth, 'color', 'y')
    line([mean_shape_x(2), mean_shape_x(4)], [mean_shape_y(2), mean_shape_y(4)], [mean_shape_z(2), mean_shape_z(4)], 'linewidth', linewidth, 'color', 'y')
    line([mean_shape_x(1), mean_shape_x(3)], [mean_shape_y(1), mean_shape_y(3)], [mean_shape_z(1), mean_shape_z(3)], 'linewidth', linewidth, 'color', 'y')
    % draw windows' lines
    line(mean_shape_x(5:6), mean_shape_y(5:6), mean_shape_z(5:6), 'linewidth', linewidth, 'color', 'g')
    line(mean_shape_x(7:8), mean_shape_y(7:8), mean_shape_z(7:8), 'linewidth', linewidth, 'color', 'g')
    line([mean_shape_x(5), mean_shape_x(8)], [mean_shape_y(5), mean_shape_y(8)], [mean_shape_z(5), mean_shape_z(8)], 'linewidth', linewidth, 'color', 'g')
    line([mean_shape_x(6), mean_shape_x(7)], [mean_shape_y(6), mean_shape_y(7)], [mean_shape_z(6), mean_shape_z(7)], 'linewidth', linewidth, 'color', 'g')
    % draw lights' lines
    line(mean_shape_x(9:10), mean_shape_y(9:10), mean_shape_z(9:10), 'linewidth', linewidth, 'color', 'r')
    line(mean_shape_x(11:12), mean_shape_y(11:12), mean_shape_z(11:12), 'linewidth', linewidth, 'color', 'r')
    line([mean_shape_x(9), mean_shape_x(12)], [mean_shape_y(9), mean_shape_y(12)], [mean_shape_z(9), mean_shape_z(12)], 'linewidth', linewidth, 'color', 'r')
    line([mean_shape_x(10), mean_shape_x(11)], [mean_shape_y(10), mean_shape_y(11)], [mean_shape_z(10), mean_shape_z(11)], 'linewidth', linewidth, 'color', 'r')
    % draw lowers' lines
    line([mean_shape_x(1), mean_shape_x(9)], [mean_shape_y(1), mean_shape_y(9)], [mean_shape_z(1), mean_shape_z(9)], 'linewidth', linewidth, 'color', 'c')
    line([mean_shape_x(2), mean_shape_x(12)], [mean_shape_y(2), mean_shape_y(12)], [mean_shape_z(2), mean_shape_z(12)], 'linewidth', linewidth, 'color', 'c')
    line([mean_shape_x(3), mean_shape_x(10)], [mean_shape_y(3), mean_shape_y(10)], [mean_shape_z(3), mean_shape_z(10)], 'linewidth', linewidth, 'color', 'c')
    line([mean_shape_x(4), mean_shape_x(11)], [mean_shape_y(4), mean_shape_y(11)], [mean_shape_z(4), mean_shape_z(11)], 'linewidth', linewidth, 'color', 'c')
    % draw upers' lines
    line([mean_shape_x(5), mean_shape_x(9)], [mean_shape_y(5), mean_shape_y(9)], [mean_shape_z(5), mean_shape_z(9)], 'linewidth', linewidth, 'color', 'c')
    line([mean_shape_x(8), mean_shape_x(12)], [mean_shape_y(8), mean_shape_y(12)], [mean_shape_z(8), mean_shape_z(12)], 'linewidth', linewidth, 'color', 'c')
    line([mean_shape_x(6), mean_shape_x(10)], [mean_shape_y(6), mean_shape_y(10)], [mean_shape_z(6), mean_shape_z(10)], 'linewidth', linewidth, 'color', 'c')
    line([mean_shape_x(7), mean_shape_x(11)], [mean_shape_y(7), mean_shape_y(11)], [mean_shape_z(7), mean_shape_z(11)], 'linewidth', linewidth, 'color', 'c')
    hold on
    
    Sx = [0,0,0;100,0,0]';
    Sy = [0,0,0;0,100,0]';
    Sz = [0,0,0;0,0,100]';
    
    drawCameraCoordinate(Sx,Sy,Sz,Sx,Sy,Sz,'k.');
    grid on;
end