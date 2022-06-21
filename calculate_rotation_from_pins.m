function rotation_rad = calculate_rotation_from_pins(pins)
%Calculates mat image rotation basing on pins

X = [];
Y = [];

positions = zeros(1,3);

%for pin_nr=1:length(pins)
%  X(end+1) = pins(pin_nr).x;
%  Y(end+1) = pins(pin_nr).y;
%  positions(pins(pin_nr).position_index) = 1;
%end;

  %Use only outer pins
X = [pins(1).x pins(end).x];
Y = [pins(1).y pins(end).y];


%if sum(positions) < 2
%  disp('  Sorry, angle correction from pins not possible...')
%  rotation_rad = 0;
%  return;
%end;

if length(pins) < 2
  disp('  Sorry, angle correction from pins not possible...')
  rotation_rad = 0;
  return;
end;
  
X = [X; ones(1,size(X,2))]';
Y = Y';

P = (X'*X)\(X'*Y);  %Least-square polynominal approximation

rotation_rad = atan(P(1));
