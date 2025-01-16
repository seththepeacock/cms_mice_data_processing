function[] = paint_processes(mouse_range, processes, all_ts, linewidth, colors, fig, heading, filename, savefigs)
mouse_start = mouse_range(1);
mouse_end = mouse_range(2);
num_of_processes = size(processes, 2);


    for this_mouse = mouse_start:mouse_end
        fignum = this_mouse*fig;
        figure(fignum);
        
        %plot original timeseries  
    
        time_series = all_ts(:, this_mouse);
        plot(time_series, 'Color', [0 0 0])
        title("Mouse " + this_mouse + " - " + heading);
    
        hold on
    
        for i = 1:num_of_processes
       
            t_start = processes(this_mouse, i, 1, 1);
            t_end = processes(this_mouse, i, 2, 1);
    
            if isnan(t_start) || isnan(t_end)
                continue
            end
            
            plot(t_start:t_end, time_series(t_start:t_end), 'Color', colors(i, :), 'LineWidth', linewidth);
            
        end
    
        if savefigs
            saveas(fignum, sprintf("Mouse " + this_mouse + " - "  + filename + ".jpg"))
        end

        close all

    end
end

