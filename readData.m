function file_data = readData(file, features, test)

if features == 2
    fid = fopen(file);
    tline = fgetl(fid);
    i = 1;
    while ischar(tline)
        c = strsplit(tline, ',');
        file_data{i, 1} = c{1};
        vec = zeros(1, 557);
        for j = 2:length(c)
            vec(j-1) = str2double(c{j});
        end
        file_data{i,2} = vec;
        tline = fgetl(fid);
        i = i + 1;
    end
elseif features == 1
    fid = fopen(file);
    tline = fgetl(fid);
    i = 1;
    while ischar(tline)
        c = strsplit(tline, ',');
        if test
            file_data{i, 1} = strcat(c{1}, c{2}, '.jpg');
            vec = zeros(1, 557);
            for j = 3:length(c)
                file_data{i,j-1} = str2double(c{j});
            end
        else
            file_data{i, 1} = strcat(c{1}, '.jpg');
            vec = zeros(1, 557);
            for j = 2:length(c)
                file_data{i,j} = str2double(c{j});
            end
        end
        tline = fgetl(fid);
        i = i + 1;
    end
elseif features == 0
    fid = fopen(file);
    tline = fgetl(fid);
    i = 1;
    while ischar(tline)
        file_data{i, 1} = tline;
        tline = fgetl(fid);
        i = i + 1;
    end
else
    fid = fopen(file);
    tline = fgetl(fid);
    i = 1;
    while ischar(tline)
        file_data{i} = tline;
        tline = fgetl(fid);
        i = i + 1;
    end
    file_data = file_data';
end
end