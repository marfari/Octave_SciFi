function D=myDist(P)
%Odpowiednik funkcji dist

s=size(P,2);

for i=1:s
  for j=1:s
    D(i,j) = sqrt(sum((P(:,i) - P(:,j)) .^ 2));
  end;
end;