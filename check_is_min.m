function[is_min] = check_is_min(t, array)
    [last_index, ~] = size(array);
    %make sure this isn't an endpoint, if not, check if its a min
    if t ~= 1 && t ~= last_index
        is_min = array(t) < array(t + 1) && array(t) < array(t - 1);
    else 
        is_min = false;
    end
end

% function[is_min] = check_is_min(t, array)
%     [last_index, ~] = size(array);
%     %we want to include right EP as a min, but not left EP
%     if t == last_index
%         is_min = array(t) < array(t - 1);
%     elseif t == 1 
%         is_min = false;
%     else
%         is_min = array(t) < array(t + 1) && array(t) < array(t - 1);
%     end
% end
% 
