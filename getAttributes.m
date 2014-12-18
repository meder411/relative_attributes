function attributes = getAttributes(filepath, people, quantity, select_attributes)

fid = fopen(filepath);
tline = fgetl(fid);
people = sort(people);
num_read = 0;
idxPerson = 1;
prev_was_poi = false;
prev_name = '';
attributes = cell(length(people) * quantity, sum(select_attributes));
lines_read = 1;
i = 1;
while ischar(tline) && idxPerson <= length(people)
    c = strsplit(tline, '\t');
    if (length(c) > 2) % not the first 2 lines
        att = c(select_attributes)
        name = att{1};
        if ~strcmp(name, prev_name)
           num_read = 0;
           if prev_was_poi
              idxPerson = idxPerson + 1;
           end
        end
        if strcmp(name, people{idxPerson})
            num_read = num_read + 1;
            attributes(i, :) = att;
            prev_was_poi = true;
            i = i + 1;
        else
            prev_was_poi = false;
        end
        prev_name = name;
    end
    if num_read == quantity
        idxPerson = idxPerson + 1;
        num_read = 0;
    end
    tline = fgetl(fid);
    lines_read = lines_read + 1;
end
fclose(fid);