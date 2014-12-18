function [comparison, ranks] = rankNewImage(image_dir, w_rm, ranked_vals)
    [~, features] = extractFeatures(image_dir, 45);
    ranks = (w_rm'*features')';
%     avg_celeb_scores = mean(ranked_vals,2);
    avg_celeb_scores = ranked_vals(:,1, :);
    
    comparison = zeros(8, 11);
    for i = 1:8
       comparison(i,:) = 2*(ranks > avg_celeb_scores(i,:)) - 1; 
    end
end