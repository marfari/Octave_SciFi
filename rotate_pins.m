function pins = rotate_pins(pins, rotation_rad);
%displaces mat coordinates by [x y] pixels

for i=1:length(pins)
  new_x = pins(i).x*cos(rotation_rad) + pins(i).y*sin(rotation_rad);
  new_y = pins(i).y*cos(rotation_rad) - pins(i).x*sin(rotation_rad);
  pins(i).x = new_x;
  pins(i).y = new_y;
end;

end;