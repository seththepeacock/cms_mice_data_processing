function[colors] = construct_colors(num_of_colors)
    colors = NaN(num_of_colors, 3);
    for i = 1:num_of_colors
        colors(i, 1) = 0;
        colors(i, 2) = 0;
        colors(i, 3) = 0;
        switch mod(i, 6)
            case 0
                colors(i, 1) = 1;
            case 1
                colors(i, 2) = 1;
            case 2
            case 3
                colors(i, 1) = 1;
                colors(i, 2) = 1;
            case 4
                colors(i, 2) = 1;
                colors(i, 3) = 1;
            case 5 
                colors(i, 1) = 1;
                colors(i, 3) = 1;
        end
    end
end