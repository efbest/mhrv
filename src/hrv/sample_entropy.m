function sampen = sample_entropy(sig, m, r)
%SAMPLE_ENTROPY Calculate sample entropy (SampEn) of a signal.
%   Sample entropy is a measure of the irregularity of a signal.
%
%   See:
%   Richman, J. S., & Moorman, J. R. (2000).
%   Physiological time-series analysis using approximate entropy and sample entropy.
%   American Journal of Physiology. Heart and Circulatory Physiology, 278(6), H2039?H2049.

% Initialize template-match counters. A is the number of template matches
% of length m+1, and B is the number of template matches of length m.
A = 0; B = 0;

% Create a matrix containing all templates (windows) of length m+1 (with m
% samples overlap) that exist in the signal. Each column is a window.
templates_mat = buffer(sig, m+1, m, 'nodelay');
num_templates = size(templates_mat, 2);

% Loop over all templates, calcualting the Chebyshev distance between the
% current template and all the following templates.
for win_idx = 1:num_templates    
    % Extract the current template and all the templates following it
    curr_template = templates_mat(:,win_idx);
    next_templates_mat = templates_mat(:,(win_idx+1):end);
    
    % Calculate absolute difference vectors between the current template and the
    % each of the next templates.
    diff_mat = abs( bsxfun(@minus, curr_template, next_templates_mat) );
    
    % Calculate Chebyshev distance: This is the max component of the absolute
    % difference vector. Well calculate two distances: dist_A is the max
    % difference component (Chebyshev distance) using all m+1 components,
    % and dist_B is the Chebyshev distance using only the first m components.  
    dist_B = max(diff_mat(1:end-1,:));
    dist_A = max(dist_B, diff_mat(end,:));
    
    % A template match is a case where the Chebyshev distance between the
    % current template and one of the next templates is less than r. Count
    % the number of matches of length m+1 and of length m we have, and
    % increment the appropriate counters.
    A = A + sum(dist_A < r);
    B = B + sum(dist_B < r);
end

% Calculate the sample entropy value based on the number of template matches.
sampen = -log(A / B);

end
