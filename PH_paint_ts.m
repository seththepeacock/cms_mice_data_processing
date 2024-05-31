close all
clear
clc

%get general stuff
load wishywashy_processes.mat
load broken_wishywashy_processes.mat
load release_processes.mat
load clearance_processes.mat
all_ts = readmatrix("Only_CMS_vs_Control.xlsx");

%construct colors
num_of_colors = 25;
colors = NaN(num_of_colors, 3);
for i = 1:num_of_colors
    colors(i, 1) = rand(1);
    colors(i, 2) = rand(1);
    colors(i, 3) = rand(1);    
end

%pick sorting/plotting parameters
sorting_type = "time";
sorting_direction = "descend";
disp_sorted_processes = true;
mouse_range = [1, 18];
linewidth = 2;
savefigs = true;
fig = 1;


paint_processes(mouse_range, wishywashy_processes, ...
    sorting_type, sorting_direction, disp_sorted_processes, all_ts, linewidth, colors, fig, 'Painted Processes', savefigs);




function[] = paint_processes(mouse_range, raw_processes, sorting_type, ...
    sorting_direction, disp_sorted_processes, all_ts, linewidth, colors, fig, heading, savefigs)
mouse_start = mouse_range(1);
mouse_end = mouse_range(2);
P = raw_processes;
num_of_mice = size(P, 1);
num_of_processes = size(P, 2);


for this_mouse = mouse_start:mouse_end
    close all
    
    persistences = NaN(num_of_processes, 1);
    time_persistences = NaN(num_of_processes, 1);

    sorted_processes = NaN(num_of_processes, 4);
        %pick either persistence value, t_start, or t_end

    
    
    %get the persistence of each process, in whatever original order
    for i = 1:num_of_processes
        val_min = P(this_mouse, i, 1, 2);
        val_max = P(this_mouse, i, 2, 2);

        if isnan(val_min) || isnan(val_max)
            continue
        end

        val_persistence = abs(val_min - val_max);

        persistences(i) = val_persistence;
        
    end

    
    
    

    for i = 1:num_of_processes
        t_min = P(this_mouse, i, 1, 1);
        t_max = P(this_mouse, i, 2, 1);

        if isnan(t_min) || isnan(t_max)
            continue
        end

        this_time_persistence = abs(t_min - t_max);

        time_persistences(i) = this_time_persistence;
        
    end
    
    %disp(time_persistences)

    %get the original indices of the processes sorted by time/val persistence 
    switch sorting_type
        case "time"
        [~, sorted_persistences_indices] = sort(time_persistences, sorting_direction);
        case "value"
        [~, sorted_persistences_indices] = sort(persistences, sorting_direction);
        case "none"
        sorted_persistences_indices = uint32(1):uint32(num_of_processes);
    end

    
    %disp(sorted_persistences_indices);
    
    %build sorted_processes array
    for j = 1:num_of_processes
        
        %i is the index of the process in the original sort
        i = sorted_persistences_indices(j);

        

        t_min = P(this_mouse, i, 1, 1);
        t_max = P(this_mouse, i, 2, 1);

        if isnan(t_min) || isnan(t_max)
            continue
        end

        t_start = min(t_min, t_max);
        t_end = max(t_min, t_max);
        time_persistence = abs(t_min - t_max);
        val_min = P(this_mouse, i, 1, 2);
        val_max = P(this_mouse, i, 2, 2);
        val_persistence = abs(val_min - val_max);
        

        
        %this is j because this starts at 1 and goes up to the number of
        %non-nan processes
        sorted_processes(j, 1) = t_start;
        sorted_processes(j, 2) = t_end;
        sorted_processes(j, 3) = val_persistence;
        sorted_processes(j, 4) = time_persistence;
        
    end

    if (disp_sorted_processes)
    
        disp('Mouse ' + string(this_mouse))
        for j = 1:num_of_processes
            t_start = sorted_processes(j, 1);
            t_end = sorted_processes(j, 2);
            val_persistence = sorted_processes(j, 3);
            time_persistence = sorted_processes(j, 4);
            disp('time persistence = ' + string(time_persistence) + ', t_start = ' + string(t_start) + ', t_end = ' + string(t_end))

        end

    end

    %now plot!
    fignum = this_mouse*fig;
    figure(fignum);
    
    %plot original timeseries  

    time_series = all_ts(:, this_mouse);

    plot(time_series, 'Color', [0 0 0])
    title(strcat(heading, ' Mouse #', string(this_mouse)));

    hold on
    num_of_processes = size(sorted_processes, 1);


    for i = 1:num_of_processes
        t_start = sorted_processes(i, 1);
        t_end = sorted_processes(i, 2);

        if isnan(t_start) || isnan(t_end)
            continue
        end

        ts = timeseries(time_series(t_start:t_end), t_start:t_end);


        plot(ts, 'Color', colors(i, :), 'LineWidth', linewidth);

        
    end

    if savefigs
        saveas(fignum, sprintf("PP Mouse " + this_mouse + ".jpg"))
    end
    
    
end
   

end





      



