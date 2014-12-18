num_train = 21;
num_people = length(people);
train = cell(num_people*num_train, 13);
test = reconciled(2:end,:);
k = 1;
idx = [];
for i = 1:num_people
    name = people{i};
    for j = 1:70
        if j <= num_train
            train_idx = (i - 1) * num_train + j;
            train(train_idx, :) = test((i - 1) * 70 + j, :);
            idx = [idx, (i - 1) * 70 + j];
        end
    end
end
test(idx,:) = []; % remove training data
    