function[] = make_3D_plot(data_3D, x, y, z, black_num, filename, plot_title, filetype, fig_num)
    figure(fig_num);
    
    %CMS (green)
    h1 = stem3(data_3D(1:8,x),data_3D(1:8,y),data_3D(1:8,z),'Marker','o','MarkerFaceColor',[.23 .48 .34]);
    h1.Color =[.23 .48 .34];
    
    % this just retains the plots we just made while moving on to next plots
    hold on
    
    %control (red)
    h2 = stem3(data_3D(9:18,x),data_3D(9:18,y),data_3D(9:18,z),'Marker','o','MarkerFaceColor', 'r');
    h2.Color = 'r';
    
    if black_num ~= 0
        h1 = stem3(data_3D(black_num,x),data_3D(black_num,y),data_3D(black_num,z),'Marker','o','MarkerFaceColor',[0 0 0]);
    end

    axes_labels = ["Smallest Min", "Largest Max", ...
        "Largest VP", "Largest CVP", "Largest RVP",...
        "Largest TP", "Largest CTP", "Largest RTP", ...
        "Average VP", "Average CVP", "Average RVP", ...
        "Average TP", "Average CTP", "Average RTP",...
        "|Avg CVP - Avg RVP|", "|Max CVP - Max RVP|",...
        "|Avg CTP - Avg RTP|", "|Max CTP - Max RTP|",...
        "Max Slope", "Max CS", "Max RS",...
        "Avg Slope", "Avg CS", "Avg RS",...
        "|Avg CS - Avg RS|", "|Max CS - Max RS|",...
        "Var Slope", "Var CS", "Var RS", ...
        "Min Slope", "Min CS", "Min RS",...
        "Avg x to 60 Slope (x = 1,2,...,30)"];
   
    font_size = 10;

    x_name = axes_labels(x);
    y_name = axes_labels(y);
    z_name = axes_labels(z);

    xlabel(x_name,'FontSize',font_size)
    ylabel(y_name,'FontSize',font_size)
    zlabel(z_name,'FontSize',font_size)

    title(append(plot_title, string(x), ".", string(y), ".", string(z)));
    
    switch filetype
        case 'jpg'
            saveas(fig_num,sprintf(filename + ".jpg"))
        case 'fig' 
            saveas(fig_num, filename + ".fig")
        case 'both'
            saveas(fig_num,sprintf(filename + ".jpg"))
            saveas(fig_num, filename + ".fig")
        case 'neither'
    end

    close all
    
end

