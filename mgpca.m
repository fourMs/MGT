function [out,p] = mgpca(x,ind)
%[out,p] = mgpca(x,ind)
% mgpca computes the pca on x and project x onto pc
% syntax:[out,p] = mgpca(x,ind)

% input:
% x:input features
% ind:selection components

% output:
% out: projected features
% p.r :eigenvalue
% p.v :eigenvector
% p.ratio :ratios of eigenvalues

n = size(x,2);
mx = mean(x,1);
x = x - repmat(mx,size(x,1),1);
co = x'*x;
[v,d] = eig(co);
r = diag(d);
[r,id] = sort(-r);
r = -r;
v = v(:,id);
proj = v'*x';
s = sum(r(:));
ratio = r/s;

if nargin<2
    cl = cumsum(ratio);
    index = min(find(cl>0.9));
    ind = 1:index;
    out = proj(:,ind);
else
    out = proj(:,ind);
end
p.r = r;
p.v = v;
p.ratio = ratio;
    
