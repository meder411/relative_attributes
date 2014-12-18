function [filenames, features] = extractFeatures(image_dir, num_bins)
    dirInfo = dir(image_dir);
    isDir = [dirInfo.isdir];
    filenames = {dirInfo(~isDir).name};

    gist = getGist(filenames, image_dir, [128, 128]);

    histograms = zeros(length(filenames), num_bins);
    for i = 1 : length(filenames)
        img = imread(strcat(image_dir, '\', filenames{i}));
        [histograms(i, :), ~] = getLabHist(img, num_bins); 
    end

    features = [gist, histograms];
end