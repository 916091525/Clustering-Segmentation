function [I] = InterIndex(X,ind,method)
%   k = length( unique(ind) );
%   meancluster = [];
%   for i = 1:k
%       p = find( ind == i );
%       meancluster(i,:) = mean(X(p,:));
%   end
  if strcmp(method,'DB') == 1
     k = length( unique(ind) );
     meancluster = [];
     for i = 1:k
         p = find( ind == i );
         if length(p) > 1
            meancluster(i,:) = mean(X(p,:));
         else
            meancluster(i,:) = X(p,:);
         end
     end
     DB = 0;
     avg = avgcluster(X,ind);
     avg = avg(:)';
     dmean = squareform(pdist(meancluster));
     for i = 1:k
         avgi = avg + avg(i);
         dmeani = dmean(i,:);
         avgi(i) = [];
         dmeani(i) = [];
         DB = DB + max(avgi./dmeani);
     end
     I = DB/k;
  end
  if strcmp(method,'Dunn') == 1
     k = length( unique(ind) );
     maxdiam = 0;
     dmin = 2^20;
     for i = 1:k
         p = find(ind == i);
         Ci = X(p,:);
         C{i} = Ci;
         diam = max(pdist(Ci));
         %diam = diam(1);
         if diam > maxdiam
            maxdiam = diam;
         end
     end
     for i = 1:k-1
         for j = i+1:k
             dminij = dmincluster(C{i},C{j});
             if dminij < dmin
                dmin = dminij;
             end
         end
     end
     I = dmin/maxdiam;
  end
  if strcmp(method,'Sil') == 1
     s = silhouette(X,ind);
     I = mean(s);
  end
  if strcmp(method,'XB') == 1
     S = 0;
     k = length( unique(ind) );
     N = length(ind);
     meancluster = [];
     for i = 1:k
         p = find( ind == i );
         Ci = X(p,:);
         lp = length(p);
         if length(p) > 1
            meancluster(i,:) = mean(Ci);
         else
            meancluster(i,:) = X(p,:);
         end
         MeanC = repmat(meancluster(i,:),lp,1);
         S = S + norm(Ci - MeanC,'fro')^2;
     end
     mindmu = min( pdist(meancluster) );
     mindmu = mindmu^2;
     I = S/(N*mindmu);
  end
end