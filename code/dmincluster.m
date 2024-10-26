function [dmin,x1,x2] = dmincluster(X1,X2)
dmatrix = pdist2(X1,X2);
[p(:,1),p(:,2)] = find( dmatrix == min(dmatrix,[],'all') );
idx1 = p(1,1);
idx2 = p(1,2);
x1 = X1(idx1,:);
x2 = X2(idx2,:);
dmin = norm(x1-x2);
end