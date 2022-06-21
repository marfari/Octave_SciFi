function y = gauss_eval(P, x)

exponent = (x-P(2))/(sqrt(2)*P(3));

y = P(1)*exp(-(exponent.^2));