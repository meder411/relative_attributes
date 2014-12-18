function gist = getGist (filenames, image_dir, img_size)
% Code taken and adapted from http://people.csail.mit.edu/torralba/code/spatialenvelope/
    
    Nimages = length(filenames);
    
    % GIST Parameters:
    clear param
    param.imageSize = img_size; % set a normalized image size
    param.orientationsPerScale = [8 8 8 8]; % number of orientations per scale (from HF to LF)
    param.numberBlocks = 4;
    param.fc_prefilt = 4;

    % Pre-allocate gist:
    Nfeatures = sum(param.orientationsPerScale)*param.numberBlocks^2;
    gist = zeros([Nimages Nfeatures]); 

    % Load first image and compute gist:
    img = imread(strcat(image_dir, '\', filenames{1}));
    [gist(1, :), param] = LMgist(img, '', param); % first call
    % Loop:
    for i = 2:Nimages
       img = imread(strcat(image_dir, '\', filenames{i}));
       gist(i, :) = LMgist(img, '', param); % the next calls will be faster
    end

end