function reconciled = reconcileAttributes(attributes, mapping)
    j = 1;
    i = 1;
    reconciled = cell(length(mapping), 13);
    prev_name = '';
    num = -1;
    while i < length(mapping)
        if ~(strcmp(mapping{i, 1}, attributes{j, 1}) && strcmp(mapping{i, 2}, attributes{j, 2}) )
            j = j + 1;
        else
            if ~strcmp(mapping{i,1}, prev_name)
                num = 0;
            else
                num = num + 1;
            end
            reconciled(i, :) = attributes(j, :);
            reconciled{i, 2} = num;
            
            prev_name = mapping{i,1};
            i = i + 1;
            j = i;
        end
    end
end