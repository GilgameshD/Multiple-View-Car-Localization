function drawCarPlane3D(points, face_color, edge_color, alpha, wheel)
    hold on
    S.Vertices = points;
    if wheel
        S.Faces = [1,3,4,2];
    else
        S.Faces = [1,2,3,4];
    end
    S.FaceColor = face_color;
    S.EdgeColor = edge_color;
    h = patch(S);
    set(h,'FaceAlpha', alpha,'HitTest', 'off');
    hold on;
end