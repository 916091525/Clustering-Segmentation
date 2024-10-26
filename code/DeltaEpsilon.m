function [delta,epsilon] = DeltaEpsilon(X,idx)
%X = normalize(X,'range');
idx_unique = unique(idx);
k = length( idx_unique );
epsilon = 0;
delta = 2^30;
for i = 1:k
    p = find(idx == idx_unique(i));
    Ci = X(p,:);
    C{i} = Ci;
    d = pdist(Ci);
    W = squareform(d);
    G = graph(W);
    T = minspantree(G);
    Weight = T.Edges.Weight;
    maxW = max(Weight);
    if maxW > epsilon
       epsilon = maxW;
    end
end
for i = 1:k-1
    for j = i+1:k
        dmin = dmincluster(C{i},C{j});
        if dmin < delta
           delta = dmin;
        end
    end
end
end