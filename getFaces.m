function mapping = getFaces (filepath, savepath, people, quantity)
% Downloads and saves images from the PubFig Dataset from:
% "Attribute and Simile Classifiers for Face Verification,"
% Neeraj Kumar, Alexander C. Berg, Peter N. Belhumeur, and Shree K. Nayar,
% International Conference on Computer Vision (ICCV), 2009.
%
% REQUIRED INPUTS
% filepath = path to text file containing image info
% savepath = folder into which you want to save the images
% OPTIONAL INPUTS
% people = cell array containing names of celebrities whose images you want to capture
% quantity = number of images to save per celebrity
% (NOTE: if links are dead and, it is possible that quantity > number of images available

% filepath = 'dev_urls.txt'
% people = {'Alex Rodriguez', 'Clive Owen', 'Hugh Laurie', 'Jared Leto', 'Miley Cyrus', 'Scarlett Johansson', 'Viggo Mortensen', 'Zac Efron'}
fid = fopen(filepath);
tline = fgetl(fid);
people = sort(people);
% num_err = 0;
num_read = 0;
idxPerson = 1;
prev_was_poi = false;
prev_name = '';
i = 1;
while ischar(tline) && idxPerson <= length(people)
    c = strsplit(tline, '\t');
    if (length(c) > 1) % not the first line
        name = c{1};
        if ~strcmp(name, prev_name)
           num_read = 0;
           if prev_was_poi
              idxPerson = idxPerson + 1
           end
        end
        url = c{3};
        if strcmp(name, people{idxPerson})
            savename = strcat(name, num2str(num_read), '.jpg');
            outputpath = strcat(savepath,'\',savename);
            [~, status] = urlwrite(url, outputpath, 'Timeout', 5);
            prev_was_poi = true;
            if status == 1
                try
                    rect = str2num(c{4});
                    img = imread(outputpath);
                    I = imcrop(img, [rect(1), rect(2), rect(3)-rect(1)+1, rect(4)-rect(2)+1]);
                    imwrite(I, outputpath);
                    mapping(i, :) = {people{idxPerson}, c{2}};
                    i = i + 1;
                    num_read = num_read + 1;
                    disp('Image read successfully');
                catch
                    delete(outputpath);
                    disp('Problem reading file');
                end
            else
                disp('Failed to read image from link');
            end
        else
            prev_was_poi = false;
        end
        prev_name = name;
    end
    if num_read == quantity
        idxPerson = idxPerson + 1
        num_read = 0;
    end
    tline = fgetl(fid);
end
num_read
fclose(fid);