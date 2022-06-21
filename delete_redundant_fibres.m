function [fibres deleted]= delete_redundant_fibres(fibres)
%Delete multiple fibre occourances from different images


[fibres.backlight deleted.backlight] = delete_redundant_fibres_helper(fibres.backlight);
[fibres.frontlight deleted.frontlight] = delete_redundant_fibres_helper(fibres.frontlight);
[fibres.bothlight deleted.bothlight] = delete_redundant_fibres_helper(fibres.bothlight);
[fibres.nolight deleted.nolight] = delete_redundant_fibres_helper(fibres.nolight);

end;

%****************************************************

function [data nr_deleted] = delete_redundant_fibres_helper(data)
%Delete multiple fibre occourances from different images

max_distance = 20; %20 px is the maximum distance between two occourances of the same fibre
max_distance_sq = max_distance^2;
nr_deleted = 0;

index = 1;
while index < length(data)
  x = data(index).x;
  y = data(index).y;
  I = find( (([data.x]-x).^2 + ([data.y]-y).^2) < max_distance_sq);
  I(find(I == index)) = []; %Don't delete myself!
  nr_deleted = nr_deleted + length(I);
  data(I) = [];
  index = index+1;
end;

end;