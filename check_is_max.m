function[is_max] = check_is_max(t, array)
    [last_index, ~] = size(array);
    %make sure this isn't an endpoint, if not, check if its a max
    if t ~= 1 && t ~= last_index
        is_max = array(t) > array(t + 1) && array(t) > array(t - 1);
    else 
        is_max = false;
    end
end

% function[is_max] = check_is_max(t, array)
%     [last_index, ~] = size(array);
%     %we want to include right EP as a max, but not left EP
%     if t == last_index
%         is_max = array(t) > array(t - 1);
%     elseif t == 1 
%         is_max = false;
%     else
%         is_max = array(t) > array(t + 1) && array(t) > array(t - 1);
%     end
% end
% 