close all; clc; clear all;

addpath('../../utils')
load('camera.mat');
cad_all = load('car.mat');
cad_all = cad_all.('car');

model_size = 400;
beyond_floor = 50;

cad = cad_all(3);
cad.vertices = cad.vertices * model_size;
cam_pair = 2;

figure('position',[500,500,600,500]);
drawBestFigure_CAD(cad, -90, 90, [200,0,0]', [0,10,0]', [0,0,beyond_floor+13]');
hold on
cad = cad_all(2);
cad.vertices = cad.vertices * model_size;
drawBestFigure_CAD(cad, -90, 90, [-300,0,0]', [0,-5,0]', [0,0,beyond_floor+5]');
hold on
cad = cad_all(5);
cad.vertices = cad.vertices * model_size;
drawBestFigure_CAD(cad, -90, 90, [-700,0,0]', [0,0,0]', [0,0,beyond_floor]');
%colormap winter
shading flat
hold on
showCameraForRealworld(stereoParams.CameraParameters1, cam_pair, 1);
hold on
showCameraForRealworld(stereoParams.CameraParameters2, cam_pair, 2);
% drawBestFigure_model(model, 90, -90, [200,0,0]', [0,10,0]');
% drawBestFigure_model(model, 90, -90, [-300,0,0]', [0,-10,0]');
% drawBestFigure_model(model, 90, -90, [-700,0,0]', [0,0,0]');
%axis off
%set(h,'FaceAlpha', 0.6,'HitTest', 'off');
axis([-1000, 700, -900, 200, 0, 400])

