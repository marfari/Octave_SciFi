function fibres = displace_mat(fibres, displacement_px);
%displaces mat coordinates by [x y] pixels

fibres.all = displace_mat_helper(fibres.all, displacement_px);
fibres.backlight = displace_mat_helper(fibres.backlight, displacement_px);
fibres.frontlight = displace_mat_helper(fibres.frontlight, displacement_px);
fibres.bothlight = displace_mat_helper(fibres.bothlight, displacement_px);
fibres.nolight = displace_mat_helper(fibres.nolight, displacement_px);

end;


%**************************************

function fibres = displace_mat_helper(fibres, displacement)

for i=1:length(fibres)
  fibres(i).x = fibres(i).x + displacement(1);
  fibres(i).y = fibres(i).y + displacement(2);
end;

end;