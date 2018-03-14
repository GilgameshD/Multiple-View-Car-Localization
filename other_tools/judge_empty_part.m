function result = judge_empty_part(part_name)

    if isempty(part_name) == 1
        result = [-1, -1];
    else
        result = part_name;
    end
end