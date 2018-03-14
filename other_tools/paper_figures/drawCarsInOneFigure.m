close all; clc; clear all;

addpath(genpath('../../utils'));

% load camera parameters, camera pair decides
% but you should run realworldProcessCamera.m first
load('../camera.mat');
cam_pair = 1;

% load parameters
% R --- Rotation for all cars
% T --- Translation for all cars
% S --- model for all cars (not used if we show true cad models)
% come_form_cam --- denotes which camera the [R,T] comes from
load('result.mat');

% do some rotation to have a better show
cad = load('../car.mat');
cls = 'car';
cad = cad.(cls);

% show two cameras
showCameraForRealworld(stereoParams.CameraParameters1, cam_pair, 1); hold on
showCameraForRealworld(stereoParams.CameraParameters2, cam_pair, 2); hold on

% show cars
for i = 1 : car_num
    drawCameraAndCar(R{i}, T{i}, S{i}, camera, come_form_cam{i});
    hold on
    
    % draw a close CAD model, vertices should be rotated 
    show_number = 1;
    cad_now = cad.(cls);
    
    % camera coordinates for all vertices
    model_3D = bsxfun(@plus, R{i}*cad_now(show_number).vertices', T{i});
    % transform to world coordinate
    cad_vertices = (bsxfun(@minus, model_3D, camera.cam{come_form_cam{i}}.T)'*camera.cam{come_form_cam{i}}.R')';
   
    trisurf(cad_now(show_number).faces, ...
            cad_vertices(:,1), ...
            cad_vertices(:,2), ...
            cad_vertices(:,3), ...
            'EdgeColor', 'b');
end

% draw ground plane (y)
[x,z] = meshgrid(-1000:10:1000);
y = 0*x+200;
c = [181,181,181]/255;
mesh(x,y,z,'EdgeColor',c)
axis equal

