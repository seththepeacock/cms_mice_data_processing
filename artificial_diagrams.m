close all
clear
clc

load artificial_processes.mat
load artificial_processes_2019.mat

A3D_2019 = artificial_coordinates3D_2019;
A3D_90 = artificial_coordinates3D_90;
A3D_75 = artificial_coordinates3D_75;
A3D_50 = artificial_coordinates3D_50;



%  MAKING PLOTS

% fig_num = 1;
% 
% x = 34;
% y = 29;
% z = 23;
% black_num = 14;
% file_name = string(x) + "." + string(y) + "." + string(z) + " #" + black_num + " is Black - A75";
% title = "A75 - Pure Separation Except Control #" + black_num + " (Black): ";
% make_3D_plot(A3D_90, x, y, z, black_num, file_name, title, 'both', 1)
% 





% for i = 35
%     for j = 19:34
%         for k = 19:34
%             if i == j || i == k || j == k
%                 continue
%             end
%             make_3D_plot(A3D_75, i, j, k, 0, string(i) + "." + string(j) + "." + string(k) + " - A75", 'Point Cloud of Artificially Extracted Features (75%, 5%, B): ', 'both', fig_num)
%             close all
%             fig_num = fig_num + 1;
%         end
%     end
% end

% x = 15;
% y = 7;
% z = 4;
% black_num = 0;
% file_name = string(x) + "." + string(y) + "." + string(z) + " - 2019";
% title = "Separation Except #6 - 2019 Comparison ";
% 
% make_3D_plot_2019(A3D_2019, x, y, z, black_num, file_name, title, 'both', 1)
    



% x = 7;
% y = 15;
% z = 8;
% black_num = 16;
% file_name = string(x) + "." + string(y) + "." + string(z) + " #" + black_num + " is Black - A90";
% title = "A90 - Pure Separation Except Control #" + black_num + " (Black): ";
% make_3D_plot(A3D_90, x, y, z, black_num, file_name, title, 'both', 1)


% x = 7;
% y = 5;
% z = 8;
% black_num = 16;
% file_name = string(x) + "." + string(y) + "." + string(z) + " #" + black_num + " is Black - A90";
% title = "A90 - Pure Separation Except Control #" + black_num + " (Black): ";
% make_3D_plot(A3D, x, y, z, black_num, file_name, title, 'both', 1)
    



