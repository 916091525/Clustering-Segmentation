function [ind] = ExternalIndex(ind1,ind2,method)
n = length(ind1);
a = 0;
b = 0;
c = 0;
d = 0;
for i = 1:n-1
    for j = i+1:n
        if ind1(i) == ind1(j)
           if ind2(i) == ind2(j)
              a = a + 1;
           else
              b = b + 1;
           end
        else
           if ind2(i) == ind2(j)
              c = c + 1;
           else
              d = d + 1;
           end
        end
    end
end
if strcmp(method,'JC') == 1
   ind = a/(a+b+c);
end
if strcmp(method,'FM') == 1
   ind = sqrt( (a/(a+b)) * (a/(a+c)) );
end
if strcmp(method,'Rand') == 1
   ind = 2*(a+d)/(n*(n-1));
end
end