function drawModelofGT(groundtruth, model_3D_w)

    plot3(groundtruth{1}(1,:), groundtruth{1}(2,:), groundtruth{1}(3,:), 'r.', 'markersize', 20);
    hold on
    %plot3(groundtruth{4}(1,:), groundtruth{4}(2,:), groundtruth{4}(3,:), 'y.', 'markersize', 50)
    %plot3(groundtruth{5}(1,:), groundtruth{5}(2,:), groundtruth{5}(3,:), 'y.', 'markersize', 50)
    plot3(0, 0, 0, 'y.', 'markersize', 40)
    %plot3(model_3D_w(1,:), model_3D_w(2,:), model_3D_w(3,:), 'r.', 'markersize', 20);
    % draw chessboard
    S.Vertices = [groundtruth{2}(1,1),groundtruth{2}(2,1),groundtruth{2}(3,1);...
                  groundtruth{2}(1,2),groundtruth{2}(2,2),groundtruth{2}(3,2);...
                  groundtruth{2}(1,3),groundtruth{2}(2,3),groundtruth{2}(3,3);...
                  groundtruth{2}(1,4),groundtruth{2}(2,4),groundtruth{2}(3,4)];
    S.Faces = [1,2,3,4];
    S.FaceColor = [0 206 209]/255;
    S.EdgeColor = [0 206 209]/255;
    h_plane = patch(S);
    
    % draw front light line to denote the front of the car
    line(groundtruth{1}(1,5:6), groundtruth{1}(2,5:6), groundtruth{1}(3,5:6), 'linewidth', 3)
    
    plot3(groundtruth{2}(1,1),groundtruth{2}(2,1),groundtruth{2}(3,1), '.',  'markersize', 10);
    set(h_plane,'FaceAlpha', 0.3,'HitTest', 'off');
    grid on; axis equal
    xlabel('X(cm)');
    ylabel('Y(cm)');
    zlabel('Z(cm)');
end