function rotation_rad = calculate_rotation_from_fibres(fibres)
%Calculates mat image rotation basing on fibres 

X = [];
Y = [];

for fibre_nr=1:length(fibres)
  X(end+1) = fibres(fibre_nr).x;
  Y(end+1) = fibres(fibre_nr).y;
end;

X = [X; ones(1,size(X,2))]';
Y = Y';

P = (X'*X)\(X'*Y);  %Least-square polynominal approximation

rotation_rad = atan(P(1));
