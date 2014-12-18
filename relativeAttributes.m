clear
close all
clc
%% Load data files
% Load feature data
features_test = readData('data/features_test.dat',2,0);
features_train = readData('data/features_train.dat',2,0);
attributes_train = readData('data/attributes_train.dat',1,0);
attributes_test = readData('data/attributes_test.dat',1,1);

% Format feature data
attributes_train = cell2mat(attributes_train(:,2:12));
attributes_test = cell2mat(attributes_test(:,2:12));
features_test = cell2mat(features_test(:,2));
features_train = cell2mat(features_train(:,2));

% Load ground truth
gt_attributes_ranking = dlmread('data/ranking.dat');
gt_binary_assign_train = 2 * dlmread('data/binary_assign_train.dat') - 1;
gt_binary_assign_test = 2 * dlmread('data/binary_assign_test.dat') - 1;

% Load index keys
train_key = readData('data/train_file_key.dat', 0,0);
test_key = readData('data/test_file_key.dat', 0,0);
attributes_key = readData('data/attributes_key.dat', -1,0);
people_key= readData('data/people_key.dat', -1,0);

%% Train binary linear SVM
scores = zeros(392, 11);
compactSVM = zeros(1, 11);
label = zeros(392, 11);

for i = 1:11
    svm = fitcsvm(features_train, gt_binary_assign_train(:,i));
    compactSVM = compact(svm);
    [label(:,i), score] = predict(compactSVM, features_test);
    scores(:,i) = score(:,1); % negative scores --> greater nominal value means less expressive of this attribute (i.e. negative values ranked above positive)
end

% Reshape SVM scores into values matrix
values = reshape(scores, [392, 1, 11]);
values = repmat(values, 1, 100, 1);


%% Train Rank SVM
% Calculate sparse pairs matrices
pairs_train = zeros(28*21, 168, 11);
for zz = 1:11
    samples = 1:21:168;
    aa = 1;
    for bb = 1:21
        for cc = 1:length(samples)
            for dd = cc + 1 : length(samples);
                lbl = 2 * (attributes_train(samples(cc),zz) > attributes_train(samples(dd),zz)) - 1;
                pairs_train(aa, samples(cc), zz) = lbl;
                pairs_train(aa, samples(dd), zz) = -lbl;
                aa = aa + 1;
            end
        end
        samples = samples + 1;
    end
end

% Calculate ranking function
C = 1e-2 * ones(588,1);
w_rank = zeros(557, 11);
ranking_func = zeros(392, 11);
for yy = 1:11
    w_rank(:,yy) = ranksvm(features_train, pairs_train(:,:,yy), C);
    ranking_func(:,yy)  = (w_rank(:,yy)' * features_test')';
end

% Reshape ranking function
ranking_func = reshape(ranking_func, [392, 1, 11]);
ranking_func = repmat(ranking_func, 1, 100, 1);


%% Initialize comparison measures

% PubFig attributes
test_atts = attributes_test;
test_atts = reshape(test_atts, [392, 1, 11]);
test_atts = repmat(test_atts, 1, 100, 1);

% % Human ranked attributes
% gt_human = gt_attributes_ranking';
% gt_human = reshape(gt_human, [8, 1, 11]);
% gt_human = repmat(gt_human, 1, 100, 1);

% Empirically ranked attributes
bin_atts = zeros(8, 100, 11);
gt_atts = zeros(8, 100, 11);
ranked_vals = zeros(8, 100, 11);


%% Pick 100 random sets of images for comparison
img_idx = zeros(8, 100);
for j = 1:8
    img_idx(j, :) = (j - 1) * 49 + ceil(rand(100,1) * 49);
end

% Pull values from matrices for samples
for a = 1:11
    tmp = values(:,:,a);
    bin_atts(:, :, a) = tmp(img_idx);
    tmp = test_atts(:,:,a);
    gt_atts(:, :, a) = tmp(img_idx);
    tmp = ranking_func(:,:,a);
    ranked_vals(:, :, a) = tmp(img_idx);
end


%% Arrange the labels according to SVM scores

bin_SVM_ranking = zeros(size(bin_atts));
rank_SVM_ranking = zeros(size(ranked_vals));
gt_ranking = zeros(size(gt_atts));
for b = 1:11
    for c = 1:100
        [~, order] = sort(bin_atts(:, c, b), 'descend');
        bin_SVM_ranking(:, c, b) = order;
        [~, order] = sort(ranked_vals(:, c, b), 'ascend');
        rank_SVM_ranking(:, c, b) = order;
        [~, order] = sort(gt_atts(:, c, b), 'ascend');
        gt_ranking(:, c, b) = order;
    end
end

% Finds the indices containing the given values
% Each index refers to the rank, each value refers to a person
idx_bin_SVM = zeros(8, 100, 11);
idx_rank_SVM = zeros(8, 100, 11);
idx_gt_human = zeros(8, 100, 11);
idx_gt_atts = zeros(8, 100, 11);
for x = 1:8
    for z = 1:11
        for y = 1:100
%             idx_gt_human(x, y, z) = find(gt_human(:,y,z) == x);
            idx_gt_atts(x, y, z) = find(gt_ranking(:,y,z) == x);
            idx_bin_SVM(x, y, z) = find(bin_SVM_ranking(:,y,z) == x);
            idx_rank_SVM(x, y, z) = find(rank_SVM_ranking(:,y,z) == x);
        end
    end
end

%% Calculate accuracies
% Compare relationship of every pair of values between SVM classified scores and ground truth
% correct: idx_gt(i,:,:) > idx_gt(j,:,:) == idx_SVM(i,:,:) > idx_SVM(j,:,:)

% num_bin_correct_h = 0;
num_bin_correct_a = 0;
num_rank_correct = 0;
num_comp = 0;
for m = 1:8
    for n = m+1:8
%         corr_h = (idx_gt_human(m,:,:) > idx_gt_human(n,:,:)) == (idx_bin_SVM(m,:,:) > idx_bin_SVM(n,:,:));
        corr_bin = (idx_gt_atts(m,:,:) > idx_gt_atts(n,:,:)) == (idx_bin_SVM(m,:,:) > idx_bin_SVM(n,:,:));
        corr_rank = (idx_gt_atts(m,:,:) > idx_gt_atts(n,:,:)) == (idx_rank_SVM(m,:,:) > idx_rank_SVM(n,:,:));
        num_bin_correct_a = num_bin_correct_a + sum(sum(corr_bin));
        num_rank_correct = num_rank_correct + sum(sum(corr_rank));
%         num_bin_correct_h = num_bin_correct_h + sum(sum(corr_h));
        num_comp = num_comp + numel(corr_bin);
    end
end
% human_gt_accuracy = num_bin_correct_h / num_comp
bin_SVM_accuracy = num_bin_correct_a / num_comp
rank_SVM_accuracy = num_rank_correct / num_comp

