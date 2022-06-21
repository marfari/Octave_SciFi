function fibres = cut_mat(fibres, limits_mm, pixel_size_um)
%Obcina mat� do zadanego zakresu w pikselach
%Wywo�a� przed poszukaniem s�siad�w

fibre_nr = 1;

limits = limits_mm*1000/pixel_size_um;

X = [fibres.x];

I = find((X < limits(1)) | (X > limits(2)));

  %Najpierw inicjalizujemy parametr
for i=1:length(fibres)
  fibres(i).nevermind = 0;
end;
  %A potem go ustawiamy tam gdzie trzeba
for i=1:length(I)
  fibres(I(i)).nevermind = 1;
end;
  
