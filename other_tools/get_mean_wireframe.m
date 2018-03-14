clear all; clc; close all;

cad_model_path = './';
load(strcat(cad_model_path, 'car.mat'));

[~, all_number] = size(car);
all_parts_for_all_car = cell(all_number, 12);

for model_num = 1 : all_number
    all_parts_for_all_car{model_num, 1} = car(model_num).left_front_wheel;
    all_parts_for_all_car{model_num, 2} = car(model_num).left_back_wheel;
    all_parts_for_all_car{model_num, 3} = car(model_num).right_front_wheel;
    all_parts_for_all_car{model_num, 4} = car(model_num).right_back_wheel;
    all_parts_for_all_car{model_num, 5} = car(model_num).upper_left_windshield;
    all_parts_for_all_car{model_num, 6} = car(model_num).upper_right_windshield;
    all_parts_for_all_car{model_num, 7} = car(model_num).upper_left_rearwindow;
    all_parts_for_all_car{model_num, 8} = car(model_num).upper_right_rearwindow;
    all_parts_for_all_car{model_num, 9} = car(model_num).left_front_light;
    all_parts_for_all_car{model_num, 10} = car(model_num).right_front_light;
    all_parts_for_all_car{model_num, 11} = car(model_num).left_back_trunk;
    all_parts_for_all_car{model_num, 12} = car(model_num).right_back_trunk;
end

mean_shape_x = zeros(12,1);
mean_shape_y = zeros(12,1);
mean_shape_z = zeros(12,1);

for i = 1 : all_number
    for j = 1 : 12
        if ~isempty(all_parts_for_all_car{i, j})
            mean_shape_x(j) = mean_shape_x(j) + all_parts_for_all_car{i,j}(1);
            mean_shape_y(j) = mean_shape_y(j) + all_parts_for_all_car{i,j}(2);
            mean_shape_z(j) = mean_shape_z(j) + all_parts_for_all_car{i,j}(3);
        end
    end
end

mean_shape_x = mean_shape_x ./ 12;
mean_shape_y = mean_shape_y ./ 12;
mean_shape_z = mean_shape_z ./ 12;

figure
plot3(mean_shape_x, mean_shape_y, mean_shape_z, '.', 'markersize', 40);
hold on
% draw wheels' lines
line(mean_shape_x(1:2), mean_shape_y(1:2), mean_shape_z(1:2), 'linewidth', 5, 'color', 'y')
line(mean_shape_x(3:4), mean_shape_y(3:4), mean_shape_z(3:4), 'linewidth', 5, 'color', 'y')
line([mean_shape_x(2), mean_shape_x(4)], [mean_shape_y(2), mean_shape_y(4)], [mean_shape_z(2), mean_shape_z(4)], 'linewidth', 5, 'color', 'y')
line([mean_shape_x(1), mean_shape_x(3)], [mean_shape_y(1), mean_shape_y(3)], [mean_shape_z(1), mean_shape_z(3)], 'linewidth', 5, 'color', 'y')
% draw windows' lines
line(mean_shape_x(5:6), mean_shape_y(5:6), mean_shape_z(5:6), 'linewidth', 5, 'color', 'g')
line(mean_shape_x(7:8), mean_shape_y(7:8), mean_shape_z(7:8), 'linewidth', 5, 'color', 'g')
line([mean_shape_x(5), mean_shape_x(8)], [mean_shape_y(5), mean_shape_y(8)], [mean_shape_z(5), mean_shape_z(8)], 'linewidth', 5, 'color', 'g')
line([mean_shape_x(6), mean_shape_x(7)], [mean_shape_y(6), mean_shape_y(7)], [mean_shape_z(6), mean_shape_z(7)], 'linewidth', 5, 'color', 'g')
% draw lights' lines
line(mean_shape_x(9:10), mean_shape_y(9:10), mean_shape_z(9:10), 'linewidth', 5, 'color', 'r')
line(mean_shape_x(11:12), mean_shape_y(11:12), mean_shape_z(11:12), 'linewidth', 5, 'color', 'r')
line([mean_shape_x(9), mean_shape_x(12)], [mean_shape_y(9), mean_shape_y(12)], [mean_shape_z(9), mean_shape_z(12)], 'linewidth', 5, 'color', 'r')
line([mean_shape_x(10), mean_shape_x(11)], [mean_shape_y(10), mean_shape_y(11)], [mean_shape_z(10), mean_shape_z(11)], 'linewidth', 5, 'color', 'r')
% draw lowers' lines
line([mean_shape_x(1), mean_shape_x(9)], [mean_shape_y(1), mean_shape_y(9)], [mean_shape_z(1), mean_shape_z(9)], 'linewidth', 5, 'color', 'c')
line([mean_shape_x(2), mean_shape_x(12)], [mean_shape_y(2), mean_shape_y(12)], [mean_shape_z(2), mean_shape_z(12)], 'linewidth', 5, 'color', 'c')
line([mean_shape_x(3), mean_shape_x(10)], [mean_shape_y(3), mean_shape_y(10)], [mean_shape_z(3), mean_shape_z(10)], 'linewidth', 5, 'color', 'c')
line([mean_shape_x(4), mean_shape_x(11)], [mean_shape_y(4), mean_shape_y(11)], [mean_shape_z(4), mean_shape_z(11)], 'linewidth', 5, 'color', 'c')
% draw upers' lines
line([mean_shape_x(5), mean_shape_x(9)], [mean_shape_y(5), mean_shape_y(9)], [mean_shape_z(5), mean_shape_z(9)], 'linewidth', 5, 'color', 'c')
line([mean_shape_x(8), mean_shape_x(12)], [mean_shape_y(8), mean_shape_y(12)], [mean_shape_z(8), mean_shape_z(12)], 'linewidth', 5, 'color', 'c')
line([mean_shape_x(6), mean_shape_x(10)], [mean_shape_y(6), mean_shape_y(10)], [mean_shape_z(6), mean_shape_z(10)], 'linewidth', 5, 'color', 'c')
line([mean_shape_x(7), mean_shape_x(11)], [mean_shape_y(7), mean_shape_y(11)], [mean_shape_z(7), mean_shape_z(11)], 'linewidth', 5, 'color', 'c')
grid on
axis equal

% display cad model
show_number = 2;
figure
cad = load(strcat(cad_model_path, 'car.mat'));
cls = 'car';
cad = cad.(cls);
trisurf(cad(show_number).faces, cad(show_number).vertices(:,1), cad(show_number).vertices(:,2), cad(show_number).vertices(:,3), 'EdgeColor', 'b');
axis equal

model = [mean_shape_x, mean_shape_y, mean_shape_z];
save('model.mat', 'model');

