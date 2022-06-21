function fibres = rotate_mat(fibres, rotation_rad)
%Rotates mat by a given angle

fibres.all = rotate_mat_helper(fibres.all, rotation_rad);
fibres.backlight = rotate_mat_helper(fibres.backlight, rotation_rad);
fibres.frontlight = rotate_mat_helper(fibres.frontlight, rotation_rad);
fibres.bothlight = rotate_mat_helper(fibres.bothlight, rotation_rad);
fibres.nolight = rotate_mat_helper(fibres.nolight, rotation_rad);

end;


%**************************************

function fibres = rotate_mat_helper(fibres, rotation_rad)

for i=1:length(fibres)
  new_x = fibres(i).x*cos(rotation_rad) + fibres(i).y*sin(rotation_rad);
  new_y = fibres(i).y*cos(rotation_rad) - fibres(i).x*sin(rotation_rad);
  fibres(i).x = new_x;
  fibres(i).y = new_y;
end;

end;