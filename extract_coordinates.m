function [coordinates] = extract_coordinates(artificial_processes, max_number_of_pairs, all_ts, average_threshold_percent)


[~, num_of_mice] = size(all_ts);

coordinates = NaN(num_of_mice, 31);

for this_mouse = 1:num_of_mice
    all_birth_t = artificial_processes(this_mouse, 1:max_number_of_pairs, 1, 1);
    all_death_t = artificial_processes(this_mouse, 1:max_number_of_pairs, 2, 1);
    all_birth_val = artificial_processes(this_mouse, 1:max_number_of_pairs, 1, 2);
    all_death_val = artificial_processes(this_mouse, 1:max_number_of_pairs, 2, 2);

    all_VP = abs(all_death_val - all_birth_val);
    all_TP = abs(all_death_t - all_birth_t);

    all_CVP = NaN(max_number_of_pairs, 1);
    all_CTP = NaN(max_number_of_pairs, 1);
    all_RVP = NaN(max_number_of_pairs, 1);
    all_RTP = NaN(max_number_of_pairs, 1);

    all_S = NaN(max_number_of_pairs, 1);
    all_CS = NaN(max_number_of_pairs, 1);
    all_RS = NaN(max_number_of_pairs, 1);
    all_S_signed = NaN(max_number_of_pairs, 1);
    
    num_of_clearances = 0;
    num_of_releases = 0;

    for i = 1:max_number_of_pairs

        if isnan(all_birth_t(i)) || isnan(all_birth_val(i))
            continue
        end

        t_birth = all_birth_t(i);
        t_death = all_death_t(i);
        val_birth = all_birth_val(i);
        val_death = all_death_val(i);
        time_persistence = abs(t_birth - t_death);
        value_persistence = abs(val_death - val_birth);
        slope = value_persistence / time_persistence;
        all_S(i) = slope;

        signed_val_persistence = (val_death - val_birth);
        all_S_signed(i) = signed_val_persistence / time_persistence;

        if val_birth < val_death
            %the ith process is a release!
            num_of_releases = num_of_releases + 1;
            all_RTP(num_of_releases) = time_persistence;
            all_RVP(num_of_releases) = value_persistence;
            all_RS(num_of_releases) = slope;
        end

        if val_death < val_birth
            %the ith process is a clearance!
            num_of_clearances = num_of_clearances + 1;
            all_CTP(num_of_clearances) = time_persistence;
            all_CVP(num_of_clearances) = value_persistence;
            all_CS(num_of_clearances) = slope;
        end
    end
    
    smallest_min = min(all_birth_val);
    largest_max = max(all_birth_val);

    max_VP = max(all_VP);
    max_CVP = max(all_CVP);
    max_RVP = max(all_RVP);
    max_TP = max(all_TP);
    max_CTP = max(all_CTP);
    max_RTP = max(all_RTP);
    max_S = max(all_S);
    max_CS = max(all_CS);
    max_RS = max(all_RS);
    min_S = min(all_S);
    min_CS = min(all_CS);
    min_RS = min(all_RS);


    val_range = largest_max - smallest_min;

    sig_thresh = average_threshold_percent * val_range;

    sig_VP = all_VP(all_VP > sig_thresh);
    sig_CVP = all_CVP(all_CVP > sig_thresh);
    sig_RVP = all_RVP(all_RVP > sig_thresh);

    avg_VP = mean(sig_VP, "omitnan");
    avg_CVP = mean(sig_CVP, "omitnan");
    avg_RVP = mean(sig_RVP, "omitnan");
    avg_TP = mean(all_TP, "omitnan");
    avg_CTP = mean(all_CTP, "omitnan");
    avg_RTP = mean(all_RTP, "omitnan");
    avg_S = mean(all_S, "omitnan");
    avg_CS = mean(all_CS, "omitnan");
    avg_RS = mean(all_RS, "omitnan");
    avg_S_signed = mean(all_S_signed, "omitnan");

    var_S = var(all_S, "omitnan");
    var_CS = var(all_CS, "omitnan");
    var_RS = var(all_RS, "omitnan");

    avg_CVP_to_avg_RVP_distance = abs(avg_CVP - avg_RVP);
    max_CVP_to_max_RVP_distance = abs(max_CVP - max_RVP);
    avg_CTP_to_avg_RTP_distance = abs(avg_CTP - avg_RTP);
    max_CTP_to_max_RTP_distance = abs(max_CTP - max_RTP);
    avg_CS_to_avg_RS_distance = abs(avg_CS - avg_RS);
    max_CS_to_max_RS_Distance = abs(max_CS - max_RS);

    x_to_60_slopes = readmatrix("x_to_60_slopes.xlsx");
    v = x_to_60_slopes(1:30, this_mouse);
    avg_x_to_60_slope = mean(v);
    abs_avg_x_to_60_slope = abs(avg_x_to_60_slope);

    coordinates(this_mouse, 1) = smallest_min;
    coordinates(this_mouse, 2) = largest_max;
    coordinates(this_mouse, 3) = max_VP;
    coordinates(this_mouse, 4) = max_CVP;
    coordinates(this_mouse, 5) = max_RVP;
    coordinates(this_mouse, 6) = max_TP;   
    coordinates(this_mouse, 7) = max_CTP;
    coordinates(this_mouse, 8) = max_RTP;
    coordinates(this_mouse, 9) = avg_VP;
    coordinates(this_mouse, 10) = avg_CVP;
    coordinates(this_mouse, 11) = avg_RVP;
    coordinates(this_mouse, 12) = avg_TP;
    coordinates(this_mouse, 13) = avg_CTP;
    coordinates(this_mouse, 14) = avg_RTP;
    coordinates(this_mouse, 15) = avg_CVP_to_avg_RVP_distance;
    coordinates(this_mouse, 16) = max_CVP_to_max_RVP_distance;
    coordinates(this_mouse, 17) = avg_CTP_to_avg_RTP_distance;
    coordinates(this_mouse, 18) = max_CTP_to_max_RTP_distance;
    coordinates(this_mouse, 19) = max_S;
    coordinates(this_mouse, 20) = max_CS;
    coordinates(this_mouse, 21) = max_RS;
    coordinates(this_mouse, 22) = avg_S;
    coordinates(this_mouse, 23) = avg_CS;
    coordinates(this_mouse, 24) = avg_RS;
    coordinates(this_mouse, 25) = avg_CS_to_avg_RS_distance;
    coordinates(this_mouse, 26) = max_CS_to_max_RS_Distance;
    coordinates(this_mouse, 27) = var_S;
    coordinates(this_mouse, 28) = var_CS;
    coordinates(this_mouse, 29) = var_RS;
    coordinates(this_mouse, 30) = min_S;
    coordinates(this_mouse, 31) = min_CS;
    coordinates(this_mouse, 32) = min_RS;
    coordinates(this_mouse, 33) = avg_x_to_60_slope;
    coordinates(this_mouse, 34) = abs_avg_x_to_60_slope;
    coordinates(this_mouse, 35) = avg_S_signed;
    

end
end
