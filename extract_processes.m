function[artificial_processes] = extract_processes(all_ts, persistence_threshold_percent, spike_comparison_percent, comparison_method, max_number_of_pairs)

    [num_of_readings, num_of_mice] = size(all_ts);

    artificial_processes = NaN(num_of_mice, max_number_of_pairs, 2, 2);
    %mouse num, pair num, birth/death, time/value
    
    %grab the j-th mouse
    for this_mouse = 1:num_of_mice
        time_series = all_ts(:,this_mouse);
        max_value = max(time_series);
        min_value = min(time_series);
        persistence_threshold = (max_value - min_value) * persistence_threshold_percent;
        % iterate through the sorted_times to build extrema_times array of
        % maxes and mins (automatically sorted by time)
        extrema_times = NaN(max_number_of_pairs * 2, 1);
        num_of_extrema = 0;
        for t = 1:num_of_readings
            if isnan(time_series(t))
                break
            end
            if check_is_min(t, time_series) || check_is_max(t, time_series)
               num_of_extrema = num_of_extrema + 1;
               extrema_times(num_of_extrema) = t;
            end
        end

        %Start the first process at the beginning. This will either just be
        % the left endpoint or the first "true" extrema, depending on if we 
        % decide to include endpoints. 

        birth_extrema_index = 1;
        current_pair_num = 1;

        while(birth_extrema_index < num_of_extrema)
            %Each iteration of this while loop will build a process and add
            %it to "processes" until we run out of extrema.
            birth_extrema_time = extrema_times(birth_extrema_index);
            birth_extrema_value = time_series(birth_extrema_time);
            birth_extrema_is_min = check_is_min(birth_extrema_time, time_series);

            for candidate_extrema_index = (birth_extrema_index + 1):num_of_extrema
                candidate_extrema_time = extrema_times(candidate_extrema_index);
                candidate_extrema_value = time_series(candidate_extrema_time);
                candidate_extrema_is_min = check_is_min(candidate_extrema_time, time_series);
                
                %if this is the last extrema, we just end the process.
                if candidate_extrema_index ~= num_of_extrema
                    
                    %if its the second to last extrema, we can't do the next_like scomparison
                    if candidate_extrema_index == num_of_extrema - 1
                        next_like_extrema_value = -1;                         
                    else
                        next_like_extrema_value = time_series(extrema_times(candidate_extrema_index + 2)); 
                    end


                    next_extrema_value = time_series(extrema_times(candidate_extrema_index + 1));                               
                    spike_size = abs(candidate_extrema_value - next_extrema_value);
                    comparison_process_size = [];
                    %this is the controversial bit:
                    switch comparison_method
                        case 'A'
                            %if there a A type comparison isn't possible,
                            %use B type
                            if current_pair_num < 2
                                comparison_process_size = ...
                                    abs(birth_extrema_value - candidate_extrema_value);
                            else
                                last_process_birth_value = ...
                                    artificial_processes(this_mouse, current_pair_num - 1, 1, 2);
                                comparison_process_size = ...
                                    abs(birth_extrema_value - last_process_birth_value);
                            end                        
                        case 'B'
                            comparison_process_size = ...
                                abs(birth_extrema_value - candidate_extrema_value);
                    end
    
    
    
    
                    %Iterate through the extrema after our birth until we find 
                    %a death extrema that passes all our checks
                   
    
                    %Check 1: 
                    %if our birth is a min/max, we only consider maxes/mins to close the process
    
                    if birth_extrema_is_min == candidate_extrema_is_min
                        continue
                    end
                    
                    %Check 2: 
                    %We don't want the process to be too small
    
                    if abs(candidate_extrema_value - birth_extrema_value) < persistence_threshold
                        continue
                    end
    
                    %Check 3: 
                    %We now distinguish between clearances and releases.
                    %There are two parts to these checks. 
                    %The candidate must fail both to fail.
    
                    %CLEARANCE - the candidate is a min, so the birth is a max
                    if (candidate_extrema_is_min)
                        % Part One:
                        % If the min after the candidate min is even lower than 
                        % the candidate min, than our clearance process is probably 
                        % not complete, so we should probably move on.
                        
                        %note that if there is no next like extrema, then we want
                        %this candidate iff there's a signicant spike.

                        if (next_like_extrema_value == -1) || (candidate_extrema_value > next_like_extrema_value)
                            
                            % Part two: 
                            % However, we shouldn't be too hasty; it's
                            % possible that in between this candidate min and 
                            % the next min, there is a large spike. If so, we 
                            % need to end this process now, so we can count the 
                            % next spike as its own process.
                            if spike_size < spike_comparison_percent * comparison_process_size
                                %Then the next spike is not a significant release.
                                continue
                            end
                        end
                    
                    %RELEASE - the candidate is a max, so the birth is a min
                    else
                        % Part One:
                        % If the max after the candidate max is even higher than 
                        % the candidate max, than our clearance process is probably 
                        % not complete, so we should probably move on.

                        %note that if there is no next like extrema, then we want
                        %this candidate iff there's a signicant spike.
                        if (next_like_extrema_value == -1) || (candidate_extrema_value < next_like_extrema_value)
                            % Part two: 
                            % However, we shouldn't be too hasty; it's
                            % possible that in between this candidate max and 
                            % the next max, there is a large (downward) spike. If so, we 
                            % need to end this process now, so we can count the 
                            % next spike as its own process.
                            
                            if spike_size < spike_comparison_percent * comparison_process_size
                                %then the (downward) spike is not a significant clearance
                                continue
                            end
                        end
                    end
                end
                

                %If our candidate passes all of the checks, we end our
                %process here and add it to the books:

                death_extrema_time = candidate_extrema_time;
                death_extrema_value = candidate_extrema_value;
                death_extrema_index = candidate_extrema_index;
                artificial_processes(this_mouse, current_pair_num, 1, 1) = birth_extrema_time;              
                artificial_processes(this_mouse, current_pair_num, 1, 2) = birth_extrema_value;
                artificial_processes(this_mouse, current_pair_num, 2, 1) = death_extrema_time;
                artificial_processes(this_mouse, current_pair_num, 2, 2) = death_extrema_value;



                %Now our death index becomes the birth index of the next process:
		        birth_extrema_index = death_extrema_index;
                current_pair_num = current_pair_num + 1;
                %break out of the for loop
                break
            end
            %start over again for the next process!
        end
    end
    return
end