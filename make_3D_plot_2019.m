function[] = make_3D_plot_2019(data_3D, x, y, z, black_num, filename, plot_title, filetype, fig_num)
    figure(fig_num);
    
    %Male (blue)
    h1 = stem3(data_3D(1:17,x),data_3D(1:17,y),data_3D(1:17,z),'Marker','o','MarkerFaceColor','b');
    h1.Color ='b';
    
    hold on
    
    %Female (red)
    h2 = stem3(data_3D(18:35,x),data_3D(18:35,y),data_3D(18:35,z),'Marker','o','MarkerFaceColor', 'r');
    h2.Color = 'r';

    %Control (green)
    h3 = stem3(data_3D(36:44,x),data_3D(36:44,y),data_3D(36:44,z),'Marker','o','MarkerFaceColor', 'g');
    h3.Color = 'g';

    
    
    if black_num ~= 0
        h4 = stem3(data_3D(black_num,x),data_3D(black_num,y),data_3D(black_num,z),'Marker','o','MarkerFaceColor',[0 0 0]);
    end

    axes_labels = ["Smallest Min", "Largest Max", ...
        "Largest VP", "Largest CVP", "Largest RVP",...
        "Largest TP", "Largest CTP", "Largest RTP", ...
        "Average VP", "Average CVP", "Average RVP", ...
        "Average TP", "Average CTP", "Average RTP"...
        "|Avg CVP - Avg RVP|", "|Max CVP - Max RVP|"];
   
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
    
end
    