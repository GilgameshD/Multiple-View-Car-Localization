close all; clc; clear all
 
original_size = 500;

img_to_be_shown{1} = imread('../../realworld/1.jpg');
img_to_be_shown{2} = imread('../../realworld/2.jpg');

c = [0,114,189]/255;
s = [1920, 1080]/4;
% left camera
load 'model_2D_car1_left.mat'
figure('position',[0,0,s(1),s(2)]);
subplot('position',[0,0,1,1]); imshow(img_to_be_shown{1}); hold on;
% draw points and lines
drawFrame(model_2D_1(1,:), model_2D_1(2,:), 2);
plot(model_2D_1(1,:), model_2D_1(2,:), '.', 'markersize', 15);
load 'model_2D_car2_left.mat'
drawFrame(model_2D_1(1,:), model_2D_1(2,:), 2);
plot(model_2D_1(1,:), model_2D_1(2,:), '.', 'markersize', 15, 'color', c);
load 'model_2D_car3_left.mat'
drawFrame(model_2D_1(1,:), model_2D_1(2,:), 2);
plot(model_2D_1(1,:), model_2D_1(2,:), '.', 'markersize', 15, 'color', c);


load 'model_2D_car1_right.mat'
figure('position',[0,0,s(1),s(2)]);
subplot('position',[0,0,1,1]); imshow(img_to_be_shown{2}); hold on;
drawFrame(model_2D_2(1,:), model_2D_2(2,:), 2);
plot(model_2D_2(1,:), model_2D_2(2,:), '.', 'markersize', 15);
load 'model_2D_car2_right.mat'
drawFrame(model_2D_2(1,:), model_2D_2(2,:), 2);
plot(model_2D_2(1,:), model_2D_2(2,:), '.', 'markersize', 15, 'color', c);
load 'model_2D_car3_right.mat'
drawFrame(model_2D_2(1,:), model_2D_2(2,:), 2);
plot(model_2D_2(1,:), model_2D_2(2,:), '.', 'markersize', 15, 'color', c);




