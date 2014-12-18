function [histogram, bins] = getLabHist(img, num_bins)

colorTransform = makecform('srgb2lab');
lab = applycform(img, colorTransform);

histogram = zeros(num_bins, 1);
for i = 1:3
    [count, bins] = imhist(lab(:,:,i), num_bins);
    histogram = histogram + count;
end

histogram = histogram / sum(histogram);