clear

% 8 CMS and 10 Control = 18 columns
% 50 rows; 1-25 for mins, 26-50 for maxes


% this is just the data
raw_data = readmatrix("Only_CMS_vs_Control.xlsx");
max_number_of_pairs = 25;
[num_of_readings, num_of_mice] = size(raw_data);

LGPD_processes = NaN(num_of_mice, max_number_of_pairs, 2);
RGPD_processes = NaN(num_of_mice, max_number_of_pairs, 2);




%MAKE LEFT

%pick the j-th mouse
for this_mouse = 1:num_of_mice
    paired_maxes = 0;
    %pick the i-th minute (first and last readings can't be extrema)
    for i = 2:num_of_readings - 1
        %store this reading and the adjacent ones
        previous_val = raw_data(i-1, this_mouse);
        this_val = raw_data(i, this_mouse);
        next_val = raw_data(i+1, this_mouse);
        if this_val > previous_val && this_val > next_val
            found_max = this_val;
            %now we iterate through all the previous values to find the
            %nearest min on the left
            for m = i-1:-1:2
                previous_val = raw_data(m-1, this_mouse);
                this_val = raw_data(m, this_mouse);
                next_val = raw_data(m+1, this_mouse);
                %check if this one is a min
                if this_val < previous_val && this_val < next_val
                    paired_maxes = paired_maxes + 1;
                    nearest_left_min=this_val;
                    %add the min to output data
                    LGPD_processes(this_mouse, paired_maxes, 1) = nearest_left_min;
                    %add the max to output data
                    LGPD_processes(this_mouse, paired_maxes, 2) = found_max;
                    break
                end
                %note that if this is there is no min to the left of this
                %max, nothing is added to processed_data
            end
        end
    end
end



%  MAKE RIGHT

%pick the j-th mouse
for this_mouse = 1:num_of_mice
    paired_maxes = 0;
    %pick the i-th minute (first and last readings can't be extrema)
    for i = 2:num_of_readings - 1
        %store this reading and the adjacent ones
        previous_val = raw_data(i-1, this_mouse);
        this_val = raw_data(i, this_mouse);
        next_val = raw_data(i+1, this_mouse);
        if this_val > previous_val && this_val > next_val
            found_max = this_val;
            %now we iterate through all the previous values to find the
            %nearest min on the RIGHT
            for m = i+1:1:num_of_readings - 1
                previous_val = raw_data(m-1, this_mouse);
                this_val = raw_data(m, this_mouse);
                next_val = raw_data(m+1, this_mouse);
                %check if this one is a min
                if this_val < previous_val && this_val < next_val
                    paired_maxes = paired_maxes + 1;
                    nearest_right_min=this_val;
                    %add the min to output data
                    RGPD_processes(this_mouse, paired_maxes, 1) = nearest_right_min;
                    %add the max to output data
                    RGPD_processes(this_mouse, paired_maxes, 2) = found_max;
                    break
                end
                %note that if this is there is no min to the right of this
                %max, nothing is added to processed_data
            end
        end
    end
end

%extract stuff for Left 3D
LGPD_coordinates3D = NaN(num_of_mice, 3);

for this_mouse = 1:num_of_mice
    all_mins = LGPD_processes(this_mouse, 1:max_number_of_pairs, 1);
    all_maxes = LGPD_processes(this_mouse, 1:max_number_of_pairs, 2);
    all_persistences = all_maxes - all_mins;
    smallest_min = min(all_mins);
    largest_min = max(all_mins);
    max_persistence = max(all_persistences);
    LGPD_coordinates3D(this_mouse, 1) = smallest_min;
    LGPD_coordinates3D(this_mouse, 2) = largest_min;
    LGPD_coordinates3D(this_mouse, 3) = max_persistence;
end


%extract features for Right 3D
RGPD_coordinates_3D = NaN(num_of_mice, 3);

for this_mouse = 1:num_of_mice
    all_mins = RGPD_processes(this_mouse, 1:max_number_of_pairs, 1);
    all_maxes = RGPD_processes(this_mouse, 1:max_number_of_pairs, 2);
    all_persistences = all_maxes - all_mins;
    smallest_min = min(all_mins);
    largest_min = max(all_mins);
    max_persistence = max(all_persistences);
    RGPD_coordinates_3D(this_mouse, 1) = smallest_min;
    RGPD_coordinates_3D(this_mouse, 2) = largest_min;
    RGPD_coordinates_3D(this_mouse, 3) = max_persistence;
end



save GPD_processes.mat LGPD_processes LGPD_coordinates3D RGPD_processes RGPD_coordinates_3D
