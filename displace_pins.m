function pins = displace_pins(pins, displacement_px);
%displaces mat coordinates by [x y] pixels

for i=1:length(pins)
  pins(i).x = pins(i).x + displacement_px(1);
  pins(i).y = pins(i).y + displacement_px(2);
end;

end;