close all
clear
clc


load half_GPD_processes.mat
load GPD_processes.mat
load wishywashy_processes.mat

L = LGPD_processes;
R = RGPD_processes;
P = wishywashy_processes;
HL = half_LGPD_processes;
HR = half_RGPD_processes;


L3D = LGPD_coordinates3D;
R3D = RGPD_coordinates_3D;
P3D = wishywashy_coordinates3D;
HL3D = half_LGPD_coordinates3D;
HR3D = half_RGPD_coordinates_3D;


% make_3D_plot(BP3D, 6, 7, 8, '3 4 1.jpg', 'n', 1)
% make_GDP(P, 'Big Persistence Diag.jpg', 'jpg', 1)

fig_num = 1;

for i = 1:3
    for j = 1:3
        for k = 1:3
            if i == j || i == k || j == k
                continue
            end
            make_3D_plot(HL3D, i, j, k, string(i) + "." + string(j) + "." + string(k) + " - HLGPD.jpg", 'jpg', "HLGPD", fig_num)
            close all
            fig_num = fig_num + 1;
            make_3D_plot(HL3D, i, j, k, string(i) + "." + string(j) + "." + string(k) + " - HLGPD.fig", 'fig', "HLGPD", fig_num)
            close all
            fig_num = fig_num + 1;
            make_3D_plot(HR3D, i, j, k, string(i) + "." + string(j) + "." + string(k) + " - HRGPD.jpg", 'jpg', "HRGPD", fig_num)
            close all
            fig_num = fig_num + 1;
            make_3D_plot(HR3D, i, j, k, string(i) + "." + string(j) + "." + string(k) + " - HRGPD.fig", 'fig', "HRGPD", fig_num)
            close all
            fig_num = fig_num + 1;

        end
    end
end

% for i = 1:8
%     for j = 1:8
%         for k = 1:8
%             if i == j || i == k || j == k
%                 continue
%             end
%             make_3D_plot(P3D, i, j, k, string(i) + ' ' + string(j) + ' ' + string(k) + '.jpg', 'jpg', "PH", fig_num)
%             close all
%             fig_num = fig_num + 1;
%             make_3D_plot(P3D, i, j, k, string(i) + ' ' + string(j) + ' ' + string(k) + '.fig', 'fig', "PH", fig_num)
%             close all
%         end
%     end
% end

    
    
function[] = make_3D_plot(data_3D, x, y, z, filename, filetype, type_title, fig_num)
    figure(fig_num);
    
    %CMS (green)
    h1 = stem3(data_3D(1:8,x),data_3D(1:8,y),data_3D(1:8,z),'Marker','o','MarkerFaceColor',[.23 .48 .34]);
    h1.Color =[.23 .48 .34];
    
    % this just retains the plots we just made while moving on to next plots
    hold on
    
    %control (red)
    h1 = stem3(data_3D(9:18,x),data_3D(9:18,y),data_3D(9:18,z),'Marker','o','MarkerFaceColor', 'r');
    h1.Color = 'r';

    axes_labels = ["Smallest Min", "Largest Min", "Largest Value Persistence", ...
        "Largest Clearance Value Persistence", "Largest Release Value Persistence",...
        "Largest Time Persistence", "Largest Clearance Time Persistence", ...
        "Largest Release Time Persistence"];
   
    font_size = 10;

    x_name = axes_labels(x);
    y_name = axes_labels(y);
    z_name = axes_labels(z);

    xlabel(x_name,'FontSize',font_size)
    ylabel(y_name,'FontSize',font_size)
    zlabel(z_name,'FontSize',font_size)

    title(append("Point cloud of ",  type_title, " Extracted Features: ", string(x), string(y), string(z)));
    
    switch filetype
        case 'jpg'
            saveas(fig_num,sprintf(filename))
        case 'fig' 
            saveas(fig_num, filename)
        case 'n'
    end
    
end
    


function[] = make_GDP(type, data, filename, filetype, fig_num)
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
            saveas(fig_num,sprintf(filename))
        case 'fig' 
            saveas(fig_num, filename)
    end

end
