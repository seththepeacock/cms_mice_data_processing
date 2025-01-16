close all
clear


% 
% %DO ALGORITHM (ORIGINAL)
% 
all_ts = readmatrix("Only_CMS_vs_Control.xlsx");
%set parameters
max_number_of_pairs = 90;
persistence_threshold_percent = 0.05;
spike_comparison_percent = 0.90;
comparison_method = 'B';
average_threshold_percent = 0.15;

artificial_processes_90 = extract_processes(all_ts, persistence_threshold_percent, spike_comparison_percent, comparison_method, max_number_of_pairs);
artificial_coordinates3D_90 = extract_coordinates(artificial_processes_90, max_number_of_pairs, all_ts, average_threshold_percent);

spike_comparison_percent = 0.75;

artificial_processes_75 = extract_processes(all_ts, persistence_threshold_percent, spike_comparison_percent, comparison_method, max_number_of_pairs);
artificial_coordinates3D_75 = extract_coordinates(artificial_processes_75, max_number_of_pairs, all_ts, average_threshold_percent);

spike_comparison_percent = 0.50;

artificial_processes_50 = extract_processes(all_ts, persistence_threshold_percent, spike_comparison_percent, comparison_method, max_number_of_pairs);
artificial_coordinates3D_50 = extract_coordinates(artificial_processes_50, max_number_of_pairs, all_ts, average_threshold_percent);


%(mouse num, pair num, birth or death, time or value)

save artificial_processes.mat ...
    artificial_processes_90 artificial_coordinates3D_90 ...
    artificial_processes_75 artificial_coordinates3D_75 ...
    artificial_processes_50 artificial_coordinates3D_50



% %DO 2019 ALGORITHM
% 
% all_ts = readmatrix("2019_Data_Only_CMS_vs_Control");
% %set parameters
% max_number_of_pairs = 30;
% persistence_threshold_percent = 0.05;
% spike_comparison_percent = 0.9;
% comparison_method = 'B';
% average_threshold_percent = 0.15;
% 
% artificial_processes_2019 = extract_processes(all_ts, persistence_threshold_percent, spike_comparison_percent, comparison_method, max_number_of_pairs);
% artificial_coordinates3D_2019 = extract_coordinates(artificial_processes_2019, max_number_of_pairs, all_ts, average_threshold_percent);
% %(mouse num, pair num, birth or death, time or value)
% 
% save artificial_processes_2019.mat artificial_processes_2019 artificial_coordinates3D_2019



%PAINTING PROCESSES

% colors = construct_colors(max_number_of_pairs);
% %pick sorting/plotting parameters
% mouse_range = [1, 18];
% linewidth = 2;
% heading = "Painted Processes (75%, 5%, B)";
% filename = "Painted Processes (75, 5, B)";
% savefigs = true;


% paint_processes(mouse_range, artificial_processes, all_ts, linewidth, colors, 1, heading, filename, savefigs);
 


% colors = construct_colors(20);
% %pick sorting/plotting parameters
% mouse_range = [16, 16];
% linewidth = 1;
% heading = "Time Series of Serotonin Concentration";
% filename = "Painted Time Series";
% savefigs = false;
% 
% 
% paint_processes(mouse_range, artificial_processes_75, all_ts, linewidth, colors, 1, heading, filename, savefigs);
% 

















     



