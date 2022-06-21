function [displacement_px pins] = calculate_displacement_from_pins(pins, nominal_pos, pixel_size_um)
%Calculate mat displacement basing on pins.
%Identifies pin positions

if length(pins) == 0
  disp('  Sorry, displacement correction from pins not possible...')
  displacement_px = [0 0];
  return;
end;

nominal_pos = nominal_pos*1000/pixel_size_um; %milimeters to pixels

  %First, let's recognize which pin is which.
for pin_nr=1:length(pins)
  pin_pos = [pins(pin_nr).x pins(pin_nr).y];
  pin_pos2 = repmat(pin_pos,size(nominal_pos,1),1);
  distances = sqrt(sum((pin_pos2-nominal_pos).^2, 2));
  [M I] = min(distances);
  pins(pin_nr).position_index = I;
  indexes(pin_nr) = I;
end;

  %Then let's sort pins
[S I] = sort(indexes);
pins = pins(I);

  %Now, lets find displacements
for pin_nr = 1:length(pins)
  disp_x(pin_nr) = pins(pin_nr).x - nominal_pos(pins(pin_nr).position_index,1);
  disp_y(pin_nr) = pins(pin_nr).y - nominal_pos(pins(pin_nr).position_index,2);
end;

if length(pins) > 2
    %Normally, take central pin for X alignment and outer pins for Y alignment
  displacement_px = [-disp_x(ceil(length(pins)/2)) -mean(disp_y([1 end]))];
else
  disp('  Sorry, less than three pins detected, displacement correction from pins is simplified...')
  displacement_px = [-mean(disp_x) -mean(disp_y)];
end;