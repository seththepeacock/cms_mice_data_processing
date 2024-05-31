close all
clear

raw_data = readmatrix("Only_CMS_vs_Control.xlsx");
max_number_of_pairs = 25;
[num_of_readings, num_of_mice] = size(raw_data);

wishywashy_processes = NaN(num_of_mice, max_number_of_pairs, 2, 2);
%mouse num, pair num, min/max, time/value

%make an array that has indices of all maxes and mins, in order of smallest to
%largest (value of corresponding reading). mark it as a 0 if min and a 1 if max, 
% (later you will put it as a -1 once it's out) 
%then go through and match them up, starting with the largest min match it
%with whichever (out of the left or the right) is the closest aka the
%lowest

% note indices(i) is the time_series index of the ith smallest value

%grab the j-th mouse
for this_mouse = 1:num_of_mice
    extrema_num = 0;
    time_series = raw_data(:,this_mouse);
    [~, times_sorted_by_value] = sort(time_series);
    % iterate through the sorted_times to build sorted_extrema
    sorted_extrema = NaN(max_number_of_pairs * 2, 2);
    for i = 1:num_of_readings
        t = times_sorted_by_value(i);
        if check_is_min(t, time_series)
           %put the og time_series index of the min into the array
           extrema_num = extrema_num + 1;
           sorted_extrema(extrema_num, 1) = t;
           sorted_extrema(extrema_num, 2) = 0;
        end
     
        if check_is_max(times_sorted_by_value(i), time_series)
           extrema_num = extrema_num + 1;
           sorted_extrema(extrema_num, 1) = t;
           sorted_extrema(extrema_num, 2) = 1;
        end
    end

   
    %pair up mins with relevant max, starting at largest min
    pair_num = 0;
    for i_min = extrema_num:-1:1
        %check if this extrema is an (unpaired) min
        if sorted_extrema(i_min, 2) == 0
           t_of_current_min = sorted_extrema(i_min, 1);
           %now we have to find the closest *unpaired* max on the left and right

           %go to original timeseries, move to the left, find nearest left max

           left_max_value = [];
           left_max_t = [];
           left_max_extrema_index = [];
           found_left_max = false;
           for t = t_of_current_min:-1:1
               if check_is_max(t, time_series)
                   left_max_value = time_series(t);
                   
                   
                   %find the corresponding index in sorted;
                   %this way, we can check if its paired
                             
                   for sorted_extrema_index = 1:extrema_num
                       test_extrema_value = time_series(sorted_extrema(sorted_extrema_index, 1));
                       if  test_extrema_value == left_max_value
                           left_max_extrema_index = sorted_extrema_index;
                           break;
                       end
                   end 

                   %if unpaired, we're good! otherwise RESET THE VALUE and cont. march leftward
                   
                   if sorted_extrema(left_max_extrema_index, 2) == 1
                       left_max_value = time_series(t);
                       left_max_t = t;
                       found_left_max = true;
                       break;
                   end

                   left_max_value = [];
               end
           end
           
           %go to original timeseries, move to the right, find nearest right max

           right_max_value = [];
           right_max_t = [];
           right_max_extrema_index = [];
           found_right_max = false;
           for t = t_of_current_min:length(time_series)
               if check_is_max(t, time_series)
                   right_max_value = time_series(t);

                   %find the corresponding index in sorted_extrema_indices

                   for sorted_extrema_index = 1:extrema_num
                       test_extrema_value = time_series(sorted_extrema(sorted_extrema_index, 1));
                       if test_extrema_value == right_max_value
                           right_max_extrema_index = sorted_extrema_index;
                           break;
                       end
                   end 

                   %if unpaired, we're good! otherwise RESET THE VALUE and cont. march rightward

                   if sorted_extrema(right_max_extrema_index, 2) == 1
                       right_max_value = time_series(t);
                       right_max_t = t;
                       found_right_max = true;
                       break;
                   end
                   right_max_value = [];
               end
           end           
           
           %now we pair it with whichever max is closest to the min (which
           %happens to be whichever is smaller

           i_max = [];
           t_of_current_max = [];

           %cases: left smaller, right smaller, no left, no right, neither

           %neither
         
           if ~found_left_max & ~found_right_max
               break;
           end

           %no left or right smaller

           

           if ~found_left_max | right_max_value < left_max_value
               %pair min with right max
               i_max = right_max_extrema_index;
           end

           %no left or right smaller
           
           if ~found_right_max | left_max_value <= right_max_value
               %pair min with left max, 
               i_max = left_max_extrema_index;
           end

           %The second conditions in the two if statements above will only
           %trigger if we have found both a left and a right. Before, there
           %were some left_max_value and right_max_value's hanging around,
           %which caused the BOTH if statements to be triggered (aka
           %~left_max, but also left_max_value < right_max_value, so even
           %though there were no left max, the left_max_extrema_index of
           %the last thing got set, causing that max to be the max for
           %multiple processes. Interesting stuff!
           
           %pair em up!

           pair_num = pair_num + 1;
  
           %mark both as paired
           sorted_extrema(i_max, 2) = -1;
           sorted_extrema(i_min, 2) = -1;

           %get final values for processes array
           t_of_current_max = sorted_extrema(i_max, 1);

           val_of_current_max = time_series(t_of_current_max);
           val_of_current_min = time_series(t_of_current_min);
           
           
           wishywashy_processes(this_mouse, pair_num, 1, 1) = t_of_current_min;              
           wishywashy_processes(this_mouse, pair_num, 1, 2) = val_of_current_min;
           wishywashy_processes(this_mouse, pair_num, 2, 1) = t_of_current_max;
           wishywashy_processes(this_mouse, pair_num, 2, 2) = val_of_current_max;
                        
        end
    end      
end 


%extract data for 3D

wishywashy_coordinates3D = NaN(num_of_mice, 8);

for this_mouse = 1:num_of_mice
    all_min_t = wishywashy_processes(this_mouse, 1:max_number_of_pairs, 1, 1);
    all_max_t = wishywashy_processes(this_mouse, 1:max_number_of_pairs, 2, 1);
    all_min_val = wishywashy_processes(this_mouse, 1:max_number_of_pairs, 1, 2);
    all_max_val = wishywashy_processes(this_mouse, 1:max_number_of_pairs, 2, 2);
   
    smallest_min = min(all_min_val);
    largest_min = max(all_min_val);
    
    all_value_persistences = all_max_val - all_min_val;
    all_time_persistences = abs(all_max_t - all_min_t);
    clearance_value_persistences = NaN(max_number_of_pairs, 1);
    release_time_persistences = NaN(max_number_of_pairs, 1);
    clearance_time_persistences = NaN(max_number_of_pairs, 1);
    release_value_persistences = NaN(max_number_of_pairs, 1);

    num_of_clearances = 0;
    num_of_releases = 0;

    for i = 1:max_number_of_pairs

        if isnan(all_min_t(i)) || isnan(all_min_val(i))
            continue
        end
        t_min = all_min_t(i);
        t_max = all_max_t(i);
        val_min = all_min_val(i);
        val_max = all_max_val(i);
        time_persistence = abs(t_min - t_max);
        value_persistence = val_max - val_min;

        if t_min < t_max
            %the ith process is a release!
            num_of_releases = num_of_releases + 1;
            release_time_persistences(num_of_releases) = time_persistence;
            release_value_persistences(num_of_releases) = value_persistence;
        end

        if t_max < t_min
            num_of_clearances = num_of_clearances + 1;
            clearance_time_persistences(num_of_clearances) = time_persistence;
            clearance_value_persistences(num_of_clearances) = value_persistence;
        end
    end

    
    max_value_persistence = max(all_value_persistences);
    max_time_persistence = max(all_time_persistences);
    max_clearance_value_persistence = max(clearance_value_persistences);
    max_clearance_time_persistence = max(clearance_time_persistences);
    max_release_value_persistence = max(release_value_persistences);
    max_release_time_persistence = max(release_time_persistences);


    wishywashy_coordinates3D(this_mouse, 1) = smallest_min;
    wishywashy_coordinates3D(this_mouse, 2) = largest_min;
    wishywashy_coordinates3D(this_mouse, 3) = max_value_persistence;
    wishywashy_coordinates3D(this_mouse, 4) = max_clearance_value_persistence;
    wishywashy_coordinates3D(this_mouse, 5) = max_release_value_persistence;
    wishywashy_coordinates3D(this_mouse, 6) = max_time_persistence;   
    wishywashy_coordinates3D(this_mouse, 7) = max_clearance_time_persistence;
    wishywashy_coordinates3D(this_mouse, 8) = max_release_time_persistence;
 



end


save wishywashy_processes.mat wishywashy_processes wishywashy_coordinates3D


function[is_min] = check_is_min(t, array)
    [last_index, ~] = size(array);
    %make sure this isn't an endpoint, if not, check if its a min
    if t ~= 1 && t ~= last_index
        is_min = array(t) < array(t + 1) && array(t) < array(t - 1);
    else 
        is_min = false;
    end
end

function[is_max] = check_is_max(t, array)
    [last_index, ~] = size(array);
    %make sure this isn't an endpoint, if not, check if its a max
    if t ~= 1 && t ~= last_index
        is_max = array(t) > array(t + 1) && array(t) > array(t - 1);
    else 
        is_max = false;
    end
end
      



