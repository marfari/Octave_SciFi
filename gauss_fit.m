function p = gauss_fit(x,y)
%Fituje gaussem, zwraca wektor [gain mu sigma]

  %Na początek wartości startowe
EX = sum(x.*y)/sum(y);
VX = sum((x-EX).^2 .* y) / sum(y);
A = max(y);

  %Teraz spróbujemy dofitować
p0 = [A EX sqrt(VX)];  

[p fval] = fminsearch (@(p) sum((gauss_eval(p, x)-y).^2) , p0);
  
p(3) = abs(p(3)); %Bo może wyjść ujemna sigma