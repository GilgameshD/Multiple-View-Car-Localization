close all; clc; clear all;

datapath = '../../webots/';
addpath(genpath('../../utils'));


cad = load(strcat(datapath, 'car.mat'));
cad = cad.('car');
cad = cad(2);
dict = getPascalTemplate(cad);
model = centralize(dict.mu);
% set initial model scale
model_3D_w = model.*95;

mean_shape_x = model_3D_w(1,:);
mean_shape_y = model_3D_w(2,:);
mean_shape_z = model_3D_w(3,:);
linewidth = 2;

% draw car points 
hAxes = figure;
xlabel('X (cm)');
ylabel('Y (cm)');
zlabel('Z (cm)');
hold on
plot3(mean_shape_x, mean_shape_y, mean_shape_z, '.', 'markersize', 25);
hold on

wheel_color  = [255 215 0]/255.0;     % yellow
light_color  = [255 106 106]/255.0;   % red
window_color = [192 255 62]/255.0;    % green

alpha = 0.3;
wheel_face_color = [1,1,0];%[255 236 139]/255;
light_face_color = [1,0,0];%[255 160 122]/255;
window_face_color = [0,1,0];%[193 255 193]/255;

% draw wheels' lines
line(mean_shape_x(1:2), mean_shape_y(1:2), mean_shape_z(1:2), 'linewidth', linewidth, 'color', wheel_color)
line(mean_shape_x(3:4), mean_shape_y(3:4), mean_shape_z(3:4), 'linewidth', linewidth, 'color', wheel_color)
line([mean_shape_x(2), mean_shape_x(4)], [mean_shape_y(2), mean_shape_y(4)], [mean_shape_z(2), mean_shape_z(4)], 'linewidth', linewidth, 'color', wheel_color)
line([mean_shape_x(1), mean_shape_x(3)], [mean_shape_y(1), mean_shape_y(3)], [mean_shape_z(1), mean_shape_z(3)], 'linewidth', linewidth, 'color', wheel_color)
points = [mean_shape_x(1:4); mean_shape_y(1:4); mean_shape_z(1:4)]';
drawCarPlane(points, wheel_face_color, wheel_color, alpha, true);
% draw lowers' lines
line([mean_shape_x(1), mean_shape_x(9)], [mean_shape_y(1), mean_shape_y(9)], [mean_shape_z(1), mean_shape_z(9)], 'linewidth', linewidth, 'color', 'c')
line([mean_shape_x(2), mean_shape_x(12)], [mean_shape_y(2), mean_shape_y(12)], [mean_shape_z(2), mean_shape_z(12)], 'linewidth', linewidth, 'color', 'c')
line([mean_shape_x(3), mean_shape_x(10)], [mean_shape_y(3), mean_shape_y(10)], [mean_shape_z(3), mean_shape_z(10)], 'linewidth', linewidth, 'color', 'c')
line([mean_shape_x(4), mean_shape_x(11)], [mean_shape_y(4), mean_shape_y(11)], [mean_shape_z(4), mean_shape_z(11)], 'linewidth', linewidth, 'color', 'c')
% draw lights' lines
line(mean_shape_x(9:10), mean_shape_y(9:10), mean_shape_z(9:10), 'linewidth', linewidth, 'color', light_color)
line(mean_shape_x(11:12), mean_shape_y(11:12), mean_shape_z(11:12), 'linewidth', linewidth, 'color', light_color)
line([mean_shape_x(9), mean_shape_x(12)], [mean_shape_y(9), mean_shape_y(12)], [mean_shape_z(9), mean_shape_z(12)], 'linewidth', linewidth, 'color', light_color)
line([mean_shape_x(10), mean_shape_x(11)], [mean_shape_y(10), mean_shape_y(11)], [mean_shape_z(10), mean_shape_z(11)], 'linewidth', linewidth, 'color', light_color)
points = [mean_shape_x(9:12); mean_shape_y(9:12); mean_shape_z(9:12)]';
drawCarPlane(points, light_face_color, light_color, alpha, false);
% draw upers' lines
line([mean_shape_x(5), mean_shape_x(9)], [mean_shape_y(5), mean_shape_y(9)], [mean_shape_z(5), mean_shape_z(9)], 'linewidth', linewidth, 'color', 'c')
line([mean_shape_x(8), mean_shape_x(12)], [mean_shape_y(8), mean_shape_y(12)], [mean_shape_z(8), mean_shape_z(12)], 'linewidth', linewidth, 'color', 'c')
line([mean_shape_x(6), mean_shape_x(10)], [mean_shape_y(6), mean_shape_y(10)], [mean_shape_z(6), mean_shape_z(10)], 'linewidth', linewidth, 'color', 'c')
line([mean_shape_x(7), mean_shape_x(11)], [mean_shape_y(7), mean_shape_y(11)], [mean_shape_z(7), mean_shape_z(11)], 'linewidth', linewidth, 'color', 'c')
% draw windows' lines
line(mean_shape_x(5:6), mean_shape_y(5:6), mean_shape_z(5:6), 'linewidth', linewidth, 'color', window_color)
line(mean_shape_x(7:8), mean_shape_y(7:8), mean_shape_z(7:8), 'linewidth', linewidth, 'color', window_color)
line([mean_shape_x(5), mean_shape_x(8)], [mean_shape_y(5), mean_shape_y(8)], [mean_shape_z(5), mean_shape_z(8)], 'linewidth', linewidth, 'color', window_color)
line([mean_shape_x(6), mean_shape_x(7)], [mean_shape_y(6), mean_shape_y(7)], [mean_shape_z(6), mean_shape_z(7)], 'linewidth', linewidth, 'color', window_color)
points = [mean_shape_x(5:8); mean_shape_y(5:8); mean_shape_z(5:8)]';
drawCarPlane(points, window_face_color, window_color, alpha, false);
axis equal;
axis off;

% draw CAD model
figure
h = trisurf(cad.faces, ...
        cad.vertices(:,1), ...
        cad.vertices(:,2), ...
        cad.vertices(:,3), ...
        'EdgeColor', 'b');
%shading flat
axis equal
%axis off
hold on
annotation(:,1) = cad.left_front_wheel;
annotation(:,2) = cad.left_back_wheel;
annotation(:,3) = cad.right_front_wheel;
annotation(:,4) = cad.right_back_wheel;
annotation(:,5) = cad.upper_left_windshield;
annotation(:,6) = cad.upper_right_windshield;
annotation(:,7) = cad.upper_left_rearwindow;
annotation(:,8) = cad.upper_right_rearwindow;
annotation(:,9) = cad.left_front_light;
annotation(:,10) = cad.right_front_light;
annotation(:,11) = cad.left_back_trunk;
annotation(:,12) = cad.right_back_trunk;
plot3(annotation(1,:), annotation(2,:), annotation(3,:), 'r.', 'markersize', 40);
set(h,'FaceAlpha', 0.6,'HitTest', 'off');
%set(gcf,'color','black')
%grid off
