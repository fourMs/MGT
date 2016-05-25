function sim = mgsimilarity(x,distance)
% function sim = mgsimilarity(x,distance)
% syntax:sim = mgsimilarity(x,distance)

% input:
% x:a vector or a matrix
% distance: method,default,using
% euclidean,options:'squaredeucliean','seuclidean','cityblock','minkowski','chebychev','mahalanobis'
% 'cosine','correlation','spearman','hamming','jaccard'

% output:
% a similiarity matrix

if nargin == 1
    distance = 'euclidean';
end
sim = squareform(pdist(x,distance));