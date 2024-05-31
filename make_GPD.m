function[] = make_GPD(type, data, filename, filetype, fig_num)
    % LGPD containing all 18 mice
    for this_mouse = 1:8
        p_min = data(this_mouse, 1:25, 1, 2);
        p_max = data(this_mouse, 1:25, 2, 2);
        figure(fig_num)
        hold on
        plot(p_min,p_max,'d','MarkerFaceColor',[.23 .48 .34],'MarkerEdgeColor',[.23 .48 .34]) %.0 .4 .
    end
    for this_mouse = 9:18
        p_min = data(this_mouse, 1:25, 1, 2);
        p_max = data(this_mouse, 1:25, 2, 2);
        figure(fig_num)
        hold on
        plot(p_min,p_max,'d','MarkerFaceColor','r','MarkerEdgeColor','r')  % 0 .4 .6
    end
    
    xlabel('local minimum')
    ylabel('local maximum')
    %plot the dashed y=x line
    x = linspace(30,90,100);
    y = x;
    hold on
    
    plot(x,y,'--','Color',[.77 .38 .06])
    set(gca,'xlim',[36 83])
    set(gca,'xtick',(36:10:83))
    set(gca,'ylim',[36 83])
    set(gca,'ytick',(36:10:83))
    switch type
        case 'L'
            title('LGPD')
        case 'R'
            title ('RGPD')
        case 'P'
            title('Persistence Diagram')
    end
    
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
