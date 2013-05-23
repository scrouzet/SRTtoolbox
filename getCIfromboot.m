function [ci] = getCIfromboot(X,alpha)
% typically used after a bootstrap to get the CI (Confidence Intervals)

% set the limit depending on the size of the original matrix
limits = round(sort([ alpha*length(X) (1-alpha)*length(X) ]));

% order the vector
X = sort(X);

% get the CI
ci = [X(limits(1)) X(limits(2))];