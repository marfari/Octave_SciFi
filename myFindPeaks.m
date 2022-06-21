function [peaks positions] = myFindPeaks(data, min_peak_height, min_peak_distance)
%Próba zrobienia findpeaka, który będzie się spisywał lepiej niż ten oktawowy

ddata = [0; diff(data); 0];

I=find(data >= min_peak_height); %Pierwsze cięcie- wyrzucamy wszystko, co za niskie

ii = find(ddata(I) > 0);  %po lewej - zbocze narastające
I=I(ii);
ii = find(ddata(I+1) < 0);  %po prawej - zbocze opadające lub stałe
I=I(ii);

peaks = [];
positions = [];

  %Teraz sprawdzamy separacje od sąsiednich pików
for idx=1:length(I)
  i = I(idx);
  ok = 1;
  for dx=-min_peak_distance:min_peak_distance
    if ((i+dx) >= 1) && ((i+dx) <= length(data))
      if data(i+dx) > data(i)+0.0001
        ok = 0;
      end;
    end;
  end;
  if ok
    peaks(end+1) = data(i);
    positions(end+1) = i;
  end;
end;
        
 